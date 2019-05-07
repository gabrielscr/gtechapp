import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gtech_app/pages/image/image-handler.dart';
import 'package:gtech_app/pages/user/user-service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class UserCreateEdit extends StatefulWidget {
  final DocumentSnapshot doc;
  UserCreateEdit({this.doc});

  @override
  _UserCreateEditState createState() => _UserCreateEditState();
}

class _UserCreateEditState extends State<UserCreateEdit>
    with TickerProviderStateMixin, ImagePickerListener {
  String id;
  final _formKey = GlobalKey<FormState>();
  String name;
  String email;
  DateTime dataNascimento;
  File _image;
  String filename;
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  UserService userService = new UserService();

  @override
  Widget build(BuildContext context) {
    var fotoPerfil = filename;
    var appBarText = this.id == null ? 'Inserir Usuário' : 'Editar Usuário';
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarText),
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
                    onTap: () => imagePicker.showDialog(context),
                    child: new Center(
                      child: _image == null
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
                                  image: new ExactAssetImage(_image.path),
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
                  new TextField(
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        labelText: 'Nome', icon: Icon(Icons.person)),
                    onChanged: (v) => this.name = v,
                  ),
                  new TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                        labelText: 'E-mail', icon: Icon(Icons.email)),
                    onChanged: (v) => this.email = v,
                  ),
                  FormBuilderDateTimePicker(
                    attribute: "date",
                    inputType: InputType.date,
                    format: DateFormat("dd-MM-yyyy"),
                    decoration: InputDecoration(
                        labelText: "Data de nascimento",
                        icon: Icon(Icons.date_range)),
                    onChanged: (v) => this.dataNascimento = v,
                  ),
                  new ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new RaisedButton(
                        child: new Text(
                          'Inserir',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () => submit(context),
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

  void submit(context) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask upload = ref.putFile(_image);

    var downUrl = await (await upload.onComplete).ref.getDownloadURL();
    Map<String, dynamic> userData = {
      'name': '$name',
      'email': '$email',
      'fotoPerfil': '$downUrl',
      'dataNascimento': '$dataNascimento'
    };
    if (id == null) {
      userService.create(userData);
    } else {
      userService.update(context, userData);
    }
    Navigator.of(context).pop();
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;

      if (_image == null) {
        return;
      } else {
        this.filename = _image.absolute.path;
      }
    });
  }
}
