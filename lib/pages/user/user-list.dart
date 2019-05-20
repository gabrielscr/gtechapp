import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtech_app/pages/user/user-edit.dart';
import 'package:gtech_app/pages/user/user-insert.dart';
import 'package:gtech_app/pages/user/user-service.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final db = Firestore.instance;

  UserService userService = new UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de usuários'),
      ),
      body: Container(
        child: new StreamBuilder(
          stream: db.collection('users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return new Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              );
            final int userLength = snapshot.data.documents.length;
            return ListView.builder(
                itemCount: userLength,
                itemBuilder: (context, index) {
                  final DocumentSnapshot _user = snapshot.data.documents[index];
                  return new ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_user['photo']),
                    ),
                    title: new Text(_user['firstName']),
                    subtitle: Text(_user['email']),
                    trailing: IconButton(
                      icon: new Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => delete(snapshot.data.documents[index]),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserEdit(doc: _user)));

                      print(_user.documentID);
                    },
                  );
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserInsert()));
        },
      ),
    );
  }

  delete(DocumentSnapshot doc) async {
    executeDelete() async {
      Navigator.pop(context);
      userService.delete(doc, context).then((result) {
        userService.list();
      });
    }

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Deseja realmente excluir?'),
            content: Text('Esta ação não pode ser desfeita'),
            actions: <Widget>[
              new FlatButton(
                child: Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: Text('Excluir'),
                textColor: Colors.red,
                onPressed: () async {
                  await executeDelete();
                },
              )
            ],
          );
        });
  }
}
