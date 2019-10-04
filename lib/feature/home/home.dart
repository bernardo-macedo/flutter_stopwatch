import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/config/l10n.dart';
import 'package:flutter_stopwatch/feature/home/home_view.dart';
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

class _HomeState extends State<Home> with HomeView {
  AudioCache audioCache = AudioCache();
  DateTime _dateTime;
  Timer timer;

  String hoursStr = "";
  String minutesStr = "";
  String secondsStr = "";

  @override
  void initState() {
    audioCache.load('sound.mp3');
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
    super.initState();
  }

  @override
  void dispose() {
    audioCache.clearCache();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildHomeBody(context),
    );
  }

  @override
  Widget buildSwitchesRow(BuildContext context) {
    return Row(
      children: <Widget>[
        SquareLabeledSwitch(
          label: L10n.getString(context, 'sound_label'),
          isEnabled: widget.viewState.isSoundEnabled,
          onChanged: (value) {
            if (value) audioCache.play('sound.mp3');
            widget.viewState.toggleSound(value);
          },
        ),
        ViewHelpers.horizontalSpacing(space: 40),
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

  @override
  Widget buildTimeWidget() {
    if (widget.viewState.isStopped) {
      return buildTimePicker(
        (time) {
          setState(() {
            _dateTime = time;
          });
        },
      );
    } else {
      return buildStopwatch();
    }
  }

  Widget buildStopwatch() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildTextTime(hoursStr),
          buildTextTime(":"),
          buildTextTime(minutesStr),
          buildTextTime(":"),
          buildTextTime(secondsStr)
        ],
      ),
    );
  }

  @override
  Widget buildButtonsRow(BuildContext context) {
    List<Widget> contents = [];
    if (widget.viewState.isStopped) {
      contents.add(buildStartButton(context));
    } else if (widget.viewState.isStarted) {
      contents.add(buildPauseButton(context));
      contents.add(buildStopButton(context));
    } else if (widget.viewState.isPaused) {
      contents.add(buildContinueButton(context));
      contents.add(buildStopButton(context));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: contents,
    );
  }

  Widget buildStartButton(BuildContext context) {
    return buildButton(
      L10n.getString(context, 'start_label'),
      () {
        widget.viewState.startTimer();
      },
    );
  }

  Widget buildPauseButton(BuildContext context) {
    return buildButton(
      L10n.getString(context, 'pause_label'),
      () {
        widget.viewState.pauseTimer();
      },
    );
  }

  Widget buildContinueButton(BuildContext context) {
    return buildButton(
      L10n.getString(context, 'continue_label'),
      () {
        widget.viewState.continueTimer();
      },
    );
  }

  Widget buildStopButton(BuildContext context) {
    return buildButton(L10n.getString(context, 'stop_label'), () {
      widget.viewState.stopTimer();
    }, color: Colors.black);
  }

  void callback(Timer timer) {
    int milliseconds = widget.viewState.stopwatch.elapsedMilliseconds;
    final int hundreds = (milliseconds / 10).truncate();
    final int seconds = (hundreds / 100).truncate();
    final int minutes = (seconds / 60).truncate();
    final int hours = (minutes / 60).truncate();

    setState(() {
      hoursStr = (hours % 24).toString().padLeft(2, '0');
      minutesStr = (minutes % 60).toString().padLeft(2, '0');
      secondsStr = (seconds % 60).toString().padLeft(2, '0');
    });
  }
}
