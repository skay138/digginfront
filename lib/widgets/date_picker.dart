import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  String _selectedDate = '생일을 선택해주세요';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.date_range_outlined,
              size: 30,
            ),
            onPressed: () => _selectDate(context),
          ),
          Text(
            _selectedDate,
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(),
              dialogBackgroundColor: const ColorScheme.dark().background,
            ),
            child: child!,
          );
        });
    if (selected != null) {
      setState(() {
        _selectedDate = (DateFormat.yMMMd()).format(selected);
      });
    }
  }
}
