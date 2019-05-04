import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class UserCreateEdit extends StatefulWidget {
  @override
  _UserCreateEditState createState() => _UserCreateEditState();
}

class _UserCreateEditState extends State<UserCreateEdit> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String email;
  File image;
  String filename;

  @override
  Widget build(BuildContext context) {
    var fotoPerfil = filename;
    return Scaffold(
        appBar: AppBar(
          title: Text('Usuários'),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  new GestureDetector(
                    onTap: () => getImage(),
                    child: new Center(
                      child: image == null
                          ? new Stack(
                              children: <Widget>[
                                new Center(
                                  child: new CircleAvatar(
                                    radius: 80.0,
                                    backgroundImage: fotoPerfil == null
                                        ? AssetImage('assets/img/male.png')
                                        : AssetImage(fotoPerfil),
                                    backgroundColor: const Color(0xFF778899),
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
                                  image: new ExactAssetImage(image.path),
                                  fit: BoxFit.cover,
                                ),
                                border:
                                    Border.all(color: Colors.red, width: 5.0),
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
          ),
        ));
  }

  Future getImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      image = img;
      filename = basename(image.path);
    });
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      StorageReference ref = FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask upload = ref.putFile(image);

      var downUrl = await (await upload.onComplete).ref.getDownloadURL();

      DocumentReference docRef = await db
          .collection('user')
          .add({'name': '$name', 'email': '$email', 'fotoPerfil': '$downUrl'});
      setState(() => id = docRef.documentID);
      print(docRef.documentID);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('user').document(id).get();
    print(snapshot.data['name']);
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('user').document(doc.documentID).delete();
    setState(() => id = null);
  }
}
