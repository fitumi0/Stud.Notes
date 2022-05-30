import 'package:flutter/material.dart';

import '../calendarPage.dart';


DateTime workDay = DateTime.now().hour > 19 ? DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + hour * 5) : DateTime.now();
DateTime selectedDate = workDay.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch ? DateTime.now() : workDay;
class DatePicker extends StatefulWidget {
  const DatePicker();

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            _selectDate(context);
          },
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
            Icon(Icons.edit),
          ],
        ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {

    final DateTime? selected = await showDatePicker(
        context: context,
        // TODO: FIX => locale: await initializeDateFormatting('ru_RU'),
        initialDate: workDay.millisecondsSinceEpoch < selectedDate.millisecondsSinceEpoch ? selectedDate : workDay,
        helpText: "Выберите дату занятия",
        firstDate: workDay,
        lastDate: DateTime(2050),
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }
}