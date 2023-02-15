import 'package:flutter/material.dart';

class GenderPicker extends StatefulWidget {
  const GenderPicker({
    Key? key,
    required this.setInfo,
    required this.infoType,
    required this.defaultGender,
  }) : super(key: key);
  final Function setInfo;
  final String infoType;
  final String defaultGender;

  @override
  State<GenderPicker> createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  String _gender = 'defaultGender';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '성별',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() => _gender = 'M');
                  widget.setInfo(widget.infoType, _gender);
                },
                child: genderBtn(
                  'M',
                  _gender,
                  Colors.lightBlue.shade100,
                  const Icon(Icons.male_rounded),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  setState(() => _gender = 'F');
                  widget.setInfo(widget.infoType, _gender);
                },
                child: genderBtn(
                  'F',
                  _gender,
                  Colors.pink.shade100,
                  const Icon(Icons.female_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget genderBtn(
  String gender,
  String selected,
  Color color,
  Icon icon,
) {
  final Map<String, double> btnStyle = {
    'width': 140,
    'height': 40,
    'radius': 20,
  };

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(btnStyle['radius']!.toDouble()),
      color: gender == selected ? color : Colors.transparent,
    ),
    height: btnStyle['height'],
    width: btnStyle['width'],
    child: icon,
  );
}
