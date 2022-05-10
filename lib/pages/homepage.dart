import 'package:flutter/material.dart';
import 'package:flutter_proj/pages/lessonspage.dart';
import 'package:flutter_proj/pages/calendarpage.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(child: Text("TODO")),
            Expanded(
                child: TODOS()
            ),
        ],
          ),
        ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}

class TODOS extends StatefulWidget {
  const TODOS({Key? key}) : super(key: key);

  @override
  _TODOSState createState() => _TODOSState();
}

class _TODOSState extends State<TODOS>
    with AutomaticKeepAliveClientMixin<TODOS> {
  get groups => <String>[
    "- В настройки залить изменение всех выпадающих списков (+ табличка для каждой)",
    "- Занятия -> Студенты -> Список групп динамически -> в каждой группе список студентов динамически",
    "- Обновление UI в занятиях",
    "- Карточка пары - макет",
    "- Карточка студента - макет",
    "- КАЛЕНДАРЬ!!!!!!!!!",
    "- Парсер пар принял ислам - разрабы расписания красавчики",
    "- Откуда-то брать студентов (???)",
    "  Last Update: 5.05.22 -- 18:10"
  ];

  @override
  Widget build(BuildContext context) {
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}