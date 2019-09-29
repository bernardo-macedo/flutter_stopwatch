import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/feature/home/home.dart';
import 'package:flutter_stopwatch/util/navigation.dart';

MaterialPageRoute getRouteFactory(settings) {
  MaterialPageRoute route;
  switch (settings.name) {
    case Home.routeName:
      {
        route = Navigation.makeRoute(Home());
      }
      break;
  }

  return route;
}
