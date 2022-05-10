import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_proj/database/models/group.dart';
import 'package:flutter_proj/database/models/student.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'models/lesson.dart';


class DatabaseHelper{
  static int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
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
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS lessons(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        groupp TEXT NOT NULL,
        course INTEGER NOT NULL,
        date INTEGER NOT NULL,
        start INTEGER NOT NULL,
        type TEXT NOT NULL,
        state INTEGER NOT NULL)''');

    await db.execute('''CREATE TABLE IF NOT EXISTS groups(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        course INT NOT NULL)''');

    await db.execute('''CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        secondname TEXT NOT NULL,
        firstname TEXT NOT NULL,
        groupp TEXT NOT NULL,
        course INT NOT NULL,
        email TEXT,
        VK TEXT,
        TG TEXT,
        rating INT)''');
  }

    Future<int> Create() async {
      Database db = await instance.database;
      await db.execute('''CREATE TABLE IF NOT EXISTS lessons_list(
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL)''');
      await db.execute('''CREATE TABLE IF NOT EXISTS groups_list(
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL)''');
      await db.execute('''CREATE TABLE IF NOT EXISTS course_list(
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL)''');
      await db.execute('''CREATE TABLE IF NOT EXISTS startTime_list(
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL)''');
      await db.execute('''CREATE TABLE IF NOT EXISTS lessonTypes_list(
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL)''');
      return 1;
  }

  ///
  /// LESSONS
  ///

  Future<List<Lesson>> getLessons() async {
    Database db = await instance.database;
    var lessons = await db.query('lessons', orderBy: 'name');
    List<Lesson> LessonList = lessons.isNotEmpty
        ? lessons.map((c) => Lesson.fromMap(c)).toList()
        : [];
    return LessonList;
  }

  Future<int> insertLesson(Lesson lesson) async {
    Database db = await instance.database;
    return await db.insert('lessons', lesson.toMap());
  }

  Future<int> removeLesson(int id) async {
    Database db = await instance.database;
    return await db.delete('lessons', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateLesson(Lesson lesson) async {
    Database db = await instance.database;
    return await db.update('lessons', lesson.toMap(),
        where: "id = ?", whereArgs: [lesson.id]);
  }

  /// END LESSONS
  ///
  /// STUDENTS

  Future<List<Student>> getStudents() async {
    Database db = await instance.database;
    var students = await db.query('students', orderBy: 'secondname');
    List<Student> StudentList = students.isNotEmpty
        ? students.map((c) => Student.fromMap(c)).toList()
        : [];
    return StudentList;
  }

  Future<int> insertStudents(Student student) async {
    Database db = await instance.database;
    return await db.insert('students', student.toMap());
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
  /// GROUPS

  Future<List<Group>> getGroups() async {
    Database db = await instance.database;
    var groups = await db.query('groups', orderBy: 'name');
    List<Group> GroupList = groups.isNotEmpty
        ? groups.map((c) => Group.fromMap(c)).toList()
        : [];
    return GroupList;
  }

  Future<int> insertGroups(Group group) async {
    Database db = await instance.database;
    return await db.insert('groups', group.toMap());
  }

  Future<int> removeGroups(int id) async {
    Database db = await instance.database;
    return await db.delete('groups', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateGroups(Group group) async {
    Database db = await instance.database;
    return await db.update('groups', group.toMap(),
        where: "id = ?", whereArgs: [group.id]);
  }

}

