import 'package:flutter/cupertino.dart';

class HomeViewState extends ChangeNotifier {
  bool isSoundEnabled = false;
  bool isVibrationEnabled = false;

  void toggleSound(bool isSoundEnabled) {
    this.isSoundEnabled = isSoundEnabled;
    notifyListeners();
  }

  void toggleVibration(bool isVibrationEnabled) {
    this.isVibrationEnabled = isVibrationEnabled;
    notifyListeners();
  }
}
