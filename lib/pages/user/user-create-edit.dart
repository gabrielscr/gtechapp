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

class _UserCreateEditState extends State<UserCreateEdit> {
  String id;
  final _formKey = GlobalKey<FormState>();
  String name;
  String email;
  DateTime dataNascimento;
  File image;
  String filename;

  UserService userService = new UserService();

  ImagePickerListener _listener;

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
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      new CircleAvatar(
                        radius: 80.0,
                        backgroundImage: fotoPerfil == null
                            ? AssetImage('assets/img/male.png')
                            : AssetImage(fotoPerfil),
                        backgroundColor: const Color(0xFF778899),
                      ),
                      new IconButton(
                          onPressed: () => openCamera(),
                          icon: Icon(FontAwesomeIcons.camera,
                              color: Colors.white)),
                    ],
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
    StorageUploadTask upload = ref.putFile(image);

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

  openCamera() async {
    var img = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 350, maxWidth: 350);

    cropImage(img);

    this.image = img;
  }

  Future cropImage(File image) async {
    if (image == null) {
      return;
    } else {
      File croppedFile = await ImageCropper.cropImage(
        toolbarTitle: 'Editar foto',
        toolbarColor: Colors.black,
        circleShape: true,
        sourcePath: image.path,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
      );
      _listener.userImage(croppedFile);
    }
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
