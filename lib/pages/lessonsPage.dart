import 'package:flutter/material.dart';
import 'package:flutter_proj/database/models/groupp.dart';
import 'package:flutter_proj/pages/workspaces/studMenu.dart';
import 'package:flutter_proj/pages/workspaces/themes.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../database/databaseHelper.dart';
import '../database/models/student.dart';



bool trigger = true;

class LessonsPage extends StatelessWidget {
  const LessonsPage();

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        body: StudGroupsPage(),
      ),
    );
  }
}


class StudGroupsPage extends StatefulWidget {
  const StudGroupsPage({Key? key}) : super(key: key);

  @override
  _StudGroupsPageState createState() => _StudGroupsPageState();
}

class _StudGroupsPageState extends State<StudGroupsPage>
    with AutomaticKeepAliveClientMixin<StudGroupsPage> {

  TextEditingController _controllerStudentFName = TextEditingController();
  TextEditingController _controllerStudentSName = TextEditingController();
  TextEditingController _controllerStudentSocial = TextEditingController();
  TextEditingController _controllerStudentGroup = TextEditingController();




  List<String> courses = ["1", "2", "3", "4"];
  String? selectedCourse = '1';

  final _addStudentKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder<List<Groupp>>(
              future: DatabaseHelper.instance.getGroupps(),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return snapshot.data!.isEmpty
                    ? Center(child: Text('Пусто'))
                    : ListView(
                  children: snapshot.data!.map((group) {
                    return Center(
                      child: Card(
                        child: ListTile(
                          title: Text("${group.name}-${group.course}"),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                  GetStudents("${group.name}", group.course),

                              ),
                            );
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
      ),
      floatingActionButton: SpeedDial(
        tooltip: "Меню",
        animatedIcon: AnimatedIcons.menu_close,
        animationDuration: Duration(milliseconds: 400),
        overlayOpacity: 0.24,
        overlayColor: Colors.black,
        spacing: 10,
        children: [
          SpeedDialChild(
              backgroundColor: Color(wheatColor),
              child: Icon(Icons.add),
              label: "Добавить студента",
              labelBackgroundColor: Color(wheatColor),
              onTap: () {
                addStudentShowDialog();
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

  @override
  bool get wantKeepAlive => true;

  final nameRegExp = RegExp(r'^[a-zA-Zа-яА-Я]+$');

  void addStudentShowDialog(){
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
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
                  },
                  child: CircleAvatar(
                    backgroundColor: Color(mainColor),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
              Form(
                key: _addStudentKey,
                child:  SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Добавить студента"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Поле обязательно к заполнению";
                          }
                          if (!nameRegExp.hasMatch(value.trim())){
                            return "Введите корректное значение";
                          }
                          return null;
                        },
                        controller: _controllerStudentFName,
                        maxLength: 25,
                        decoration: InputDecoration(labelText: "Имя"),
                      ),

                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Поле обязательно к заполнению";
                          }
                          if (!nameRegExp.hasMatch(value.trim())){
                            return "Введите корректное значение";
                          }
                          return null;
                        },
                        controller: _controllerStudentSName,
                        maxLength: 25,
                        decoration: InputDecoration(labelText: "Фамилия"),
                      ),

                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Поле обязательно к заполнению";
                          }
                          if (!nameRegExp.hasMatch(value.trim())){
                            return "Введите корректное значение";
                          }
                          return null;
                        },
                        controller: _controllerStudentGroup,
                        maxLength: 10,
                        decoration: InputDecoration(labelText: "Группа"),
                      ),

                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down),
                          value: selectedCourse,
                          items: courses
                              .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),)).toList(),
                              onChanged: (item) => setState(() {
                                selectedCourse = item;
                              })
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // SizedBox(height: 10.0),
                          Text(
                            "КУРС",
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
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _controllerStudentSocial,
                        decoration: InputDecoration(
                            errorStyle:
                            const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Связь (e-mail, VK)',),
                      ),

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
                            if(_addStudentKey.currentState!.validate()){
                              Student student = Student(
                                firstname: _controllerStudentFName.text.trim(),
                                secondname: _controllerStudentSName.text.trim(),
                                groupp: _controllerStudentGroup.text.trim().toUpperCase(),
                                course: int.parse(selectedCourse!),
                                social: _controllerStudentSocial.text.trim(),
                                rating: 0,
                                debt: "",
                              );
                              Groupp group = Groupp(
                                  name: _controllerStudentGroup.text.trim().toUpperCase(),
                                  course: int.parse(selectedCourse!)
                              );
                              DatabaseHelper.instance.insertGroupp(group);
                              DatabaseHelper.instance.insertStudents(student);
                              Navigator.of(context).pop();
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

  void addGroupShowDialog() {
    print(SfCalendar.generateRRule(RecurrenceProperties(startDate: DateTime.now()),
        DateTime.now(), DateTime.now().add(Duration(hours: 5))));
  }

}

class GetStudents extends StatefulWidget {
  final String group;
  final int course;
  const GetStudents(this.group, this.course);


  @override
  _GetStudentsState createState() => _GetStudentsState();
}

class _GetStudentsState extends State<GetStudents>
    with AutomaticKeepAliveClientMixin<GetStudents> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("${widget.group}-${widget.course}"),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<List<Student>>(
              future: DatabaseHelper.instance.getStudentsFromGroup("${widget.group}", widget.course),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return snapshot.data!.isEmpty
                    ? Center(child: Text('Пусто'))
                    : ListView(
                  children: snapshot.data!.map((student) {
                    return Center(
                      child: Card(
                        child: ListTile(
                          title: Text(student.secondname + " " + student.firstname),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                  getStudentMenu(student: student),
                              ),
                            );
                            setState(() {});
                          },
                          onLongPress: () {

                            setState(() {
                              DatabaseHelper.instance.removeStudents(student.id!);
                              if (snapshot.data!.length == 1){
                              DatabaseHelper.instance.removeGroupp(student.groupp, student.course);
                              Navigator.pop(context);
                            }
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

    );
  }

  @override
  bool get wantKeepAlive => true;
}

