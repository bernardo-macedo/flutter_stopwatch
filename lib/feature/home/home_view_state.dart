import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:vibrate/vibrate.dart';

class HomeViewState extends ChangeNotifier {
  Timer timer;
  AudioCache audioCache = AudioCache();

  int totalSeconds;
  int currentSecond;
  int interval = 1;

  bool isSoundEnabled = false;
  bool isVibrationEnabled = false;
  bool isStarted = false;
  bool isPaused = false;
  bool isStopped = true;
  bool isFinished = false;

  bool keepVibrating = false;
  bool keepPlayingSound = false;

  String hoursStr = "00";
  String minutesStr = "00";
  String secondsStr = "00";

  HomeViewState() {
    audioCache.load('sound.mp3');
  }

  void toggleSound(bool isSoundEnabled) {
    this.isSoundEnabled = isSoundEnabled;
    notifyListeners();
  }

  void toggleVibration(bool isVibrationEnabled) {
    this.isVibrationEnabled = isVibrationEnabled;
    notifyListeners();
  }

  void startTimer(int totalSeconds) {
    this.totalSeconds = totalSeconds;
    this.currentSecond = totalSeconds;

    initTimer();

    updateViewStateAndNotifyListeners(
        isStarted: true, isPaused: false, isStopped: false, isFinished: false);
  }

  void pauseTimer() {
    updateViewStateAndNotifyListeners(
        isStarted: false, isPaused: true, isStopped: false, isFinished: false);
  }

  void continueTimer() {
    updateViewStateAndNotifyListeners(
        isStarted: true, isPaused: false, isStopped: false, isFinished: false);
  }

  void stopTimer() {
    this.totalSeconds = 0;
    this.currentSecond = 0;

    cancelTimer();
    resetHoursMinutesSecondsStrings();

    updateViewStateAndNotifyListeners(
        isStarted: false, isPaused: false, isStopped: true, isFinished: false);
  }

  void resetTimer() {
    stopTimer();
    stopAlarm();
  }

  void triggerAlarm() {
    cancelTimer();
    startAlarm();

    updateViewStateAndNotifyListeners(
        isStarted: false, isPaused: false, isStopped: false, isFinished: true);
  }

  void initTimer() {
    callback();
    this.timer = new Timer.periodic(new Duration(seconds: interval), (timer) {
      callback();
    });
  }

  void callback() {
    setHoursMinutesSecondsStrings();

    currentSecond -= interval;
    if (currentSecond < 0) {
      triggerAlarm();
    }
  }

  void setHoursMinutesSecondsStrings() {
    final int seconds = currentSecond;
    final int minutes = (seconds / 60).truncate();
    final int hours = (minutes / 60).truncate();

    hoursStr = (hours % 24).toString().padLeft(2, '0');
    minutesStr = (minutes % 60).toString().padLeft(2, '0');
    secondsStr = (seconds % 60).toString().padLeft(2, '0');

    notifyListeners();
  }

  void resetHoursMinutesSecondsStrings() {
    hoursStr = "00";
    minutesStr = "00";
    secondsStr = "00";
  }

  void startAlarm() {
    if (isSoundEnabled) {
      keepPlayingSound = true;
      playSound();
    }
    if (isVibrationEnabled) {
      keepVibrating = true;
      startVibration();
    }
  }

  void playSound({bool onlyOnce = false}) async {
    while (onlyOnce || !onlyOnce && keepPlayingSound) {
      onlyOnce = false;
      audioCache.play('sound.mp3');
      // Wait for the vibration to complete
      await Future.delayed(Duration(milliseconds: 500));
      // Pause between this and the next vibration
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  void startVibration() async {
    while (keepVibrating) {
      Vibrate.vibrate();
      // Wait for the vibration to complete
      await Future.delayed(Duration(milliseconds: 500));
      // Pause between this and the next vibration
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  void updateViewStateAndNotifyListeners(
      {bool isStarted, bool isPaused, bool isStopped, bool isFinished}) {
    this.isStarted = isStarted;
    this.isPaused = isPaused;
    this.isStopped = isStopped;
    this.isFinished = isFinished;
    notifyListeners();
  }

  void stopAlarm() {
    keepPlayingSound = false;
    keepVibrating = false;
  }

  void clearAudioCache() {
    audioCache.clearCache();
  }

  void cancelTimer() {
    timer?.cancel();
  }
}
