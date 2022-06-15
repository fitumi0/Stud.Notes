// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_proj/pages/lessonsPage.dart';
import 'package:flutter_proj/pages/calendarPage.dart';
import 'package:flutter_proj/pages/homePage.dart';
import 'package:flutter_proj/pages/workspaces/settings.dart';
import 'package:flutter_proj/pages/workspaces/themes.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

String _title = "Главная";

class MyApp extends StatelessWidget {

  const MyApp({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      title: "StudNotes",
      theme: mainTheme,
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

  final List<Widget> _pages = <Widget>[
    CalendarPage(),
    HomePage(),
    LessonsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch(index){
        case 0: _title = "Расписание"; break;
        case 1: _title = "Ближайшие занятия"; break;
        case 2: _title = "Студенты"; break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(_title),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              onPressed: () =>
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return SettingsPage();
                    },
                  ),
                ),
              icon: const Icon(
                  Icons.settings_sharp,
              ),
          )
          // PopupMenuButton<String>(
          //   onSelected: (value) => handleClickMain(context, value),
          //   itemBuilder: (BuildContext context) {
          //     return {'Настройки'}.map((String choice) {
          //       return PopupMenuItem<String>(
          //         value: choice,
          //         child: Text(choice),
          //       );
          //     }).toList();
          //   },
          // ),
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

// void handleClickMain(BuildContext context, String value) {
//   switch (value) {
//     case 'Настройки':
//       Navigator.of(context).push<void>(
//         MaterialPageRoute<void>(
//           builder: (BuildContext context) {
//             return SettingsPage();
//           },
//         ),
//       );
//       break;
//   }
// }