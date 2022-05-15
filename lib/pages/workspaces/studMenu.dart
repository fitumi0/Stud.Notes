import 'package:flutter/material.dart';

import '../../database/models/student.dart';

class getStudentMenu extends StatefulWidget {
  final Student student;

  const getStudentMenu({Key? key, required this.student}) : super(key: key);



  @override
  _getStudentMenuState createState() => _getStudentMenuState();
}

class _getStudentMenuState extends State<getStudentMenu>
    with AutomaticKeepAliveClientMixin<getStudentMenu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.student.secondname} ${widget.student.firstname}"),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Редактировать',
              onPressed: () {
                editStudentClick();
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
                Text("Курс: ${widget.student.course}"),
                Text("Группа: ${widget.student.groupp}"),
                Text("Связь: ${widget.student.social}"),
                Text("Рейтинг: ${widget.student.rating}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;


  void editStudentClick() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ку-ку')));
  }

}