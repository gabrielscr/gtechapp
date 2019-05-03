import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.transparent),
            accountName: Text(
              'Gabriel Rocha'
            ),
            accountEmail: Text('gabrielscrocha4@gmail.com'),
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
