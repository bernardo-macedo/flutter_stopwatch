import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stopwatch/config/l10n.dart';
import 'package:flutter_stopwatch/config/routes.dart';
import 'package:flutter_stopwatch/feature/home/home.dart';

class BaseMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        StringLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'ExtraBold',
          textTheme: TextTheme(body1: TextStyle(fontSize: 16))),
      supportedLocales: supportedLocales,
      initialRoute: Home.routeName,
      onGenerateRoute: getRouteFactory,
    );
  }
}
