import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proj/database/models/dropDownListModel.dart';
import 'package:flutter_proj/pages/workspaces/addLessonHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/pages/workspaces/themes.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../database/databaseHelper.dart';
import '../database/models/groupp.dart';
import '../database/models/lesson.dart';


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
  "Практическое занятие",
  "Лабораторная работа",
  "Зачёт",
];
String? selectedType = 'Лекция';
late bool alreadyInDatabase;

late String? selectedGroup;
List<String> groups = [" "];
String? selectedLesson = " ";
List<String> lessonsFromDB = [" "];
List<String> courses = [" "];
String? selectedCourse = ' ';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);


  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
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
                      collection.add(Lesson(
                        name: item.name,
                        building: item.building,
                        classroom: item.classroom,
                        groupp: item.groupp,
                        course: item.course,
                        date: item.date,
                        starttime: item.starttime,
                        type: item.type,
                        state: item.state,
                        recurrenceRule: item.recurrenceRule,
                      ));
                    }
                    return calendarItem(collection);
                  });
        },
      ),
      floatingActionButton: SpeedDial(
        tooltip: "Меню",
        animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(
        //   color: Color(black)
        // ),
        animationDuration: Duration(milliseconds: 400),
        overlayOpacity: 0.24,
        overlayColor: Colors.black,
        spacing: 10,
        // onOpen: (){},
        children: [
          SpeedDialChild(
              backgroundColor: Color(wheatColor),
              child: Icon(Icons.settings),
              label: "Настройки",
              labelBackgroundColor: Color(wheatColor),
              onTap: () {
                selectedID = null;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
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
                                                    child: Text('Loading...'));
                                              }
                                              return snapshot.data!.isEmpty
                                                  ? Center(child: Text('Пусто'))
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
                                                errorStyle: const TextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 16.0),
                                                hintText: 'Название дисциплины',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0))),
                                            onSubmitted: (value) {
                                              _addDiscipline();
                                              setState(() {
                                                _controllerLesson.text = "";
                                              });
                                            },
                                          ),
                                          Row(
                                            children: [
                                              TextButton(
                                                autofocus: true,
                                                style: TextButton.styleFrom(
                                                  minimumSize:
                                                      const Size(100, 50),
                                                ),
                                                child: Text("Добавить"),
                                                onPressed: () {
                                                  _addDiscipline();
                                                  setState(() {
                                                    _controllerLesson.text = "";
                                                  });
                                                },
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  minimumSize:
                                                      const Size(100, 50),
                                                ),
                                                child: Text("Удалить"),
                                                onPressed: () {
                                                  setState(() {
                                                    DatabaseHelper.instance
                                                        .removeFromLessonsDropDownList(
                                                            selectedID!);
                                                    selectedID = null;
                                                  });
                                                },
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  minimumSize:
                                                      const Size(100, 50),
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
              }),
          SpeedDialChild(
              backgroundColor: Color(wheatColor),
              child: Icon(Icons.add),
              label: "Добавить",
              labelBackgroundColor: Color(wheatColor),
              onTap: () {
                setState(() {
                  addLessonShowDialog();
                });
              }),
        ],
      ),
    );
  }

  void getDropDownValues() {
    setState(() {
      switch (selectedTime!) {
        case ("8:20"):
          {
            _ddStartTime = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, 8, 20, 0)
                .millisecondsSinceEpoch;
            break;
          }
        case ("10:00"):
          {
            _ddStartTime = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, 10, 00, 0)
                .millisecondsSinceEpoch;
            break;
          }
        case ("11:45"):
          {
            _ddStartTime = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, 11, 45, 0)
                .millisecondsSinceEpoch;
            break;
          }
        case ("14:00"):
          {
            _ddStartTime = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, 14, 0, 0)
                .millisecondsSinceEpoch;
            break;
          }
        case ("15:45"):
          {
            _ddStartTime = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, 15, 45, 0)
                .millisecondsSinceEpoch;
            break;
          }
        case ("17:20"):
          {
            _ddStartTime = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, 17, 20, 0)
                .millisecondsSinceEpoch;
            break;
          }
        case ("18:55"):
          {
            _ddStartTime = DateTime(selectedDate.year, selectedDate.month,
                    selectedDate.day, 18, 55, 0)
                .millisecondsSinceEpoch;
            break;
          }
      }
      if (selectedLesson != null && selectedLesson != " ") {
        _ddLessonName = selectedLesson!;
      } else {
        _ddLessonName = "";
      }
      if (selectedGroup != null && selectedGroup != " ") {
        _ddGroupp = selectedGroup!;
      } else {
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

  void addLessonShowDialog() async {
    double width = MediaQuery.of(context).size.width;
    selectedGroup = groups[0];
    await _getGroupsFromDatabase();
    await _getLessonsListFromDatabase();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                _xMark(),
                Form(
                  key: _addLessonKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(0),
                          child: Text("Новое занятие"),
                        ),
                        _title("Название занятия"),
                        _buildDropDown(lessonsFromDB, selectedLesson),
                        _title("Группа"),
                        _buildDropDown(groups, selectedGroup),
                        _title("Курс"),
                        _buildDropDown(courses, selectedCourse),
                        _title("Время начала"),
                        _buildDropDown(time, selectedTime),
                        _title("Тип"),
                        _buildDropDown(type, selectedType),
                        Padding(
                          padding: EdgeInsets.all(0),
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
                          padding: EdgeInsets.all(0),
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
                        datePicker(),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size(width, 50),
                            ),
                            child: Text("Добавить"),
                            onPressed: () async {
                              getDropDownValues();
                              if (_addLessonKey.currentState!.validate() &&
                                  _checkValues()) {
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
                                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1',
                                );
                                if (!await DatabaseHelper.instance
                                    .isLessonTimeInDataBase(lesson)) {
                                  DatabaseHelper.instance.insertLesson(lesson);
                                  resetDropDownValues();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Добавлено'),
                                    backgroundColor: Colors.blueGrey,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(milliseconds: 1200),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 30.0, horizontal: 150.0),
                                    elevation: 30,
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Выберите другое время'),
                                    backgroundColor: Colors.blueGrey,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(milliseconds: 1200),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 30.0, horizontal: 150.0),
                                    elevation: 30,
                                  ));
                                }
                              }
                              setState(() {});
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
    return _ddStartTime > DateTime.now().millisecondsSinceEpoch &&
    _ddLessonName != "" &&
    _ddGroupp != "" &&
    _ddCourse != "";
  }

  _getGroupsFromDatabase() async {
    groups.clear();
    courses.clear();
    List<Groupp> tempGroupps = await DatabaseHelper.instance.getGroupps();
    if (tempGroupps.isNotEmpty) {
      for (var i in tempGroupps) {
        if (!groups.contains(i.name)) {
          groups.add(i.name);
        }
        if (!courses.contains(i.course.toString())) {
          courses.add(i.course.toString());
        }
      }
      groups.remove(" ");
      courses.remove(" ");
      selectedGroup = groups[0];
      selectedCourse = courses[0];
    } else {
      groups = [" "];
      selectedGroup = " ";
      courses = [" "];
      selectedCourse = " ";
    }
  }

  _getLessonsListFromDatabase() async {
    List<DropDownListModel> temp =
        await DatabaseHelper.instance.getLessonsDropDownList();
    lessonsFromDB.clear();
    if (temp.isNotEmpty) {
      for (var i in temp) {
        if (!lessonsFromDB.contains(i.name)) {
          lessonsFromDB.add(i.name);
        }
      }
      lessonsFromDB.remove(" ");
      selectedLesson = lessonsFromDB[0];
    } else {
      lessonsFromDB = [" "];
      selectedLesson = " ";
    }
  }

  void calendarTapped(CalendarTapDetails details) async {
    // print("##############################");
    // print(details.appointments![0].recurrenceRule);
    // print(details.appointments![0].appointmentType);
    // print(details.appointments);
    // print("##############################");
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda && details.appointments!.isNotEmpty) {
      await _getGroupsFromDatabase();
      await _getLessonsListFromDatabase();
        // if (details.appointments![0].recurrenceRule != null){
          int id = await DatabaseHelper.instance.getLessonID(details.appointments![0].starttime);
        // }
        double width = MediaQuery.of(context).size.width;
        selectedGroup = groups[0];
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    _xMark(),
                    Form(
                      key: _addLessonKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(0),
                              child: Text("Редактирование занятия"),
                            ),
                            _title("Название занятия"),
                            _buildDropDown(lessonsFromDB, selectedLesson),
                            _title("Группа"),
                            _buildDropDown(groups, selectedGroup),
                            _title("Курс"),
                            _buildDropDown(courses, selectedCourse),
                            _title("Время начала"),
                            _buildDropDown(time, selectedTime),
                            _title("Тип"),
                            _buildDropDown(type, selectedType),
                            _title("Дублирование"),
                            _buildDropDown(["Нет", "Каждую неделю", "Каждые две недели"], "Нет"),
                            Padding(
                              padding: EdgeInsets.all(0),
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
                              padding: EdgeInsets.all(0),
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
                            datePicker(),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(width, 50),
                                ),
                                child: Text("Внести изменения"),
                                onPressed: () async {
                                  getDropDownValues();
                                  if (_addLessonKey.currentState!.validate() &&
                                      _checkValues()) {
                                    Lesson lesson = Lesson(
                                      id: id,
                                      name: _ddLessonName,
                                      building: int.parse(_bdController.text),
                                      classroom: int.parse(_crController.text),
                                      groupp: _ddGroupp,
                                      course: _ddCourse,
                                      date: selectedDate.millisecondsSinceEpoch,
                                      starttime: _ddStartTime,
                                      type: _ddType,
                                      state: 0,
                                      recurrenceRule: '',
                                    );
                                      DatabaseHelper.instance.updateLesson(lesson);
                                      resetDropDownValues();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Изменено!'),
                                        backgroundColor: Colors.blueGrey,
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(milliseconds: 1200),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 30.0, horizontal: 150.0),
                                        elevation: 30,
                                      ));
                                  }
                                  setState(() {});
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
    else null;
  }

  Widget calendarItem(List<Lesson> collection) {
    return SfCalendar(
      onTap: calendarTapped,
      onLongPress: deleteNote,
      showDatePickerButton: true,
      allowViewNavigation: true,
      allowedViews: const <CalendarView>[
        CalendarView.day,
        CalendarView.week,
        CalendarView.month,
        CalendarView.schedule
      ],
      initialSelectedDate: DateTime.now(),
      firstDayOfWeek: 1,
      view: CalendarView.month,
      dataSource: LessonDataSource(collection),
      scheduleViewSettings: ScheduleViewSettings(
        appointmentTextStyle: AppointmentStyle(),
      ),
      monthViewSettings: MonthViewSettings(
          showAgenda: true,
          agendaStyle: AgendaStyle(
              appointmentTextStyle: AppointmentStyle(),
          ),
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      appointmentTextStyle: AppointmentStyle(),
      headerStyle: const CalendarHeaderStyle(
        textStyle: TextStyle(
            fontFamily: "Montserrat-Regular",
            fontSize: 20,
            color: Colors.black),
      ),
      viewHeaderStyle: ViewHeaderStyle(
          dayTextStyle: TextStyle(
              fontFamily: "Montserrat-Regular",
              fontSize: 16,
              color: Colors.black)),
    );
  }

  void _addDiscipline() {
    if (_controllerLesson.text.isNotEmpty) {
        DatabaseHelper.instance.insertIntoLessonsDropDownList(
            DropDownListModel(name: _controllerLesson.text));
      }
  }

  void deleteNote(CalendarLongPressDetails calendarLongPressDetails) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                _xMark(),
                Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Удалить запись?"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () {
                                  if (calendarLongPressDetails.targetElement ==
                                          CalendarElement.appointment ||
                                      calendarLongPressDetails.targetElement ==
                                          CalendarElement.agenda) {
                                    final Lesson appointmentDetails =
                                        calendarLongPressDetails
                                            .appointments![0];
                                    DatabaseHelper.instance
                                        .removeLessonByDateAndTime(
                                            appointmentDetails.date,
                                            appointmentDetails.starttime);
                                  }
                                  setState(() {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Запись удалена'),
                                      backgroundColor: Colors.blueGrey,
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(milliseconds: 1200),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 30.0, horizontal: 150.0),
                                      elevation: 30,
                                    ));
                                  });
                                },
                                child: const Text("Удалить"),
                              )),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Отмена"),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Padding datePicker() {
    return Padding(
        padding: EdgeInsets.all(0),
        child: SizedBox(child: DatePicker(), height: 55));
  }

  TextStyle AppointmentStyle() {
    return const TextStyle(
        fontFamily: "Montserrat-SemiBold", fontSize: 12, color: Colors.black);
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // SizedBox(height: 10.0),
          Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 18.0),
          ),
          Divider(
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }

  _buildDropDown(List<String> lessonsFromDB, String? selectedLesson) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: DropdownButtonFormField<String>(
        icon: Icon(Icons.keyboard_arrow_down),
        decoration: InputDecoration(
            border: OutlineInputBorder()),
        value: selectedLesson,
        items: lessonsFromDB
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        ))
            .toList(),
        onChanged: (selectedLesson != null ||
            selectedLesson!.trim() != "")
            ? (item) =>
            setState(() => selectedLesson = item)
            : null,
      ),
    );
  }

  _xMark() {
    return Positioned(
      right: -40.0,
      top: -40.0,
      child: InkResponse(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: CircleAvatar(
          backgroundColor: Color(mainColor),
          child: Icon(Icons.close, color: Colors.black,),
        ),
      ),
    );
  }
}

class LessonDataSource extends CalendarDataSource {
  LessonDataSource(List<Lesson> source) {
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
    return DateTime.fromMillisecondsSinceEpoch(
        appointments![index].starttime + 600000 * 9);
  }

  @override
  String? getRecurrenceRule(int index) {
    return appointments![index].recurrenceRule;
  }
  @override
  Color getColor(int index) {
    return Color(mainColor);
  }
}
