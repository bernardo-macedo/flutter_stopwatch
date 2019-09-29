import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/config/l10n.dart';

import 'home_view_state.dart';

class Home extends StatefulWidget {
  static const routeName = '/';

  final HomeViewState viewState;

  const Home({Key key, this.viewState}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'images/ic_stopwatch.png',
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    L10n.getString(context, 'home_title'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                  Switch(
                    value: widget.viewState.isSoundEnabled,
                    onChanged: (value) {
                      widget.viewState.toggleSound(isSoundEnabled: value);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
