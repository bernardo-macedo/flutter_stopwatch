import 'dart:async';

import 'package:flutter/cupertino.dart';

class HomeViewState extends ChangeNotifier {
  Timer timer;

  int totalMilliseconds;
  int currentMillisecond;
  int interval = 100;

  bool isSoundEnabled = false;
  bool isVibrationEnabled = false;
  bool isStarted = false;
  bool isPaused = false;
  bool isStopped = true;

  String hoursStr = "";
  String minutesStr = "";
  String secondsStr = "";

  void toggleSound(bool isSoundEnabled) {
    this.isSoundEnabled = isSoundEnabled;
    notifyListeners();
  }

  void toggleVibration(bool isVibrationEnabled) {
    this.isVibrationEnabled = isVibrationEnabled;
    notifyListeners();
  }

  void startTimer(int totalMilliseconds) {
    initTimer();
    this.totalMilliseconds = totalMilliseconds;
    this.currentMillisecond = totalMilliseconds;

    this.isStarted = true;
    this.isPaused = false;
    this.isStopped = false;

    notifyListeners();
  }

  void pauseTimer() {
    this.isStarted = false;
    this.isPaused = true;
    this.isStopped = false;

    notifyListeners();
  }

  void continueTimer() {
    this.isStarted = true;
    this.isPaused = false;
    this.isStopped = false;

    notifyListeners();
  }

  void stopTimer() {
    cancelTimer();
    this.totalMilliseconds = 0;
    this.currentMillisecond = 0;

    this.isStarted = false;
    this.isPaused = false;
    this.isStopped = true;

    notifyListeners();
  }

  void callback(Timer timer) {
    if (!isPaused) {
      final int hundreds = (currentMillisecond / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final int hours = (minutes / 60).truncate();

      hoursStr = (hours % 24).toString().padLeft(2, '0');
      minutesStr = (minutes % 60).toString().padLeft(2, '0');
      secondsStr = (seconds % 60).toString().padLeft(2, '0');

      currentMillisecond -= interval;
      if (currentMillisecond < 1) {
        cancelTimer();
      }

      notifyListeners();
    }
  }

  void initTimer() {
    this.timer =
        new Timer.periodic(new Duration(milliseconds: interval), callback);
  }

  void cancelTimer() {
    timer?.cancel();
  }
}
