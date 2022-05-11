import 'package:flutter/material.dart';

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
    "- В настройки залить изменение всех выпадающих списков (Группа, курс, итд) (+ табличка для каждой (ГОТОВО) )",
    "- Занятия -> Студенты -> Список групп динамически (OK) -> в каждой группе список студентов динамически",
    "- Конвертер времени с начала эпохи в человекочитаемое",
    "- Добавить при нажатии на группу передачу параметра в дочерний класс, отображать в какой группе сейчас производится работа",
    "- Загрузка студентов по макету",
    "- Проверка при загрузке на наличие студентов в базе",
    "- Карточка пары - макет",
    "- Карточка студента - макет",
    "- КАЛЕНДАРЬ!!!!!!!!!",
    "  Last Update: 11.05.22 -- 20:00"
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