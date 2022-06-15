import 'package:flutter/material.dart';


DateTime selectedDate = DateTime.now();
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
        //TODO: locale:
        initialDate: selectedDate,
        helpText: "Выберите дату занятия",
        firstDate: DateTime(DateTime.now().year-1),
        lastDate: DateTime(2050),
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }
}