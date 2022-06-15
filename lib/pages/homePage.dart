import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/databaseHelper.dart';
import '../database/models/lesson.dart';
import 'calendarPage.dart';

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
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final tomorrow = DateTime(now.year, now.month, now.day + 1);
              List<Lesson> items = [];
              snapshot.data!.forEach((element) {
                if(element.starttime > today.millisecondsSinceEpoch && element.starttime < tomorrow.millisecondsSinceEpoch){
                  items.add(element);
                }
                items.sort((a, b) => a.starttime.compareTo(b.starttime)) ;
              });
              return (items.isEmpty || DateTime.now().millisecondsSinceEpoch > items.last.starttime)
                  ? Center(
                  child: Column(
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.event_note,
                        size: 150,),
                      Text("На сегодня всё", style: TextStyle(color: Colors.grey),),
                    ],
                  )
              )
                  : ListView(
                children: items.map((lesson) {

                  return Center(
                    child: Card(
                      child: ListTile(
                        title: Text(
                            "${DateTime.fromMillisecondsSinceEpoch(lesson.starttime).hour}:${DateTime.fromMillisecondsSinceEpoch(lesson.starttime).minute == 0 ? "00" : DateTime.fromMillisecondsSinceEpoch(lesson.starttime).minute} - "
                                "${DateTime.fromMillisecondsSinceEpoch(lesson.starttime + lessonTime).hour}:${DateTime.fromMillisecondsSinceEpoch(lesson.starttime + lessonTime).minute == 0 ? "00" : DateTime.fromMillisecondsSinceEpoch(lesson.starttime + lessonTime).minute} "
                                "${lesson.groupp}-${lesson.course}\n"
                            "${lesson.building}-${lesson.classroom} ${lesson.name} ${lesson.type}\n"
                                "${new DateFormat("MMMM dd yyyy").format(DateTime.now())}",
                          style: checkTime(lesson, tomorrow),
                                ),
                        onTap: () {
                          setState(() {
                            // TODO: ITEM MENU
                            // selectedID = lesson.id;
                          });
                        },
                        onLongPress: () {
                          setState(() {
                             // DatabaseHelper.instance.removeLesson(lesson);
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
  TextStyle checkTime(Lesson lesson, DateTime tomorrow) {
    Color color = Colors.black;
    if (lesson.starttime + lessonTime < DateTime.now().millisecondsSinceEpoch){
      color = Colors.grey;
    }
    else if (DateTime.now().millisecondsSinceEpoch >= lesson.starttime  && DateTime.now().millisecondsSinceEpoch <= lesson.starttime + lessonTime){
      color = Colors.redAccent;
    }
    return TextStyle(color: color);
  }

  @override
  bool get wantKeepAlive => true;
}