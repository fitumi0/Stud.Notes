import 'package:flutter/material.dart';
import 'package:flutter_proj/database/databaseHelper.dart';

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
  final TextEditingController _debtController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("${widget.student.secondname} ${widget.student.firstname}"),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: IconButton(
              icon: editing ? Icon(Icons.check) : Icon(Icons.create),
              tooltip: 'Редактировать',
              onPressed: () {
                setState(() {
                  editStudentClick();
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
                SizedBox(height: 24,),
                _buildTitle("Группа: ", "${widget.student.groupp}-${widget.student.course}"),
                _buildTitle("Связь: ", "${widget.student.social}"),
                _buildRatingRow("Рейтинг: ", widget.student.rating.toDouble()),
                _buildTitle("Успеваемость: ", "\'fill here\'"),
                /*editing ? TextField(
                  controller: _debtController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ) : _buildTitle("${_debtController.text}"),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildTitle(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // SizedBox(height: 10.0),
          Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            body.toUpperCase(),
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: "Montserrat-Light",
            ),
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
              SizedBox(width: 8,),
              Expanded(
                flex: 7,
                child: LinearProgressIndicator(
                  color: Colors.yellow,
                  value: 0.755,
                ),
              ),
              SizedBox(width: 10,),
              Text(
                "1",
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(width: 32,)
            ],
          ),
          Divider(
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }

  void editStudentClick() {
    editing = !editing;
    // ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('ку-ку')));
  }

}