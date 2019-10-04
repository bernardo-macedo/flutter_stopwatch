import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:vibrate/vibrate.dart';

class HomeViewState extends ChangeNotifier {
  Timer timer;
  AudioCache audioCache = AudioCache();

  int totalMilliseconds;
  int currentMillisecond;
  int interval = 100;

  bool isSoundEnabled = false;
  bool isVibrationEnabled = false;
  bool isStarted = false;
  bool isPaused = false;
  bool isStopped = true;
  bool isFinished = false;

  bool keepVibrating = false;
  bool keepPlayingSound = false;

  String hoursStr = "";
  String minutesStr = "";
  String secondsStr = "";

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

  void startTimer(int totalMilliseconds) {
    initTimer();
    this.totalMilliseconds = totalMilliseconds;
    this.currentMillisecond = totalMilliseconds;

    this.isStarted = true;
    this.isPaused = false;
    this.isStopped = false;
    this.isFinished = false;

    notifyListeners();
  }

  void pauseTimer() {
    this.isStarted = false;
    this.isPaused = true;
    this.isStopped = false;
    this.isFinished = false;

    notifyListeners();
  }

  void continueTimer() {
    this.isStarted = true;
    this.isPaused = false;
    this.isStopped = false;
    this.isFinished = false;

    notifyListeners();
  }

  void stopTimer() {
    cancelTimer();
    this.totalMilliseconds = 0;
    this.currentMillisecond = 0;

    this.isStarted = false;
    this.isPaused = false;
    this.isStopped = true;
    this.isFinished = false;

    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    stopAlarm();
  }

  void triggerAlarm() {
    cancelTimer();
    startAlarm();

    this.isStarted = false;
    this.isPaused = false;
    this.isStopped = false;
    this.isFinished = true;

    notifyListeners();
  }

  void callback(Timer timer) {
    if (!isPaused && !isStopped) {
      final int seconds = (currentMillisecond / 1000).truncate();
      final int minutes = (seconds / 60).truncate();
      final int hours = (minutes / 60).truncate();

      hoursStr = (hours % 24).toString().padLeft(2, '0');
      minutesStr = (minutes % 60).toString().padLeft(2, '0');
      secondsStr = (seconds % 60).toString().padLeft(2, '0');

      currentMillisecond -= interval;
      if (currentMillisecond < 1) {
        triggerAlarm();
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

  void stopAlarm() {
    keepPlayingSound = false;
    keepVibrating = false;
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

  void clearAudioCache() {
    audioCache.clearCache();
  }
}
