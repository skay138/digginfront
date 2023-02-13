import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key, required this.setInfo, required this.infoType})
      : super(key: key);
  final Function setInfo;
  final String infoType;
  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 600,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            width: 300,
            height: 40,
            child: Text(
              '생일',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 100,
              width: 300,
              child: ScrollDatePicker(
                selectedDate: _selectedDate,
                locale: const Locale('ko'),
                scrollViewOptions: const DatePickerScrollViewOptions(
                    year: ScrollViewDetailOptions(
                      label: '년',
                      margin: EdgeInsets.only(right: 40),
                    ),
                    month: ScrollViewDetailOptions(
                      label: '월',
                      margin: EdgeInsets.only(right: 40),
                    ),
                    day: ScrollViewDetailOptions(
                      label: '일',
                    )),
                onDateTimeChanged: (DateTime value) {
                  setState(() {
                    _selectedDate = value;
                  });
                  widget.setInfo(widget.infoType, _selectedDate);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future _selectDate(BuildContext context) async {
  //   final DateTime? selected = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime.now(),
  //       builder: (context, child) {
  //         return Theme(
  //           data: ThemeData.dark().copyWith(
  //             colorScheme: const ColorScheme.dark(),
  //             dialogBackgroundColor: const ColorScheme.dark().background,
  //           ),
  //           child: child!,
  //         );
  //       });
  //   if (selected != null) {
  //     setState(() {
  //       _selectedDate = (DateFormat('y년 M월 d일')).format(selected);
  //     });
  //     widget.setInfo(widget.infoType, _selectedDate);
  //   }
  // }
}
