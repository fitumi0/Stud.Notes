import 'package:flutter/material.dart';
import 'package:flutter_proj/database/databaseHelper.dart';
import 'package:flutter_proj/pages/workspaces/themes.dart';

import '../../database/models/student.dart';

class getStudentMenu extends StatefulWidget {
  final Student student;

  const getStudentMenu({Key? key, required this.student}) : super(key: key);

  @override
  _getStudentMenuState createState() => _getStudentMenuState();
}

class _getStudentMenuState extends State<getStudentMenu>
    with AutomaticKeepAliveClientMixin<getStudentMenu> {
  bool editing = false;
  String performance = "";
  String social = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("${widget.student.secondname} ${widget.student.firstname}"),
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_left),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                icon: const Icon(Icons.create),
                tooltip: 'Редактировать',
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => getStudentEdit(
                        student: widget.student,
                        parserDebtData: performance,
                        parserSocialData: social,
                      ),
                    ),
                  );
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        body: FutureBuilder<Student>(
            future: DatabaseHelper.instance.getStudentByID(widget.student.id!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                performance = snapshot.data!.debt;
                social = snapshot.data!.social;
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          _buildTitle("Группа: ",
                              "${widget.student.groupp}-${widget.student.course}"),
                          _buildTitle("Связь: ", social.trim() == "" ? "Нет данных" : social),
                          _buildRatingRow(
                              "Рейтинг: ", widget.student.rating.toDouble()),
                          _buildPerformance("Успеваемость: ",
                              performance.trim() == "" ? "Пусто" : performance),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }));
  }

  @override
  bool get wantKeepAlive => true;
}

class getStudentEdit extends StatefulWidget {
  final Student student;
  final String parserDebtData;
  final String parserSocialData;

  const getStudentEdit(
      {Key? key, required this.student, required this.parserDebtData, required this.parserSocialData})
      : super(key: key);

  @override
  _getStudentEditState createState() => _getStudentEditState();
}

class _getStudentEditState extends State<getStudentEdit>
    with AutomaticKeepAliveClientMixin<getStudentEdit> {
  final TextEditingController _debtController = TextEditingController();
  final TextEditingController _socialController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _debtController.text = widget.parserDebtData;
    _socialController.text = widget.parserSocialData;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
            "${widget.student.secondname} ${widget.student.firstname} - ред."),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: IconButton(
              icon: Icon(Icons.check),
              tooltip: 'Редактировать',
              onPressed: () {
                  setState(() {
                    DatabaseHelper.instance
                        .updateDebt(widget.student, _debtController.text, _socialController.text);
                    Navigator.of(context).pop();
                  });
                },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 24,
                ),
                _buildTitle("Группа: ",
                    "${widget.student.groupp}-${widget.student.course}"),
                _buildEditArea(_socialController, "Связь: ", null),
                _buildRatingRow("Рейтинг: ", widget.student.rating.toDouble()),
                _buildTitle("Успеваемость: ", ""),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: _debtController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
                _buildTitle("", "Информация об успеваемости"),
                SizedBox(
                  height: 32,
                )
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

_buildEditArea(TextEditingController controller, String label, int? maxLen) {
  return Padding(
    padding: EdgeInsets.only(left: 32.0, top: 8, right: 32.0),
    child: TextFormField(
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return "Поле обязательно к заполнению";
        //   }
        //   return null;
        // },
        controller: controller,
        maxLength: maxLen,
        decoration: InputDecoration(
            labelText: label, labelStyle: TextStyle(color: Color(lightGrey)
        )),
    ),
  );
}

Widget _buildTitle(String title, String body) {
  return Padding(
    padding: const EdgeInsets.only(left: 32.0, top: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // SizedBox(height: 10.0),
        title != ""
            ? Text(
                title.toUpperCase(),
                style: TextStyle(fontSize: 18.0),
              )
            : SizedBox(
                height: 0,
              ),
        body != ""
            ? Text(
                body.toUpperCase(),
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Montserrat-Light",
                ),
              )
            : SizedBox(
                height: 0,
              ),
        Divider(
          color: Colors.transparent,
        ),
      ],
    ),
  );
}

Widget _buildRatingRow(String skill, double level) {
  return Padding(
    padding: const EdgeInsets.only(left: 32.0, top: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // SizedBox(height: 10.0),
        Row(
          children: [
            Text(
              skill.toUpperCase() + " 0",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: LinearProgressIndicator(

                color: Colors.yellow,
                value: 0.755,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "1",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              width: 32,
            )
          ],
        ),
        Divider(
          color: Colors.transparent,
        ),
      ],
    ),
  );
}

_buildPerformance(String title, String body) {
  List data = body.split("\n");
  List toRemove = [];
  for (var e in data) {
    e.trim().hashCode == 1 ? toRemove.add(e) : null;
  }
  for (String i in toRemove) {
    data.remove(i);
  }
  return Padding(
    padding: const EdgeInsets.only(left: 32.0, top: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title != ""
            ? Text(
                title.toUpperCase(),
                style: TextStyle(fontSize: 18.0),
              )
            : SizedBox(
                height: 0,
              ),
        SizedBox(
          height: 6,
        ),
        body == "Пусто" ? Text(
          body.toUpperCase(),
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: "Montserrat-Light",
          ),
        )
            : ListView(
          shrinkWrap: true,
          children: data.map((e) {
            return Padding(
              padding: EdgeInsets.only(left: 0, top: 0, right: 32),
              child: Card(
                child: ListTile(
                  title: Text(
                    e.trim(),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Montserrat-Regular",
                    ),)
                ),
              )

            );
          }).toList(),
        ),
        Divider(
          color: Colors.transparent,
        ),
      ],
    ),
  );
}
