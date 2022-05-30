import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_proj/database/models/groupp.dart';
import 'package:flutter_proj/database/models/student.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'models/lesson.dart';
import 'models/dropDownListModel.dart';

class DatabaseHelper {
  static int currentTimeInSeconds() {
    var ms = (DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'studNotes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure
    );
  }
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS lessons(
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL REFERENCES lessons_list(name) ON DELETE CASCADE ON UPDATE CASCADE,
      building INTEGER NOT NULL,
      classroom INTEGER NOT NULL,
      groupp TEXT NOT NULL,
      course INTEGER NOT NULL,
      date INTEGER NOT NULL,
      starttime INTEGER NOT NULL,
      type TEXT NOT NULL,
      state INTEGER NOT NULL,
      recurrenceRule TEXT,
      FOREIGN KEY (groupp, course) REFERENCES groupp_list ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      firstname TEXT NOT NULL,
      secondname TEXT NOT NULL,
      groupp TEXT NOT NULL,
      course INT NOT NULL,
      social TEXT,
      rating INT,
      debt TEXT,
      FOREIGN KEY (groupp, course) REFERENCES groupp_list ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''');


    await db.execute('''
    CREATE TABLE IF NOT EXISTS lessons_list(
      id INTEGER NOT NULL PRIMARY KEY,
      name TEXT NOT NULL UNIQUE
    );
    ''');


    await db.execute('''
    CREATE TABLE IF NOT EXISTS groupp_list(
      name TEXT NOT NULL,
      course INT NOT NULL,
      PRIMARY KEY (name, course)
    );
    ''');
  }

  Future<bool> isInTable(String firstname, String secondname, String group, String course) async{
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT * FROM students WHERE firstname=\'${firstname}\' AND secondname=\'${secondname}\' AND groupp=\'${group}\' AND course=${course}');
    return result.isNotEmpty;
  }


  ///
  ///
  /// DROPDOWN

  Future<List<DropDownListModel>> getLessonsDropDownList() async {
    Database db = await instance.database;
    var lessons = await db.query('lessons_list', orderBy: 'name');
    List<DropDownListModel> LessonList = lessons.isNotEmpty
        ? lessons.map((c) => DropDownListModel.fromMap(c)).toList()
        : [];
    return LessonList;
  }



  void insertIntoLessonsDropDownList(DropDownListModel lesson) async {
    Database db = await instance.database;
    // return await db.insert('lessons_list', lesson.toMap());
    await db.rawQuery('''INSERT INTO lessons_list(id, name)
    VALUES((SELECT IFNULL (MAX(id), 0) + 1 FROM lessons_list), '${lesson.name}') 
      '''
    );
  }

  void removeFromLessonsDropDownList(int id) async {
    Database db = await instance.database;
    await db.rawQuery('DELETE FROM lessons_list WHERE id = ${id}');
  }
  /// ===============================================================


  /// END DROPDOWNS
  ///
  /// LESSONS

  Future<List<Lesson>> getLessons() async {
    Database db = await instance.database;
    var lessons = await db.query('lessons', orderBy: 'name');
    List<Lesson> LessonList = lessons.isNotEmpty
        ? lessons.map((c) => Lesson.fromMap(c)).toList()
        : [];
    return LessonList;
  }

  Future<int> getLessonID(int date) async {
    Database db = await instance.database;
    var id = await db.rawQuery('SELECT id FROM lessons WHERE starttime=$date');
    return int.parse(id[0].values.elementAt(0).toString());
  }

  void insertLesson(Lesson lesson) async {
    Database db = await instance.database;
    await db.rawQuery('''INSERT INTO lessons(id, name, building, classroom, groupp, course, date, starttime, type, state, recurrenceRule)
    VALUES( (SELECT IFNULL (MAX(id), 0) + 1 FROM lessons), '${lesson.name}', ${lesson.building}, ${lesson.classroom}, '${lesson.groupp}', 
    ${lesson.course}, ${lesson.date}, ${lesson.starttime}, '${lesson.type}', ${lesson.state}, NULL)
    ''');
  }

  Future<int> removeLesson(int id) async {
    Database db = await instance.database;
    return await db.delete('lessons', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> removeLessonByDateAndTime(int date, int starttime) async {
    Database db = await instance.database;
    return await db.delete('lessons', where: 'date = ? and starttime = ?', whereArgs: [date, starttime]);
  }

  Future<int> updateLesson(Lesson lesson) async {
    Database db = await instance.database;
    return await db.update('lessons', lesson.toMap(),
        where: "id = ?", whereArgs: [lesson.id]);
  }

  Future<bool> isLessonTimeInDataBase(Lesson lesson) async {
    Database db = await instance.database;
    var result = await db.rawQuery("SELECT starttime FROM lessons WHERE date=${lesson.date} AND starttime=${lesson.starttime}");
    return result.isNotEmpty;
  }

  /// END LESSONS
  ///
  /// STUDENTS

  Future<List<Student>> getStudentsFromGroup(String group, int course) async {
    Database db = await instance.database;
    var students = await db.rawQuery("SELECT * FROM students WHERE groupp=\'${group}\' AND course=${course} ORDER BY secondname ASC");
    List<Student> StudentList = students.isNotEmpty
        ? students.map((c) => Student.fromMap(c)).toList()
        : [];
    return StudentList;
  }

  Future<List<Student>> getGroupsFromStudents() async {
    Database db = await instance.database;
    var students = await db.rawQuery("SELECT * FROM students group by groupp, course ORDER BY groupp ASC, course ASC");
    List<Student> StudentList = students.isNotEmpty
        ? students.map((c) => Student.fromMap(c)).toList()
        : [];
    return StudentList;
  }

  void insertStudents(Student student) async {
    Database db = await instance.database;
    await db.rawQuery('''
    INSERT INTO students(firstname, secondname, course, groupp, social, rating, debt)
    VALUES(\'${student.firstname}\', \'${student.secondname}\', ${student.course}, \'${student.groupp}\', \'${student.social}\', ${student.rating}, NULL)
    ''');
  }

  Future<int> removeStudents(int id) async {
    Database db = await instance.database;
    return await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateStudents(Student student) async {
    Database db = await instance.database;
    return await db.update('students', student.toMap(),
        where: "id = ?", whereArgs: [student.id]);
  }


  /// END STUDENTS
  ///
  /// START GROUPPS

  Future<int> insertGroupp(Groupp groupp) async {
    Database db = await instance.database;
    return await db.insert('groupp_list', groupp.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
  }

  void removeGroupp(String name, int course) async {
    Database db = await instance.database;
    await db.rawQuery('DELETE FROM groupp_list WHERE name = \'${name}\' AND course = ${course}');
  }

  Future<List<Groupp>> getGroupps() async {
    Database db = await instance.database;
    var students = await db.rawQuery(
        "SELECT * FROM groupp_list group by name, course ORDER BY name ASC, course ASC");
    List<Groupp> GrouppList = students.isNotEmpty
        ? students.map((c) => Groupp.fromMap(c)).toList()
        : [];
    return GrouppList;
  }

}
