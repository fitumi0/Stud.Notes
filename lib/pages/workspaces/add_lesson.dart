import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proj/database/models/lesson.dart';
import 'package:flutter_proj/database/database_helper.dart';
import 'package:flutter_proj/pages/lessonspage.dart';

String _ddGroupp = "";
String _ddCourse = "";
DateTime selectedDate = DateTime.now();
int _ddDate = selectedDate.millisecondsSinceEpoch;
String _ddStartTime = "";
String _ddType = "";
String _lesson = "";
List<String> defaults = ["ПИ", "1", "10:00", "Лекция"];

class AddLessonPage extends StatefulWidget {
  const AddLessonPage({Key? key}) : super(key: key);

  @override
  _AddLessonPageState createState() => _AddLessonPageState();
}

class _AddLessonPageState extends State<AddLessonPage>
    with AutomaticKeepAliveClientMixin<AddLessonPage> {

  TextEditingController _controllerName = TextEditingController();
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

  List<String> groups = ["ПИ", "ИВТ", "БИ"];
  String? selectedGroup = "ПИ";

  List<String> courses = ["1", "2", "3", "4"];
  String? selectedCourse = '1';


  _changeName() {
    setState(() => _lesson = _controllerName.text);
  }

  @override
  void initState() {
    super.initState();
    _controllerName.text = _lesson;
    _controllerName.addListener(_changeName);
  }

  @override
  void dispose() {
    try {
      _controllerName.dispose();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новое занятие'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          child: WillPopScope(
            // TODO: ADD ONWILLPOP
            onWillPop: null,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _controllerName,
                    decoration: InputDecoration(
                        errorStyle:
                            const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        hintText: 'Название пары',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0))),
                    value: selectedGroup,
                    items: groups
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (item) => setState(() {
                      selectedGroup = item;
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
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
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
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
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
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
                  const SizedBox(
                    height: 20,
                  ),
                    Container(
                      child: SizedBox(
                        child: DatePicker(),
                        height: 40
                      ),
                    )

                ],
              ),

            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Save',
        onPressed: () {
          getDropDownValues();


          if (_controllerName.text.trim() != "" &&
              _ddGroupp != "" &&
              _ddCourse != "" &&
              _ddStartTime != "" &&
              _ddType != "") {
            Lesson lesson = Lesson(
                name: _controllerName.text.trim(),
                groupp: _ddGroupp,
                course: int.parse(_ddCourse),
                date: _ddDate,
                starttime: _ddStartTime,
                type: _ddType,
                state: 0,
            );
             DatabaseHelper.instance.insertLesson(lesson);
            ///
            /// TODO: ADD TO CALENDAR DATABASE
            ///
            ///
            showAlertDialog(context, true);

          }


          else {
            showAlertDialog(context, false);
          }
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  void getDropDownValues() {
    setState(() {
      _ddStartTime = selectedTime!;
      _ddGroupp = selectedGroup!;
      _ddCourse = selectedCourse!;
      _ddType = selectedType!;
    });
  }

  void resetDropDownValues() {
    setState(() {
      Navigator.of(context).pop();
      _controllerName.clear();
      selectedGroup = defaults[0];
      selectedCourse = defaults[1];
      selectedTime = defaults[2];
      selectedType = defaults[3];
    });
  }


  showAlertDialog(BuildContext context, bool a) {
    String text;
    if (a) {
      text =
          "Добавлено!";
      // print(_dbhelper.getLesson());
    } else {
      text = "Ошибка";
    }
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        if(a){
          resetDropDownValues();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Данные, взятые с формы заполнения"),
      content: Text(text),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DatePicker extends StatefulWidget {
  const DatePicker();

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
            ElevatedButton(
              onPressed: () {
                _selectDate(context);
              },
              child: const Text("Выберите дату"),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        helpText: "Выберите дату занятия",
        firstDate: DateTime(2010),
        lastDate: DateTime(2025),
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        _ddDate = selectedDate.millisecondsSinceEpoch;
      });
    }
  }
}