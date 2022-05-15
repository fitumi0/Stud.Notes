
import 'package:flutter/services.dart';
import 'package:flutter_proj/database/models/DropDownListModel.dart';
import 'package:flutter_proj/pages/workspaces/add_lesson_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../database/database_helper.dart';
import '../database/models/lesson.dart';
import '../database/models/student.dart';

///
/// CALENDAR FEATURES:
/// 4) КАСТОМ РАСПИСАНИЯ:
///    - ДВЕ НЕДЕЛИ, НА КАЖДЫЙ ДЕНЬ МОЖНО ЗАБИНДИТЬ БАРЫ
///    - ЭТИ ПАРЫ ДУБЛИРУЮТСЯ НА ВЕСЬ СЕМЕСТР
///    - НАЧАЛО НОВОГО СЕМЕСТРА => НАСТРОЙКА
/// TODO: ADD FEATURES
///

String _ddLessonName = "";
String _ddGroupp = "";
int _ddCourse = 1;
int _ddStartTime = 0;
String _ddType = "";
List<String> defaults = ["1", "10:00", "Лекция"];

// from milliseconds
int second = 1000;
int minute = second * 60;
int hour = minute * 60;
int lessonTime = minute * 90;
int restTime = minute * 15;
int lunchTime = minute * 45;
int day = 60000 * 1440;

List<String> time = [
  "8:20",
  "10:00",
  "11:45",
  "14:00",
  "15:45",
  "17:20",
  "18:55",
];
String? selectedTime = "10:00";

List<String> type = [
  "Лекция",
  "Практика",
  "Лабораторная",
  "Зачёт",
];
String? selectedType = 'Лекция';

late String? selectedGroup;
List<String> groups = [" "];
String? selectedLesson = " ";
List<String> lessonsFromDB = [" "];
List<String> courses = ["1", "2", "3", "4"];
String? selectedCourse = '1';

