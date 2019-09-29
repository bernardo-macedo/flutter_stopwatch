import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/config/l10n.dart';

class Home extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.getString(context, 'home_title')),
      ),
    );
  }
}
