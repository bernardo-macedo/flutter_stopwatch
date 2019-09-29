import 'package:flutter/material.dart';

class SquareLabeledSwitch extends StatelessWidget {
  final Widget label;
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
          activeThumbImage: AssetImage('images/switch_thumb_on'),
          inactiveThumbImage: AssetImage('images/switch_thumb_off'),
          value: isEnabled,
          onChanged: onChanged,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: label,
        )
      ],
    );
  }
}
