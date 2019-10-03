import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/config/l10n.dart';
import 'package:flutter_stopwatch/util/view_helpers.dart';
import 'package:flutter_stopwatch/widgets/square_labeled_switch.dart';
import 'package:vibrate/vibrate.dart';

import 'home_view_state.dart';

class Home extends StatefulWidget {
  static const routeName = '/';

  final HomeViewState viewState;

  const Home({Key key, this.viewState}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AudioCache audioCache = AudioCache(prefix: 'audio/');

  @override
  void initState() {
    super.initState();
    audioCache.load('cartoon_blink_flutter_shake.mp3');
  }

  @override
  void dispose() {
    super.dispose();
    audioCache.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            buildTopRightBgImage(),
            buildBottomRightBgImage(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildStopwatchIcon(),
                  ViewHelpers.verticalSpacing(),
                  buildTitle(context),
                  buildSwitchesRow(context),
                  ViewHelpers.verticalSpacing(),
                  buildSettingsButton(context),
                  Spacer(),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15, bottom: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          buildSecondsRow(context),
                          buildMinutesRow(context),
                          ViewHelpers.verticalSpacing(),
                          buildStartButton(context),
                        ],
                      ),
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

  Widget buildBottomRightBgImage() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Image.asset(
        'images/img_clock.png',
        scale: 2.3,
      ),
    );
  }

  Widget buildTopRightBgImage() {
    return Align(
      alignment: Alignment.topRight,
      child: Image.asset(
        'images/img_translucent_stopwatch.png',
        scale: 2.3,
      ),
    );
  }

  Widget buildStopwatchIcon() {
    return Image.asset(
      'images/ic_stopwatch.png',
      width: 60,
      height: 60,
    );
  }

  Widget buildTitle(BuildContext context) {
    return Text(
      L10n.getString(context, 'home_title'),
      style: TextStyle(color: Colors.white, fontFamily: 'Medium', fontSize: 50),
    );
  }

  Widget buildSwitchesRow(BuildContext context) {
    return Row(
      children: <Widget>[
        SquareLabeledSwitch(
          label: L10n.getString(context, 'sound_label'),
          isEnabled: widget.viewState.isSoundEnabled,
          onChanged: (value) {
            if (value) audioCache.play('cartoon_blink_flutter_shake.mp3');
            widget.viewState.toggleSound(value);
          },
        ),
        ViewHelpers.horizontalSpacing(width: 40),
        SquareLabeledSwitch(
          label: L10n.getString(context, 'vibration_label'),
          isEnabled: widget.viewState.isVibrationEnabled,
          onChanged: (value) {
            if (value) Vibrate.vibrate();
            widget.viewState.toggleVibration(value);
          },
        ),
      ],
    );
  }

  Widget buildSettingsButton(BuildContext context) {
    return FlatButton(
      color: Colors.grey[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.settings),
          ViewHelpers.horizontalSpacing(width: 4),
          Text(
            L10n.getString(context, 'settings_label'),
            style: TextStyle(
              fontFamily: 'Bold',
              fontSize: 15,
            ),
          )
        ],
      ),
      onPressed: () {},
    );
  }

  Widget buildSecondsRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0),
          child: Text(
            "00",
            style: TextStyle(
              height: 0.7,
              fontFamily: 'Regular',
              fontSize: 90,
            ),
          ),
        ),
        Text(
          L10n.getString(context, 'seconds_label'),
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildMinutesRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(
          "0",
          style: TextStyle(
            height: 0.7,
            fontSize: 40,
            color: Colors.grey,
          ),
        ),
        ViewHelpers.horizontalSpacing(),
        Text(
          L10n.getString(context, 'minutes_label'),
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildStartButton(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.only(top: 8, bottom: 12),
      elevation: 10,
      color: Colors.grey[700],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        L10n.getString(context, 'start_label'),
        style: TextStyle(fontSize: 18),
      ),
      onPressed: () {},
    );
  }
}
