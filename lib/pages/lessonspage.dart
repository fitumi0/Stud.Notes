import 'package:flutter/material.dart';
import 'package:flutter_proj/pages/workspaces/StudMenu.dart';
import '../database/database_helper.dart';
import '../database/models/lesson.dart';
import 'workspaces/add_lesson.dart';

///
/// TODO: TWO TABS: LESSONS AND GROUPS
/// LESSONS:
/// TODO: ПАРСИТЬ С КАЛЕНДАРЯ ВСЕ ПРОШЕДШИЕ ПАРЫ
/// ПАРА ИМЕЕТ ТИП (СОГЛАСОВАТЬ): ЛАБА, ПРАКТИКА, ЛЕКЦИЯ, СЕМИНАР
/// ПАРА ИМЕЕТ СОСТОЯНИЕ: ПРОШЛА, ИДЁТ, ЗАПЛАНИРОВАНО
/// ОБЪЕКТ ПАРЫ: ГРУППА, НАЗВАНИЕ, ТИП, СОСТОЯНИЕ
///
bool trigger = true;

class LessonsPage extends StatelessWidget {
  const LessonsPage();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: [
                  Tab(
                    text: 'Занятия',
                  ),
                  Tab(
                    text: 'Студенты',
                  ),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LessonsTab(),
            StudGroupsPage(),
          ],
        ),
      ),
    );
  }
}

class LessonsTab extends StatefulWidget {
  const LessonsTab({Key? key}) : super(key: key);

  @override
  _LessonsTabState createState() => _LessonsTabState();
}

class _LessonsTabState extends State<LessonsTab>
    with AutomaticKeepAliveClientMixin<LessonsTab> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Lesson>>(
            future: DatabaseHelper.instance.getLessons(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Lesson>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                  ? Center(child: Text('Пусто'))
                  : ListView(
                children: snapshot.data!.map((lesson) {
                  return Center(
                    child: Card(
                      child: ListTile(
                        title: Text(lesson.name),
                        onTap: () {
                          setState(() {
                            // TODO: ITEM MENU
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            DatabaseHelper.instance.removeLesson(lesson.id!);
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'AddLessons',
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            child: Icon(Icons.close),
                          ),
                        ),
                      ),
                      Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(220, 50),
                                ),
                                child: Text("Submit"),
                                onPressed: () {
                                  setState(() {

                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => AddLessonPage(key: UniqueKey())));
          // setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class StudGroupsPage extends StatefulWidget {
  const StudGroupsPage({Key? key}) : super(key: key);

  @override
  _StudGroupsPageState createState() => _StudGroupsPageState();
}

class _StudGroupsPageState extends State<StudGroupsPage>
    with AutomaticKeepAliveClientMixin<StudGroupsPage> {
  // TODO: dynamic get all groups from db
  var groups = DatabaseHelper.instance.getGroups().toString();
/*      <String>[
        "ПИб-1 курс",
        "ПИб-2 курс",
        "ПИб-3 курс",
        "ПИб-4 курс",
        "ИВТ-1 курс",
        "ИВТ-2 курс",
        "ИВТ-3 курс",
        "ИВТ-4 курс"
      ];*/

  @override
  Widget build(BuildContext context) {
    // TODO: разобраться со структурой всей этой хуйни
    // TODO: сделать красивый ListTile, OnTap => парсим студентов (пока конст) и отображаем на экране
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return WillPopScope(
                onWillPop: null,
                child: ListTile(
                    title: Text('${groups[index]}'),
                    onTap: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return GetStudents();
                          },
                        ),
                      );
                    }),
              );
            },
          ),
        ),
      ),
      //TODO: DO ONE BUTTON FOR ONE PAGE UNIQ
      floatingActionButton: new FloatingActionButton(
        heroTag: 'AddGroup',
        onPressed: () {
          // TODO: ADD WINDOW TO ADD GROUPS
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class GetStudents extends StatefulWidget {
  const GetStudents();
  @override
  _GetStudentsState createState() => _GetStudentsState();
}

class _GetStudentsState extends State<GetStudents>
    with AutomaticKeepAliveClientMixin<GetStudents> {
  // TODO: dynamic get group id and get all students from DB
  // TODO: Add Button
  get students => <String>[
        "Петров",
        "Сидоров",
        "Ермолин",
        "Сидоров",
        "Ермолин",
        "Сидоров",
        "Ермолин",
        "Сидоров",
        "Ермолин",
        "Сидоров",
        "Ермолин"
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudNotes'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              return WillPopScope(
                onWillPop: null,
                child: ListTile(
                    title: Text('${students[index]}'),
                    onTap: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return StudentMenu();
                          },
                        ),
                      );
                    }),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'AddStudent',
        onPressed: () {
          // TODO: ADD WINDOW TO ADD STUDENTS
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
