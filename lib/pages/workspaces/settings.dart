import 'package:flutter/material.dart';
import 'package:flutter_proj/database/database_helper.dart';

import '../../database/models/DropDownListModel.dart';

///
/// TODO: ADD THEMES FONTS AND
///
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin<SettingsPage> {
  int? selectedID;
  TextEditingController _controllerLesson = TextEditingController();
  TextEditingController _controllerGroup = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudNotes'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                minimumSize: Size(width, 50),),
                child: Text("Изменение списка пар"),
                    onPressed: () {
                  selectedID = null;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
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
                                          child: Container(
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
                                                                // TODO: ITEM MENU
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
                                                    hintText: 'Название пары',

                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(16.0))),
                                              ),
                                              Row(
                                                children: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      minimumSize: const Size(
                                                          100, 50),
                                                    ),
                                                    child: Text("Добавить"),
                                                    onPressed: () {
                                                      DatabaseHelper.instance
                                                          .insertIntoLessonsDropDownList(
                                                          new DropDownListModel(
                                                              name: _controllerLesson
                                                                  .text));

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
                    }, ),
                SizedBox(
                  height: height / 120,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width , 50),),
                    child: Text("Изменение списка групп"),
                onPressed: (){
                  selectedID = null;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return Stack(
                                  children: <Widget>[
                                    Form(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Список групп обучающихся"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: height / 3,
                                              width: 300.0,
                                              child: FutureBuilder<
                                                  List<DropDownListModel>>(
                                                  future: DatabaseHelper.instance
                                                      .getGroupsDropDownList(),
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
                                                          .map((group) {
                                                        return Center(
                                                          child: Card(
                                                            color: selectedID ==
                                                                group.id
                                                                ? Colors.red
                                                                : Colors.white,
                                                            child: ListTile(
                                                              title: Text(
                                                                  group.name),
                                                              onTap: () {
                                                                setState(() {
                                                                  // TODO: ITEM MENU
                                                                  selectedID =
                                                                      group.id;
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
                                                  controller: _controllerGroup,
                                                  decoration: InputDecoration(
                                                      errorStyle:
                                                      const TextStyle(
                                                          color: Colors.redAccent,
                                                          fontSize: 16.0),
                                                      hintText: 'Название группы',

                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(16.0))),
                                                ),
                                                Row(
                                                  children: [
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        minimumSize: const Size(
                                                            100, 50),
                                                      ),
                                                      child: Text("Добавить"),
                                                      onPressed: () {
                                                        DatabaseHelper.instance
                                                            .insertIntoGroupsDropDownList(
                                                            new DropDownListModel(
                                                                name: _controllerGroup
                                                                    .text));

                                                        setState(() {
                                                          _controllerGroup
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
                                                          DatabaseHelper.instance.removeFromGroupsDropDownList(selectedID!);
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
                },),
                SizedBox(
                  height: height / 120,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width , 50),),
                    onPressed: () {}, child: Text("Изменение списка курсов")),
                SizedBox(
                  height: height / 120,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width , 50),),
                    onPressed: () {}, child: Text("Изменение списка времени")),
                SizedBox(
                  height: height / 120,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width , 50),),
                    onPressed: () {},
                    child: Text("Изменение списка типов пар")),
                SizedBox(
                  height: height / 120,
                ),
                SizedBox(
                  height: height / 120,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
