import 'package:flutter/material.dart';
import 'package:gtech_app/base/services/auth.dart';
import 'package:gtech_app/pages/menu/menu.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();

  Inicio({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      drawer: Menu(),
    );
  }
}
