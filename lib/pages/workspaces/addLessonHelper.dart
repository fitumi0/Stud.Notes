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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                      )
                  )
              ),
              onPressed: () {
                _selectDate(context);
              },
              child: Icon(Icons.edit),
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
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }
}