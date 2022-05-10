import 'package:flutter/material.dart';


DateTime selectedDate = DateTime.now();
int _ddDate = selectedDate.millisecondsSinceEpoch;

class DatePicker extends StatefulWidget {
  const DatePicker();

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
            ElevatedButton(
              onPressed: () {
                _selectDate(context);
              },
              child: const Text("Выберите дату"),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        helpText: "Выберите дату занятия",
        firstDate: DateTime(2010),
        lastDate: DateTime(2025),
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        _ddDate = selectedDate.millisecondsSinceEpoch;
      });
    }
  }
}