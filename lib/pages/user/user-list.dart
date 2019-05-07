import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtech_app/pages/user/user-create-edit.dart';
import 'package:gtech_app/pages/user/user-service.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final db = Firestore.instance;
  String id;
  String name;
  String email;

  UserService userService = new UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de usuários'),
      ),
      body: Container(
        child: new FutureBuilder(
          future: userService.list(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return new Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              );

            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return new ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data[index].data['fotoPerfil']),
                    ),
                    title: new Text(snapshot.data[index].data['name']),
                    subtitle: Text(snapshot.data[index].data['email']),
                    trailing: IconButton(
                      icon: new Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => delete(snapshot.data[index]),
                    ),
                    onTap: () => {},
                  );
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UserCreateEdit()));
        },
      ),
    );
  }

  navigateToEdit(DocumentSnapshot doc) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UserCreateEdit(doc: doc)));
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
