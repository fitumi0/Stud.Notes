import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/database/databaseHelper.dart';
import 'package:flutter_proj/database/models/student.dart';

import '../../database/models/groupp.dart';


///
/// TODO: ADD THEMES
///
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin<SettingsPage> {
  int? selectedID;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Настройки'),
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
                  child: Text("Загрузить студентов"),
                  onPressed: () {
                    _openFileExplorer();
                  }, ),
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

  Future<void> _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null){
      PlatformFile openedFile = result.files.first;
      List<String> dataFromOpenedFile = (await File(openedFile.path.toString()).readAsLines());
      dataFromOpenedFile.forEach((element) async {
        if (element.trim() != "") {
          List<String> tempSplittedDataFromOpenedFile = (element.trim().split(" "));
          while (tempSplittedDataFromOpenedFile.length < 5){
            tempSplittedDataFromOpenedFile.add(" ");
          }
          List<String> splittedDataFromOpenedFile = <String>[];
          for (int i = 0; i < tempSplittedDataFromOpenedFile.length; i++) {
            if (i == 2) {
              splittedDataFromOpenedFile.add(
                  tempSplittedDataFromOpenedFile[2].split("-")[0]);
              splittedDataFromOpenedFile.add(
                  tempSplittedDataFromOpenedFile[2].split("-")[1]);
            }
            else {
              splittedDataFromOpenedFile.add(tempSplittedDataFromOpenedFile[i]);
            }
          }
          bool isInclude = await DatabaseHelper.instance.isInTable(
              splittedDataFromOpenedFile[0], splittedDataFromOpenedFile[1],
              splittedDataFromOpenedFile[2], splittedDataFromOpenedFile[3]);
          if (!isInclude) {
            Student student = Student(
              firstname: splittedDataFromOpenedFile[0],
              secondname: splittedDataFromOpenedFile[1],
              groupp: splittedDataFromOpenedFile[2],
              course: int.parse(splittedDataFromOpenedFile[3]),
              social: splittedDataFromOpenedFile[4] == ""
                  ? ""
                  : splittedDataFromOpenedFile[4],
              rating: 0,
              debt: "",
            );
            Groupp group = Groupp(
                name: splittedDataFromOpenedFile[2].toUpperCase(),
                course: int.parse(splittedDataFromOpenedFile[3])
            );
            DatabaseHelper.instance.insertGroupp(group);
            DatabaseHelper.instance.insertStudents(student);
          }
      }
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Студенты успешно загружены'),
            backgroundColor: Colors.blueGrey,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
            elevation: 30,
          )
      );
    }
  }


}
