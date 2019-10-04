import 'package:flutter/cupertino.dart';

class HomeViewState extends ChangeNotifier {
  Stopwatch stopwatch = Stopwatch();
  bool isSoundEnabled = false;
  bool isVibrationEnabled = false;
  bool isStarted = false;
  bool isPaused = false;
  bool isStopped = true;

  void toggleSound(bool isSoundEnabled) {
    this.isSoundEnabled = isSoundEnabled;
    notifyListeners();
  }

  void toggleVibration(bool isVibrationEnabled) {
    this.isVibrationEnabled = isVibrationEnabled;
    notifyListeners();
  }

  void startTimer() {
    this.stopwatch.start();
    this.isStarted = true;
    this.isPaused = false;
    this.isStopped = false;
    notifyListeners();
  }

  void pauseTimer() {
    this.stopwatch.stop();
    this.isStarted = false;
    this.isPaused = true;
    this.isStopped = false;
    notifyListeners();
  }

  void continueTimer() {
    startTimer();
    notifyListeners();
  }

  void stopTimer() {
    this.stopwatch.reset();
    this.isStarted = false;
    this.isPaused = false;
    this.isStopped = true;
    notifyListeners();
  }
}
