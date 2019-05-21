import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gtech_app/base/services/state_widget.dart';
import 'package:gtech_app/domain/state.dart';
import 'package:gtech_app/domain/user.dart';
import 'package:gtech_app/pages/login/sign_in.dart';
import 'package:gtech_app/pages/user/user-list.dart';
import 'package:gtech_app/widgets/loader.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key, this.user, this.userDetails}) : super(key: key);

  final User user;
  final FirebaseUser userDetails;

  StateModel appState;
  bool _loadingVisible = false;

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null || appState.user == null)) {
      return SignInScreen();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }

      final email = appState?.firebaseUserAuth?.email ?? '';
      final firstName = appState?.user?.firstName ?? '';
      final lastName = appState?.user?.lastName ?? '';
      final photo = appState?.user?.photo ?? '';

      return Scaffold(
        appBar: AppBar(
          title: Text('GTechApp'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                otherAccountsPictures: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.signOutAlt),
                    color: Colors.white,
                    onPressed: () {
                      StateWidget.of(context).logOutUser();
                    },
                  )
                ],
                currentAccountPicture: ClipOval(
                  child: FadeInImage.assetNetwork(
                    fadeInDuration: const Duration(
                      seconds: 2
                    ),
                    placeholder: 'assets/images/loading.gif',
                    image: photo,
                    fit: BoxFit.cover,
                  ),
                ),
                accountName: Text(firstName + ' ' + lastName),
                accountEmail: Text(email),
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
          ),
        ),
        backgroundColor: Colors.white,
        body: LoadingScreen(child: Text('sadas'), inAsyncCall: _loadingVisible),
      );
    }
  }

  String loadingImg =
      'https://loading.io/spinners/microsoft/lg.rotating-balls-spinner.gif';
}
