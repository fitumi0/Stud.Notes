// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_proj/pages/lessonspage.dart';
import 'package:flutter_proj/pages/calendarpage.dart';
import 'package:flutter_proj/pages/homepage.dart';
import 'package:flutter_proj/pages/workspaces/settings.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);

  static const String _title = 'StudNotes';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title, // отвечает за название в диспетчере приложений. Сделать одинаковую с тайтлом и названием приложения
      theme:
      ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          primarySwatch: Colors.blueGrey,
          iconTheme: IconThemeData(color: Colors.black),
          fontFamily: "Montserrat-Bold",
          textTheme: const TextTheme(
              subtitle1: TextStyle(
                  fontFamily: "Montserrat-SemiBold",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
              subtitle2: TextStyle(
                  fontFamily: "Montserrat-Medium",
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54))),
      home: const NavigatePanel(),
    );
  }
}


class NavigatePanel extends StatefulWidget {
  const NavigatePanel({key}) : super(key: key);

  @override
  _NavigatePanelState createState() => _NavigatePanelState();
}

class _NavigatePanelState extends State<NavigatePanel> {
  int _selectedIndex = 1;

  static const List<Widget> _pages = <Widget>[
    CalendarPage(),
    HomePage(),
    LessonsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudNotes'),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => handleClick(context, value),
            itemBuilder: (BuildContext context) {
              return {'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: IndexedStack(
        children: _pages,
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Календарь',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_sharp),
            label: 'Занятия',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

void handleClick(BuildContext context, String value) {
  switch (value) {
    case 'Settings':
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return SettingsPage();
          },
        ),
      );
      break;
  }
}