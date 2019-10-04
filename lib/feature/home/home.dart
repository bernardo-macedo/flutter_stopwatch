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
  int totalMilliseconds;

  @override
  void dispose() {
    widget.viewState.clearAudioCache();
    widget.viewState.cancelTimer();
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
            if (value) widget.viewState.playSound(onlyOnce: true);
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
        (milliseconds) {
          setState(() {
            totalMilliseconds = milliseconds;
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
          buildTextTime(widget.viewState.hoursStr),
          buildTextTime(":"),
          buildTextTime(widget.viewState.minutesStr),
          buildTextTime(":"),
          buildTextTime(widget.viewState.secondsStr)
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
    } else if (widget.viewState.isFinished) {
      contents.add(buildResetButton(context));
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
        widget.viewState.startTimer(totalMilliseconds);
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

  Widget buildResetButton(BuildContext context) {
    return buildButton(L10n.getString(context, 'reset_label'), () {
      widget.viewState.resetTimer();
    }, color: Colors.black);
  }
}
