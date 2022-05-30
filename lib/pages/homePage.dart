import 'package:flutter/material.dart';

import '../database/databaseHelper.dart';
import '../database/models/lesson.dart';
import 'calendarPage.dart';
import 'lessonsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            children: <Widget>[
              Text("Ближайшие занятия:"),
              Expanded(
                  child: LessonsTab()
              )
            ]
        )
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        tooltip: "Обновить содержимое",
        onPressed: () {
          setState(() {});
        },

      ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}

class LessonsTab extends StatefulWidget {
  const LessonsTab({Key? key}) : super(key: key);

  @override
  _LessonsTabState createState() => _LessonsTabState();
}

class _LessonsTabState extends State<LessonsTab>
    with AutomaticKeepAliveClientMixin<LessonsTab> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Lesson>>(
            future: DatabaseHelper.instance.getLessons(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return snapshot.data!.isEmpty
                  ? const Center(child: Text('Пусто'))
                  : ListView(
                children: snapshot.data!.map((lesson) {
                  return Center(
                    child: Card(
                      child: ListTile(
                        title: Text(
                            "${lesson.building}-${lesson.classroom} ${lesson.name} ${lesson.type}\n"
                                "${DateTime.fromMillisecondsSinceEpoch(lesson.date).day}"
                                "/${DateTime.fromMillisecondsSinceEpoch(lesson.date).month}"
                                "/${DateTime.fromMillisecondsSinceEpoch(lesson.date).year}\n"
                                "${DateTime.fromMillisecondsSinceEpoch(lesson.starttime).hour}:${DateTime.fromMillisecondsSinceEpoch(lesson.starttime).minute == 0 ? "00" : DateTime.fromMillisecondsSinceEpoch(lesson.starttime).minute} - "
                                "${DateTime.fromMillisecondsSinceEpoch(lesson.starttime + lessonTime).hour}:${DateTime.fromMillisecondsSinceEpoch(lesson.starttime + lessonTime).minute == 0 ? "00" : DateTime.fromMillisecondsSinceEpoch(lesson.starttime + lessonTime).minute} "
                                "${lesson.groupp}-${lesson.course}"),
                        onTap: () {
                          setState(() {
                            // TODO: ITEM MENU
                            // selectedID = lesson.id;

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
    );
  }

  @override
  bool get wantKeepAlive => true;
}