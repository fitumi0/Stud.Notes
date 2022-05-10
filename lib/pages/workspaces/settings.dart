import 'package:flutter/material.dart';
import 'package:flutter_proj/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/database/models/lesson.dart';

///
/// TODO: ADD THEMES FONTS AND
///
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin<SettingsPage> {
  
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
                                          child: TextFormField(

                                          ),
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
                    }, ),
                SizedBox(
                  height: height / 120,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width , 50),),
                    onPressed: () {}, child: Text("Изменение списка групп")),
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
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width , 50),),
                    onPressed: () {
                      AlertDialog(title:
                      Text(DatabaseHelper.instance.Create().toString())
                      );
                    },
                    child: Text("Создать БД")),
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
