import 'package:flutter/material.dart';

class StudentMenu extends StatefulWidget {
  @override
  _StudentMenuState createState() => _StudentMenuState();
}

class _StudentMenuState extends State<StudentMenu>
    with AutomaticKeepAliveClientMixin<StudentMenu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudNotes'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu, size: 150),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
