import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/feature/home/home_view_state.dart';
import 'package:provider/provider.dart';

import 'base/my_app.dart';

Future<void> main() async {
  List<SingleChildCloneableWidget> providers = [
    ChangeNotifierProvider<HomeViewState>(builder: (_) => HomeViewState())
  ];

  runApp(MyApp(dependencies: providers));
}
