import 'package:flutter/material.dart';
import 'package:gtech_app/base/services/auth.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();

  BaseAuth auth;
}

class _MenuState extends State<Menu> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.transparent),
            accountName: Text('Gabriel Rocha'),
            accountEmail: Text(''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/profile/profile.jpg'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Usuários'),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ListaUsuarios()));
            },
          ),
        ],
      ),
    );
  }
}
