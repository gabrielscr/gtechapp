import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEdit extends StatefulWidget {

  final DocumentSnapshot doc;
  UserEdit({this.doc});

  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          title: Text(widget.doc.data["name"]),
        ),
      ),
    );
  }
}