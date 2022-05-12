// @dart=2.9
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/pages/lessonspage.dart';
import 'package:flutter_proj/pages/calendarpage.dart';
import 'package:flutter_proj/pages/homepage.dart';
import 'package:flutter_proj/pages/workspaces/settings.dart';
import 'package:flutter_proj/pages/workspaces/themes.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

String _title = "Главная";

class MyApp extends StatelessWidget {

  const MyApp({key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // final isPlatformDark = WidgetsBinding.instance.window.platformBrightness == Brightness.light;
    // final initTheme = isPlatformDark ? pinkTheme : mainTheme;
    final initTheme = mainTheme;
    return ThemeProvider(
        initTheme: initTheme,
      builder: (_, myTheme){
      return MaterialApp(
      title: _title,
      theme: myTheme,
      home: const NavigatePanel(),
      );
        }
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
      switch(index){
        case 0: _title = "Расписание"; break;
        case 1: _title = "Главная"; break;
        case 2: _title = "Студенты"; break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
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