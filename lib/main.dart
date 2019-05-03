import 'package:flutter/material.dart';
import 'package:gtech_app/base/services/auth.dart';
import 'package:gtech_app/pages/login/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GTech App',
        theme:
            ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
        home: new Login(auth: new Auth()));
  }
}
