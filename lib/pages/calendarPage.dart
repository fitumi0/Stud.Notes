import 'package:flutter/services.dart';
import 'package:flutter_proj/database/models/dropDownListModel.dart';
import 'package:flutter_proj/pages/workspaces/addLessonHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/pages/workspaces/themes.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../database/databaseHelper.dart';
import '../database/models/groupp.dart';
import '../database/models/lesson.dart';


String _ddLessonName = "";
String _ddGroupp = "";
int _ddCourse = 1;
int _ddStartTime = 0;
String _ddType = "";


// from milliseconds
int second = 1000;
int minute = second * 60;
int hour = minute * 60;
int lessonTime = minute * 90;
int restTime = minute * 15;
int lunchTime = minute * 45;
int day = 60000 * 1440;

DateTime timeFromSelected = DateTime.fromMillisecondsSinceEpoch(_ddStartTime);

int semesterEndInMilliseconds = timeFromSelected.month > 1 && timeFromSelected.month <= 6 ?
      DateTime(timeFromSelected.year, DateTime.june, 30).millisecondsSinceEpoch
    : DateTime(timeFromSelected.year, DateTime.december, 31).millisecondsSinceEpoch;

double weeksToEnd = (semesterEndInMilliseconds / (day * 7));


String? selectedTime = "10:00";

