import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/config/l10n.dart';
import 'package:flutter_stopwatch/widgets/square_labeled_switch.dart';

import 'home_view_state.dart';

class Home extends StatefulWidget {
  static const routeName = '/';

  final HomeViewState viewState;

  const Home({Key key, this.viewState}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'images/img_translucent_stopwatch.png',
                scale: 2.3,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'images/img_clock.png',
                scale: 2.3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildStopwatchIcon(),
                  verticalSpacing(),
                  buildTitle(context),
                  buildSwitchesRow(context),
                  verticalSpacing(),
                  buildSettingsButton(context),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(60),
                    alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      elevation: 10,
                      color: Colors.grey[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(L10n.getString(context, 'start_label')),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlatButton buildSettingsButton(BuildContext context) {
    return FlatButton(
      color: Colors.grey[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.settings),
          Padding(
            padding: EdgeInsets.only(left: 4.0),
          ),
          Text(L10n.getString(context, 'settings_label'))
        ],
      ),
      onPressed: () {},
    );
  }

  Row buildSwitchesRow(BuildContext context) {
    return Row(
      children: <Widget>[
        SquareLabeledSwitch(
          label: Text(L10n.getString(context, 'sound_label')),
          isEnabled: widget.viewState.isSoundEnabled,
          onChanged: (value) {
            widget.viewState.toggleSound(value);
          },
        ),
        SquareLabeledSwitch(
          label: Text(L10n.getString(context, 'vibration_label')),
          isEnabled: widget.viewState.isVibrationEnabled,
          onChanged: (value) {
            widget.viewState.toggleVibration(value);
          },
        ),
      ],
    );
  }

  Text buildTitle(BuildContext context) {
    return Text(
      L10n.getString(context, 'home_title'),
      style: TextStyle(
        color: Colors.white,
        fontSize: 50,
      ),
    );
  }

  SizedBox verticalSpacing() {
    return SizedBox(
      height: 16,
    );
  }

  Image buildStopwatchIcon() {
    return Image.asset(
      'images/ic_stopwatch.png',
      width: 60,
      height: 60,
    );
  }
}
