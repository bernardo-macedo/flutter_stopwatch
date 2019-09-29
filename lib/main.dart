import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base/my_app.dart';

Future<void> main() async {
  List<SingleChildCloneableWidget> providers = [];

  runApp(MyApp(dependencies: providers));
}
