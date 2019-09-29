import 'dart:async';

import 'package:flutter/cupertino.dart';

class HomeViewState extends ChangeNotifier {
  bool isSoundEnabled = false;
  bool isVibrationEnabled = false;

  Future<void> toggleSound({bool isSoundEnabled}) async {
    this.isSoundEnabled = isSoundEnabled;
    notifyListeners();
  }
}
