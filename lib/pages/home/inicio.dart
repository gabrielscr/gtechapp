import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtech_app/base/services/auth.dart';
import 'package:gtech_app/pages/user/user-list.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();

  Inicio({Key key, this.auth, this.userId, this.onSignedOut}) : super(key: key);

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
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: _signOut)
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text('teste'),
                    accountEmail: Text(snapshot.data.email),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('assets/profile/profile.jpg'),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Usuários'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => UserList()));
                    },
                  ),
                ],
              );
            } else {
              return Text('Loading...');
            }
          },
        ),
      ),
    );
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}
