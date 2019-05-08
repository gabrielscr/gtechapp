// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:gtech_app/pages/login/login-page.dart';
// import 'package:gtech_app/pages/products/product-list.dart';
// import 'package:gtech_app/pages/user/user-list.dart';

// class InicioGoogle extends StatelessWidget {
//   InicioGoogle({Key key, @required this.detailsUser}) : super(key: key);

//   final UserDetails detailsUser;

//   @override
//   Widget build(BuildContext context) {
//     final GoogleSignIn _gSignIn = GoogleSignIn();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Inicio'),
//         actions: <Widget>[
//           new FlatButton(
//               child: new Text('Logout',
//                   style: new TextStyle(fontSize: 17.0, color: Colors.white)),
//               onPressed: () {
//                 _gSignIn.signOut();
//                 Navigator.pop(context);
//               })
//         ],
//       ),
//       drawer: Drawer(
//           child: ListView(
//         children: <Widget>[
//           UserAccountsDrawerHeader(
//             decoration: BoxDecoration(color: Colors.black),
//             accountName: Text(detailsUser.userName),
//             accountEmail: Text(detailsUser.userEmail),
//             currentAccountPicture: CircleAvatar(
//               backgroundImage: NetworkImage(detailsUser.photoUrl),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text('Usuários'),
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => UserList()));
//             },
//           ),
//                     ListTile(
//             leading: Icon(FontAwesomeIcons.box),
//             title: Text('Produtos'),
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => ProductList()));
//             },
//           )
//         ],
//       )),
//     );
//   }
// }
