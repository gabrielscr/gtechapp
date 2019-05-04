import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gtech_app/pages/image/image-handler.dart';

class UserCreateEdit extends StatefulWidget {
  @override
  _UserCreateEditState createState() => _UserCreateEditState();
}

class _UserCreateEditState extends State<UserCreateEdit>
    with TickerProviderStateMixin, ImagePickerListener {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String email;

  File _image;
  String fotoPerfil;
  AnimationController _controller;
  Animation _animation;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Usuários'),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: new ListView(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                new GestureDetector(
                  onTap: () => imagePicker.showDialog(context),
                  child: new Center(
                    child: _image == null
                        ? new Stack(
                            children: <Widget>[
                              new Center(
                                child: FadeTransition(
                                  opacity: _animation,
                                  child: new CircleAvatar(
                                    radius: 80.0,
                                    backgroundImage: fotoPerfil == null
                                        ? AssetImage('assets/img/male.png')
                                        : AssetImage(fotoPerfil),
                                    backgroundColor: const Color(0xFF778899),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : new Container(
                            height: 160.0,
                            width: 160.0,
                            decoration: new BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: new DecorationImage(
                                image: new ExactAssetImage(_image.path),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(color: Colors.red, width: 5.0),
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(80.0)),
                            ),
                          ),
                  ),
                ),
                new TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      labelText: 'Nome', icon: Icon(Icons.person)),
                  onSaved: (v) => name = v,
                ),
                new TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                      labelText: 'E-mail', icon: Icon(Icons.email)),
                  onSaved: (v) => email = v,
                ),
                new ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text(
                        'Inserir',
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        createData();
                      },
                      color: Colors.blue,
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      StorageReference img = FirebaseStorage.instance.ref().child(fotoPerfil);
      img.putFile(_image);
      DocumentReference ref = await db.collection('user').add(
          {'name': '$name', 'email': '$email', 'fotoPerfil': '$fotoPerfil'});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('user').document(id).get();
    print(snapshot.data['name']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db
        .collection('user')
        .document(doc.documentID)
        .updateData({'todo': 'please'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('user').document(doc.documentID).delete();
    setState(() => id = null);
  }

  @override
  userImage(File _image) {
    return null;
  }
}
