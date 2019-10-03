import 'package:flutter/material.dart';

class SquareLabeledSwitch extends StatelessWidget {
  final String label;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const SquareLabeledSwitch(
      {Key key, this.isEnabled, this.onChanged, this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Switch(
          activeColor: Colors.white,
          inactiveThumbColor: Colors.grey,
          value: isEnabled,
          onChanged: onChanged,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            label,
            style: TextStyle(color: getTextColor()),
          ),
        )
      ],
    );
  }

  Color getTextColor() {
    if (isEnabled) {
      return Colors.white;
    } else {
      return Colors.grey;
    }
  }
}
