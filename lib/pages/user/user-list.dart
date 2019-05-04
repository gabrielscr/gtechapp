import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gtech_app/pages/user/user-create-edit.dart';
import 'package:gtech_app/pages/user/user-edit.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Future getUsers() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection("user").getDocuments();

    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de usuários'),
      ),
      body: Container(
        child: new FutureBuilder(
          future: getUsers(),
          builder: (_, snapshot) {
            if (!snapshot.hasData)
              return new Center(
                child: CircularProgressIndicator(),
              );

            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return new ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data[index].data['fotoPerfil']),
                    ),
                    title: new Text(snapshot.data[index].data['name']),
                    subtitle: Text(snapshot.data[index].data['email']),
                    trailing: IconButton(
                      icon: new Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {},
                    ),
                    onTap: () => navigateToEdit(snapshot.data[index]),
                  );
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UserCreateEdit()));
        },
      ),
    );
  }

  navigateToEdit(DocumentSnapshot doc) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserEdit(doc: doc)));
  }
}
