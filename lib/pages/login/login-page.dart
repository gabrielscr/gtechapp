// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gtech_app/base/services/auth.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:gtech_app/pages/home/inicio.google.dart';

// class LoginPage extends StatefulWidget {
//   LoginPage({this.auth, this.onSignedIn});

//   final Auth auth;
//   final VoidCallback onSignedIn;

//   @override
//   State<StatefulWidget> createState() => new LoginPageState();
// }

// enum FormMode { LOGIN, SIGNUP }

// class LoginPageState extends State<LoginPage> {
//   final _formKey = new GlobalKey<FormState>();

//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = new GoogleSignIn();

//   Future<FirebaseUser> _signGoogle(BuildContext context) async {

//     final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;

//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//         accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

//     FirebaseUser userDetails =
//         await _firebaseAuth.signInWithCredential(credential);

//     ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);

//     List<ProviderDetails> providerData = new List<ProviderDetails>();

//     providerData.add(providerInfo);

//     UserDetails details = new UserDetails(
//         userDetails.providerId,
//         userDetails.displayName,
//         userDetails.photoUrl,
//         userDetails.email,
//         providerData);

//     Navigator.push(
//         context,
//         new MaterialPageRoute(
//             builder: (context) => new InicioGoogle(detailsUser: details)));
//     return userDetails;
//   }

//   String _email;
//   String _password;
//   String _errorMessage;

//   // Initial form is login form
//   FormMode _formMode = FormMode.LOGIN;
//   bool _isIos;
//   bool _isLoading;

//   // Check if form is valid before perform login or signup
//   bool _validateAndSave() {
//     final form = _formKey.currentState;
//     if (form.validate()) {
//       form.save();
//       return true;
//     }
//     return false;
//   }

//   // Perform login or signup
//   void _validateAndSubmit() async {
//     setState(() {
//       _errorMessage = "";
//       _isLoading = true;
//     });
//     if (_validateAndSave()) {
//       String userId = "";
//       try {
//         if (_formMode == FormMode.LOGIN) {
//           userId = await widget.auth.signIn(_email, _password);
//           print('Signed in: $userId');
//         } else {
//           userId = await widget.auth.signUp(_email, _password);
//           widget.auth.sendEmailVerification();
//           _showVerifyEmailSentDialog();
//           print('Signed up user: $userId');
//         }
//         setState(() {
//           _isLoading = false;
//         });

//         if (userId.length > 0 &&
//             userId != null &&
//             _formMode == FormMode.LOGIN) {
//           widget.onSignedIn();
//         }
//       } catch (e) {
//         print('Error: $e');
//         setState(() {
//           _isLoading = false;
//           if (_isIos) {
//             _errorMessage = e.details;
//           } else
//             _errorMessage = e.message;
//         });
//       }
//     }
//   }

//   @override
//   void initState() {
//     _errorMessage = "";
//     _isLoading = false;
//     super.initState();
//   }

//   void _changeFormToLogin() {
//     _formKey.currentState.reset();
//     _errorMessage = "";
//     setState(() {
//       _formMode = FormMode.LOGIN;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _isIos = Theme.of(context).platform == TargetPlatform.iOS;
//     return new Scaffold(
//         appBar: new AppBar(
//           title: new Text('GTech App'),
//           centerTitle: true,
//         ),
//         body: Stack(
//           children: <Widget>[
//             _showBody(),
//             _showCircularProgress(),
//           ],
//         ));
//   }

//   Widget _showCircularProgress() {
//     if (_isLoading) {
//       return Center(child: CircularProgressIndicator());
//     }
//     return Container(
//       height: 0.0,
//       width: 0.0,
//     );
//   }

//   void _showVerifyEmailSentDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // return object of type Dialog
//         return AlertDialog(
//           title: new Text("Verifique sua conta"),
//           content: new Text(
//               "Um e-mail de verificação foi enviado para o seu e-mail"),
//           actions: <Widget>[
//             new FlatButton(
//               child: new Text("Fechar"),
//               onPressed: () {
//                 _changeFormToLogin();
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _showBody() {
//     return new Container(
//         padding: EdgeInsets.all(16.0),
//         child: new Form(
//           key: _formKey,
//           child: new ListView(
//             shrinkWrap: true,
//             children: <Widget>[
//               _showLogo(),
//               _showEmailInput(),
//               _showPasswordInput(),
//               _showPrimaryButton(),
//               _showGoogleSign(),
//               _showErrorMessage(),
//             ],
//           ),
//         ));
//   }

//   Widget _showErrorMessage() {
//     if (_errorMessage.length > 0 && _errorMessage != null) {
//       return new Text(
//         _errorMessage,
//         style: TextStyle(
//             fontSize: 13.0,
//             color: Colors.red,
//             height: 1.0,
//             fontWeight: FontWeight.w300),
//       );
//     } else {
//       return new Container(
//         height: 0.0,
//       );
//     }
//   }

//   Widget _showLogo() {
//     return new Hero(
//       tag: 'hero',
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
//         child: CircleAvatar(
//           backgroundColor: Colors.transparent,
//           radius: 48.0,
//           child: Image.asset('assets/img/flutter-icon.png'),
//         ),
//       ),
//     );
//   }

//   Widget _showEmailInput() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
//       child: new TextFormField(
//         maxLines: 1,
//         keyboardType: TextInputType.emailAddress,
//         autofocus: false,
//         decoration: new InputDecoration(
//             hintText: 'Email',
//             icon: new Icon(
//               Icons.mail,
//               color: Colors.grey,
//             )),
//         validator: (value) =>
//             value.isEmpty ? 'Email não pode estar em branco' : null,
//         onSaved: (value) => _email = value,
//       ),
//     );
//   }

//   Widget _showPasswordInput() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
//       child: new TextFormField(
//         maxLines: 1,
//         obscureText: true,
//         autofocus: false,
//         decoration: new InputDecoration(
//             hintText: 'Senha',
//             icon: new Icon(
//               Icons.lock,
//               color: Colors.grey,
//             )),
//         validator: (value) =>
//             value.isEmpty ? 'Senha não pode estar em branco' : null,
//         onSaved: (value) => _password = value,
//       ),
//     );
//   }

//   Widget _showPrimaryButton() {
//     return new Padding(
//         padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
//         child: SizedBox(
//           height: 40.0,
//           child: new RaisedButton(
//             elevation: 5.0,
//             shape: new RoundedRectangleBorder(
//                 borderRadius: new BorderRadius.circular(30.0)),
//             color: Colors.white,
//             child: new Text(
//               'Login',
//             ),
//             onPressed: _validateAndSubmit,
//           ),
//         ));
//   }

//   Widget _showGoogleSign() {
//     return new Padding(
//         padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
//         child: SizedBox(
//           height: 40.0,
//           child: Align(
//             alignment: Alignment.center,
//             child: new IconButton(
//               icon: Icon(FontAwesomeIcons.google, color: Colors.red),
//               onPressed: () => _signGoogle(context)
//                   .then((FirebaseUser user) => print(user))
//                   .catchError((e) => print(e)),
//             ),
//           ),
//         ));
//   }
// }

// class UserDetails {
//   final String providerDetails;
//   final String userName;
//   final String photoUrl;
//   final String userEmail;
//   final List<ProviderDetails> providerData;
//   UserDetails(this.providerDetails, this.userName, this.photoUrl,
//       this.userEmail, this.providerData);
// }

// class ProviderDetails {
//   ProviderDetails(this.providerDetails);

//   final String providerDetails;
// }
