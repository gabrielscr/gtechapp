import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtech_app/base/services/auth.dart';
import 'package:gtech_app/base/services/validator.dart';
import 'package:gtech_app/domain/user.dart';
import 'package:gtech_app/pages/image/image-handler.dart';
import 'package:gtech_app/widgets/loader.dart';

class UserInsert extends StatefulWidget {
  @override
  _UserCreateEditState createState() => _UserCreateEditState();
}

class _UserCreateEditState extends State<UserInsert>
    with TickerProviderStateMixin, ImagePickerListener {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = new TextEditingController();
  final TextEditingController _lastName = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  AnimationController _controller;
  ImagePickerHandler imagePicker;
  File _image;
  String photo;

  bool isEditing = false;
  bool _autoValidate = false;
  bool _loadingVisible = false;

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

  Widget build(BuildContext context) {
    var fotoPerfil = photo;
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 80.0,
          child: new GestureDetector(
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
                        border: Border.all(color: Colors.red, width: 5.0),
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(80.0)),
                      ),
                    ),
            ),
          )),
    );

    final firstName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _firstName,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Nome',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final lastName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _lastName,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Último nome',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: Validator.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'E-mail',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _password,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Senha',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          addUser(
              firstName: _firstName.text,
              lastName: _lastName.text,
              email: _email.text,
              password: _password.text,
              context: context);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text(isEditing ? "Editar" : "Cadastrar",
            style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(this.isEditing ? 'Editar Usuário' : 'Adicionar Usuário'),
      ),
      backgroundColor: Colors.white,
      body: LoadingScreen(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      logo,
                      SizedBox(height: 48.0),
                      firstName,
                      SizedBox(height: 24.0),
                      lastName,
                      SizedBox(height: 24.0),
                      email,
                      SizedBox(height: 24.0),
                      password,
                      SizedBox(height: 12.0),
                      signUpButton,
                    ],
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void addUser(
      {String firstName,
      String lastName,
      String email,
      String password,
      String photo,
      BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      this.isEditing = true;
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        StorageReference ref = FirebaseStorage.instance.ref().child(this.photo);
        StorageUploadTask upload = ref.putFile(_image);

        var downUrl = await (await upload.onComplete).ref.getDownloadURL();
        //need await so it has chance to go through error if found.
        await Auth.signUp(email, password).then((uID) {
          Auth.addUserSettingsDB(new User(
              userId: uID,
              email: email,
              firstName: firstName,
              lastName: lastName,
              photo: downUrl));
        });
        Navigator.of(context).pop();
      } catch (e) {
        _changeLoadingVisible();
        print("Opa! Ocorreu um erro: $e");
        String exception = Auth.getExceptionText(e);
        Flushbar(
          title: "Opa! Ocorreu um erro",
          message: exception,
          duration: Duration(seconds: 5),
        )..show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;

      if (_image == null) {
        return;
      } else {
        this.photo = _image.absolute.path;
      }
    });
  }
}
