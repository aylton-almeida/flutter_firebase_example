import 'package:flutter/material.dart';
import 'assets/screens/login/index.dart';
import 'assets/screens/logado/index.dart';

class Routes {
  //Map contendo rotas do app
  var routes = <String, WidgetBuilder>{
    //'/LoginPage': (BuildContext context) => LoginPage(),
    '/LogadoPage': (BuildContext context) => LogadoPage()
  };

  final appTheme = ThemeData(
    primaryColor: Colors.blue[900],
    accentColor: Colors.blue[300],
    cursorColor: Colors.blue[300],
    buttonColor: Colors.blue[900],
    textSelectionColor: Colors.blue[300],
    textSelectionHandleColor: Colors.blue[300],
  );

  Routes() {
    runApp(new MaterialApp(
      title: 'App beleza',
      home: LoginPage(),
      theme: appTheme,
      routes: routes,
    ));
  }
}
