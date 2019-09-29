import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/feature/home/home.dart';
import 'package:flutter_stopwatch/feature/home/home_view_state.dart';
import 'package:flutter_stopwatch/util/navigation.dart';
import 'package:provider/provider.dart';

MaterialPageRoute getRouteFactory(settings) {
  MaterialPageRoute route;
  switch (settings.name) {
    case Home.routeName:
      {
        route = Navigation.makeRoute(Consumer<HomeViewState>(
          builder: (context, viewState, child) => Home(viewState: viewState),
        ));
      }
      break;
  }

  return route;
}
