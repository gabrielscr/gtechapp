import 'package:flutter/material.dart';
import 'package:gtech_app/base/services/state_widget.dart';
import 'package:gtech_app/pages/home/inicio.dart';
import 'package:gtech_app/pages/login/forgot_password.dart';
import 'package:gtech_app/pages/login/sign_in.dart';
import 'package:gtech_app/pages/login/sign_up.dart';
import 'package:gtech_app/widgets/theme.dart';

void main() {
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );
  runApp(stateWidget);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GTech App',
      theme: buildTheme(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomeScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