String? selectedType = 'Лекция';
String? selectedRR = 'Нет';
int recRule = 0;
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

  List<String> time = [
    "8:20",
    "10:00",
    "11:45",
    "14:00",
    "15:45",
    "17:20",
    "18:55",
  ];

  List<String> type = [
    "Лекция",
    "Практическое занятие",
    "Лабораторная работа",
    "Зачёт",
    "Экзамен"
  ];

  List<String> defaults = ["1", "10:00", "Лекция"];


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
            return const Center(
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
        animationDuration: const Duration(milliseconds: 400),
        overlayOpacity: 0.24,
        overlayColor: Colors.black,
        spacing: 10,
        // onOpen: (){},
        children: [
          SpeedDialChild(
              backgroundColor: const Color(wheatColor),
              child: const Icon(Icons.edit),
              label: "Предметы",
              labelBackgroundColor: const Color(wheatColor),
              onTap: () {
                selectedID = null;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: StatefulBuilder(
                            builder:
                            (BuildContext context, StateSetter setState) {
                          double height = MediaQuery.of(context).size.height;
                          double width = MediaQuery.of(context).size.width;
                          return Stack(
                            children: <Widget>[
                              _xMark(),
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
                                        width: width,
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
                                                                ? Color(mainColor)
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
                                      padding: const EdgeInsets.all(0),
                                      child: Column(
                                        children: [
                                          
                                          TextField(
                                            controller: _controllerLesson,
                                            decoration: InputDecoration(
                                                labelStyle: TextStyle(color: Color(lightGrey)),
                                                hintText: 'Название дисциплины',),
                                            onSubmitted: (value) {
                                              _addDiscipline();
                                              setState(() {
                                                _controllerLesson.text = "";
                                              });
                                            },
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: TextButton(
                                                    autofocus: true,
                                                    style: TextButton.styleFrom(
                                                      minimumSize:
                                                      const Size(50, 50),
                                                    ),
                                                    child: Text("Добавить"),
                                                    onPressed: () {
                                                      _addDiscipline();
                                                      setState(() {
                                                        _controllerLesson.text = "";
                                                      });
                                                    },
                                                  ),
                                              ),
                                              Flexible(
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      minimumSize:
                                                      const Size(50, 50),
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
                                              ),
                                              Flexible(
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      minimumSize:
                                                      const Size(50, 50),
                                                    ),
                                                    child: Text("Применить"),
                                                    onPressed: () {
                                                      setState(() {
                                                        Navigator.of(context).pop();
                                                      });
                                                    },
                                                  ),
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
                addLessonShowDialog();
                setState(() {

                });
              }),
          SpeedDialChild(
              backgroundColor: Color(wheatColor),
              child: Icon(Icons.refresh),
              label: "Обновить",
              labelBackgroundColor: Color(wheatColor),
              onTap: () {
                setState(() {

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

      switch(selectedRR){
        case "Нет":
          recRule = 0;
          break;
        case "Каждую неделю":
          recRule = 7;
          break;
        case "Каждые две недели":
          recRule = 14;
          break;
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

  resetDropDownValues() {
    Navigator.of(context).pop();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    selectedDate = DateTime.now().hour > 19 ? tomorrow : now;
    selectedCourse = defaults[0];
    selectedTime = defaults[1];
    selectedType = defaults[2];
    _bdController.text = "";
    _crController.text = "";
  }

  addLessonShowDialog() async {
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
                        Text("Новое занятие"),
                        SizedBox(height: 8,),
                        _buildDropDown(lessonsFromDB, selectedLesson, 0),
                        _title("Название занятия"),
                        _buildDropDown(groups, selectedGroup, 1),
                        _title("Группа"),
                        _buildDropDown(courses, selectedCourse, 2),
                        _title("Курс"),
                        _buildDropDown(time, selectedTime, 3),
                        _title("Время начала"),
                        _buildDropDown(type, selectedType, 4),
                        _title("Тип"),
                        _buildDropDown(["Нет", "Каждую неделю", "Каждые две недели"], selectedRR, 5),
                        _title("Дублирование"),
                        _buildTextArea(_bdController, "Корпус", 3, false, true),
                        _buildTextArea(_crController, "Аудитория", 5, false, true),

                        datePicker(),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size(width, 50),
                            ),
                            child: Text("Добавить"),
                            onPressed: () {
                              getDropDownValues();
                              if (_addLessonKey.currentState!.validate() &&
                                  _checkValues()) {
                                int curDate = selectedDate.millisecondsSinceEpoch;
                                int startTime = _ddStartTime;
                                switch (recRule){
                                  case 0:
                                    addLesson(curDate, startTime);
                                    break;
                                  case 7:
                                    while (curDate < semesterEndInMilliseconds){
                                      addLesson(curDate, startTime);
                                      curDate += (day * recRule);
                                      startTime += (day * recRule);
                                    }
                                    break;
                                  case 14:
                                    while (curDate < semesterEndInMilliseconds){
                                      addLesson(curDate, startTime);
                                      curDate += (day * recRule);
                                      startTime += (day * recRule);
                                    }
                                    break;
                                }
                              }
                              resetDropDownValues();
                              setState(() {

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
    return _ddLessonName != "" &&
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
    if(details.targetElement == CalendarElement.calendarCell){
      selectedDate = details.date!;
    }
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda && details.appointments!.isNotEmpty) {
      await _getGroupsFromDatabase();
      await _getLessonsListFromDatabase();
      late int id;
        id = await DatabaseHelper.instance.getLessonIDbyStartTime(details.appointments![0]);
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
                            _buildDropDown(lessonsFromDB, selectedLesson, 0),
                            _title("Название занятия"),
                            _buildDropDown(groups, selectedGroup, 1),
                            _title("Группа"),
                            _buildDropDown(courses, selectedCourse, 2),
                            _title("Курс"),
                            _buildDropDown(time, selectedTime, 3),
                            _title("Время начала"),
                            _buildDropDown(type, selectedType, 4),
                            _title("Тип"),
                            _buildDropDown(["Нет", "Каждую неделю", "Каждые две недели"], selectedRR, 5),
                            _title("Дублирование"),
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
                                decoration: InputDecoration(labelText: "Корпус",
                                    labelStyle: TextStyle(color: Color(lightGrey)
                                    )),
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
                                decoration: InputDecoration(labelText: "Аудитория",
                                    labelStyle: TextStyle(color: Color(lightGrey)
                                    )),
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
                                    );
                                    if (!await DatabaseHelper.instance
                                        .isLessonTimeInDataBase(lesson)) {
                                      DatabaseHelper.instance.updateLesson(lesson);
                                      resetDropDownValues();
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(snackTemplate("Изменено"));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackTemplate('Выберите другое время'));
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
      dataSource: LessonDataSource(collection), // dynamically updated information
      scheduleViewSettings: ScheduleViewSettings( // some settings to diffetent views
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
    if (calendarLongPressDetails.targetElement == CalendarElement.appointment){
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
                                  onPressed: () async {
                                    if (calendarLongPressDetails.targetElement ==
                                        CalendarElement.appointment ||
                                        calendarLongPressDetails.targetElement ==
                                            CalendarElement.agenda) {
                                      final Lesson appointmentDetails =
                                      calendarLongPressDetails
                                          .appointments![0];
                                      DatabaseHelper.instance
                                          .removeLesson(await DatabaseHelper.instance.getLessonIDbyStartTime(appointmentDetails));
                                    }
                                    setState(() {
                                      Navigator.of(context).pop();
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(snackTemplate("Удалено"));
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
    return Container(
      // padding: const EdgeInsets.only(left: 16.0, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // SizedBox(height: 10.0),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 14.0,
              color: Color(lightGrey),
            ),
          ),
          Divider(
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }

  _buildDropDown(List<String> itemsList, String? selectedItem, int dropDownID) {
    return SizedBox(
      height: 43,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down),
        value: selectedItem,
        items: itemsList
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item),
          onTap: (){
            setState(() {
              switch (dropDownID) {
                case 0: selectedLesson = item; break;
                case 1: selectedGroup = item; break;
                case 2: selectedCourse = item; break;
                case 3: selectedTime = item; break;
                case 4: selectedType = item; break;
                case 5: selectedRR = item; break;
              }
              selectedItem = item;
            });
          }
        ))
            .toList(),
        onChanged: (item){}
      ),
    );
  }

  _buildTextArea(TextEditingController controller, String label, int maxLen, bool kbType, bool inputFormatter) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Поле обязательно к заполнению";
          }
          return null;
        },
        controller: controller,
        maxLength: maxLen,
        decoration: InputDecoration(
            labelText: label, labelStyle: TextStyle(color: Color(lightGrey)
        )),
        keyboardType: kbType ? TextInputType.text : TextInputType.number,
        inputFormatters: inputFormatter ? <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ] : null
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

  SnackBar snackTemplate(String text) {
    return SnackBar(
      content: Text(text),
      backgroundColor: Color(mainColor),
      // behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1200),
      // margin: EdgeInsets.symmetric(
      //     vertical: 30.0, horizontal: 150.0),
      // elevation: 30,
    );
  }

  void addLesson(int date, int startTime) async {
    Lesson lesson = Lesson(
      name: _ddLessonName,
      building: int.parse(_bdController.text),
      classroom: int.parse(_crController.text),
      groupp: _ddGroupp,
      course: _ddCourse,
      date: date,
      starttime: startTime,
      type: _ddType,
      state: 0,
    );
    if (!await DatabaseHelper.instance
        .isLessonTimeInDataBase(lesson)) {
    DatabaseHelper.instance.insertLesson(lesson);
      ScaffoldMessenger.of(context)
                                      .showSnackBar(snackTemplate("Добавлено"));
    } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackTemplate('Выберите другое время'));
      // print("$date - занято");
                                }
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
  Color getColor(int index) {
    return Color(mainColor);
  }
}