class CalendarPage extends StatefulWidget{
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>{
  final TextEditingController _controllerLesson = TextEditingController();
  final TextEditingController _crController = TextEditingController();
  final TextEditingController _bdController = TextEditingController();
  final _addLessonKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _crController.addListener(() {
      final String text = _crController.text.toLowerCase();
      _crController.value = _crController.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _bdController.addListener(() {
      final String text = _bdController.text.toLowerCase();
      _bdController.value = _bdController.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _crController.dispose();
    _bdController.dispose();
    super.dispose();
  }

  int? selectedID;
  String? _subjectText = '',
      _startTimeText = '',
      _dateText = '',
      _timeDetails = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Lesson>>(
        future: DatabaseHelper.instance.getLessons(),
        builder: (context, snapshot) {
          List<Lesson> collection = <Lesson>[];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
            double height = MediaQuery.of(context).size.height;
            return snapshot.data!.isEmpty
                ? Center(child: calendarItem(collection))
                : ListView.builder(
                itemCount: 1,
                itemExtent: height / 1.165,
                itemBuilder: (context, int pos) {
                  for (var item in snapshot.data!) {
                    collection.add(
                      Lesson(
                        name: item.name,
                        building: item.building,
                        classroom: item.classroom,
                        groupp: item.groupp,
                        course: item.course,
                        date: item.date,
                        starttime: item.starttime,
                        type: item.type,
                        state: item.state,
                      )
                    );
                }
                return calendarItem(collection);
                }
            );
    },

    ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animationDuration: Duration(milliseconds: 400),
        overlayOpacity: 0.24,
        overlayColor: Colors.black,
        spacing: 10,
        onOpen: () {
          _getGroupsFromDatabase();
          _getLessonsListFromDatabase();
        },
        children: [
          SpeedDialChild(
            child: Icon(Icons.settings),
            label: "Настройки",
            onTap: (){
              selectedID = null;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            double height = MediaQuery.of(context).size.height;
                            return Stack(

                              children: <Widget>[
                                Form(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("Список предметов"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: height / 3,
                                          width: 300.0,
                                          child: FutureBuilder<
                                              List<DropDownListModel>>(
                                              future: DatabaseHelper.instance
                                                  .getLessonsDropDownList(),
                                              builder: (BuildContext context,
                                                  snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                      child: Text(
                                                          'Loading...'));
                                                }
                                                return snapshot.data!.isEmpty
                                                    ? Center(
                                                    child: Text('Пусто'))
                                                    : ListView(
                                                  shrinkWrap: true,
                                                  children: snapshot.data!
                                                      .map((lesson) {
                                                    return Center(
                                                      child: Card(
                                                        color: selectedID ==
                                                            lesson.id
                                                            ? Colors.red
                                                            : Colors.white,
                                                        child: ListTile(
                                                          title: Text(
                                                              lesson.name),
                                                          onTap: () {
                                                            setState(() {
                                                              selectedID =
                                                                  lesson.id;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              }),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: _controllerLesson,
                                              decoration: InputDecoration(
                                                  errorStyle:
                                                  const TextStyle(
                                                      color: Colors.redAccent,
                                                      fontSize: 16.0),
                                                  hintText: 'Название дисциплины',

                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(16.0))),
                                              onSubmitted: (value) {
                                                _addDiscipline();
                                                setState(() {
                                                  _controllerLesson
                                                      .text = "";
                                                });
                                              },
                                            ),
                                            Row(
                                              children: [
                                                TextButton(
                                                  autofocus: true,
                                                  style: TextButton.styleFrom(
                                                    minimumSize: const Size(
                                                        100, 50),
                                                  ),
                                                  child: Text("Добавить"),
                                                  onPressed: () {
                                                    _addDiscipline();
                                                    setState(() {
                                                      _controllerLesson
                                                          .text = "";
                                                    });
                                                  },

                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    minimumSize: const Size(
                                                        100, 50),
                                                  ),
                                                  child: Text("Удалить"),
                                                  onPressed: () {
                                                    setState(() {
                                                      DatabaseHelper.instance.removeFromLessonsDropDownList(selectedID!);
                                                      selectedID = null;
                                                    });
                                                  },
                                                ),

                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    minimumSize: const Size(
                                                        100, 50),
                                                  ),
                                                  child: Text("Применить"),
                                                  onPressed: () {
                                                    setState(() {
                                                      Navigator.of(context).pop();
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                    );
                  });

            }
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            label: "Добавить",
            onTap: () {
              setState(() {
              addLessonShowDialog();
            });
            }
          ),
        ],
      ),
    );

  }


  void getDropDownValues() {
    setState(() {
      switch(selectedTime!){
        case("8:20"):{
          _ddStartTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 8, 20, 0).millisecondsSinceEpoch;
          break;
        }
        case("10:00"):{
          _ddStartTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 10, 00, 0).millisecondsSinceEpoch;
          break;
        }
        case("11:45"):{
          _ddStartTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 11, 45, 0).millisecondsSinceEpoch;
          break;
        }
        case("14:00"):{
          _ddStartTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 14, 0, 0).millisecondsSinceEpoch;
          break;
        }
        case("15:45"):{
          _ddStartTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 15, 45, 0).millisecondsSinceEpoch;
          break;
        }
        case("17:20"):{
          _ddStartTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 17, 20, 0).millisecondsSinceEpoch;
          break;
        }
        case("18:55"):{
          _ddStartTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 18, 55, 0).millisecondsSinceEpoch;
          break;
        }
      }
      if(selectedLesson != null && selectedLesson != " "){
        _ddLessonName = selectedLesson!;
      }
      else{
        _ddLessonName = "";
      }
      if (selectedGroup != null && selectedGroup != " "){
        _ddGroupp = selectedGroup!;
      }
      else{
        _ddGroupp = "";
      }
      _ddCourse = int.parse(selectedCourse!);
      _ddType = selectedType!;


    });
  }

  void resetDropDownValues() {
    setState(() {
      Navigator.of(context).pop();
      selectedCourse = defaults[0];
      selectedTime = defaults[1];
      selectedType = defaults[2];
      _bdController.text = "";
      _crController.text = "";
    });
  }

  void addLessonShowDialog() {
    double width = MediaQuery.of(context).size.width;
    selectedGroup = groups[0];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(

              clipBehavior: Clip.none, children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                    resetDropDownValues();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close),
                  ),
                ),
              ),
              Form(
                key: _addLessonKey,
                child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5.2),
                    child: Text("Новое занятие"),
                  ),


                  Padding(
                    padding: EdgeInsets.all(5.2),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0))),
                      value: selectedLesson,
                      items: lessonsFromDB
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                          .toList(),
                      onChanged: (selectedLesson != null || selectedLesson!.trim() != "") ? (item) => setState(() => selectedLesson = item) : null,
                    ),

                  ),

                  Padding(
                    padding: EdgeInsets.all(5.2),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0))
                      ),
                      value: selectedGroup,
                      items: groups
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                          .toList(),
                      onChanged: selectedGroup != null ? (item) => setState(() => selectedGroup = item) : null,
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(5.2),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          errorStyle:
                          const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0))),
                      value: selectedCourse,
                      items: courses
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                          .toList(),
                      onChanged: (item) => setState(() {
                        selectedCourse = item;
                      }),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(5.2),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          errorStyle:
                          const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0))),
                      value: selectedTime,
                      items: time
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                          .toList(),
                      onChanged: (item) => setState(() {
                        selectedTime = item;
                      }),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(5.2),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          errorStyle:
                          const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0))),
                      value: selectedType,
                      items: type
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                          .toList(),
                      onChanged: (item) => setState(() {
                        selectedType = item;
                      }),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(5.2),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Поле обязательно к заполнению";
                        }
                        return null;
                      },
                      controller: _bdController,
                      maxLength: 3,
                      decoration: InputDecoration(labelText: "Корпус"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(5.2),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Поле обязательно к заполнению";
                        }
                        return null;
                      },
                      controller: _crController,
                      maxLength: 5,
                      decoration: InputDecoration(labelText: "Аудитория"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),

                  ),
                  Padding(
                      padding: EdgeInsets.all(5.2),
                      child: SizedBox(
                          child: DatePicker(),
                          height: 40
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.2),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(width, 50),
                      ),
                      child: Text("Добавить"),
                      onPressed: () async {
                        setState(() {
                          getDropDownValues();
                          if (_addLessonKey.currentState!.validate() && _checkValues()) {
                            Lesson lesson = Lesson(
                              name: _ddLessonName,
                              building: int.parse(_bdController.text),
                              classroom: int.parse(_crController.text),
                              groupp: _ddGroupp,
                              course: _ddCourse,
                              date: selectedDate.millisecondsSinceEpoch,
                              starttime: _ddStartTime,
                              type: _ddType,
                              state: 0,
                            );

                            DatabaseHelper.instance.insertLesson(lesson);
                            resetDropDownValues();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Добавлено'),
                                  backgroundColor: Colors.blueGrey,
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(milliseconds: 1200),
                                  margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 150.0),
                                  elevation: 30,
                                )
                            );
                          }
                        });
                      },
                    ),
                  )
                ],
                ),
                ),
              ),
            ],
            ),
          );
        });
  }

  bool _checkValues() {
    try {
      int.parse(_crController.text);
      int.parse(_bdController.text);
      return (_ddLessonName != "" &&
        _ddGroupp != "");
      }
      catch (e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Проверьте корректность данных'),
              duration: Duration(milliseconds: 1200),
              backgroundColor: Colors.blueGrey,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 150.0),
              elevation: 30,
            )
        );
        return false;
      }
  }
  _getGroupsFromDatabase() async {
    List<Student> temp =  await DatabaseHelper.instance.getGroupsFromStudents();
    groups.clear();
    if(temp.isNotEmpty){
      for (var i in temp){
        if (!groups.contains(i.groupp)){
          groups.add(i.groupp);
        }
      }
      groups.remove(" ");
      selectedGroup = groups[0];
    }
    else {
      groups = [" "];
      selectedGroup = " ";
    }
  }

  _getLessonsListFromDatabase() async {
    List<DropDownListModel> temp =  await DatabaseHelper.instance.getLessonsDropDownList();
    lessonsFromDB.clear();
    if(temp.isNotEmpty) {
      for (var i in temp){
        if (!lessonsFromDB.contains(i.name)){
          lessonsFromDB.add(i.name);
        }
      }
      lessonsFromDB.remove(" ");
      selectedLesson = lessonsFromDB[0];
    }
    else {
      lessonsFromDB = [" "];
      selectedLesson = " ";
    }
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Lesson appointmentDetails = details.appointments![0];
      _subjectText = "${appointmentDetails.name} ${appointmentDetails.groupp}-${appointmentDetails.course}\n${appointmentDetails.type} ${appointmentDetails.building}-${appointmentDetails.classroom}";
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(appointmentDetails.starttime))
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(appointmentDetails.starttime)).toString();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('$_subjectText'),
              content: SizedBox(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '$_startTimeText\n$_dateText',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(_timeDetails!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Закрыть'))
              ],
            );
          });
    }
  }

  Widget calendarItem(List<Lesson> collection) {
    return SfCalendar(
      onTap: calendarTapped,
      showDatePickerButton: true,
      allowViewNavigation: true,
      allowedViews: const <CalendarView>
      [
        CalendarView.day,
        CalendarView.week,
        CalendarView.month,
        CalendarView.schedule
      ],
      initialSelectedDate: DateTime.now(),
      firstDayOfWeek: 1,
      view: CalendarView.month,
      dataSource: LessonDataSource(collection),
      monthViewSettings:  MonthViewSettings(
          showAgenda: true,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
      ),
      appointmentTextStyle: const TextStyle(
          fontFamily: "Montserrat-SemiBold",
          fontSize: 12,
          color: Colors.black
      ),
      headerStyle: const CalendarHeaderStyle(
        textStyle: TextStyle(
            fontFamily: "Montserrat-SemiBold",
            fontSize: 20,
            color: Colors.black
        ),
      ),
      viewHeaderStyle: ViewHeaderStyle(
          dayTextStyle: TextStyle(
              fontFamily: "Montserrat-SemiBold",
              fontSize: 16,
              color: Colors.black
          )
      ),
    );
  }

  void _addDiscipline() {

    if(_controllerLesson
        .text.isNotEmpty){
      DatabaseHelper.instance
          .insertIntoLessonsDropDownList(
          DropDownListModel(
              name: _controllerLesson
                  .text));
    }
  }
}

class LessonDataSource extends CalendarDataSource {
  LessonDataSource(List<Lesson> source){
    appointments = source;
  }


  @override
  String getSubject(int index) {
    return "${appointments![index].name} ${appointments![index].groupp}-${appointments![index].course} ${appointments![index].type} ${appointments![index].building}-${appointments![index].classroom}";
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.fromMillisecondsSinceEpoch(appointments![index].starttime);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.fromMillisecondsSinceEpoch(appointments![index].starttime + 600000 * 9);
  }


}

