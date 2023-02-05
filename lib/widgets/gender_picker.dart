import 'package:flutter/material.dart';

class GenderPicker extends StatefulWidget {
  const GenderPicker({super.key});

  @override
  State<GenderPicker> createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  String _gender = 'male';

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
                onTap: () => setState(() => _gender = 'male'),
                child: genderBtn(
                  'male',
                  _gender,
                  Colors.lightBlue.shade100,
                  const Icon(Icons.male_rounded),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => setState(() => _gender = 'female'),
                child: genderBtn(
                  'female',
                  _gender,
                  Colors.pink.shade100,
                  const Icon(Icons.female_rounded),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
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
