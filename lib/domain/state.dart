import 'package:firebase_auth/firebase_auth.dart';
import 'package:gtech_app/domain/settings.dart';
import 'package:gtech_app/domain/user.dart';

class StateModel {
  bool isLoading;
  FirebaseUser firebaseUserAuth;
  User user;
  Settings settings;

  StateModel({
    this.isLoading = false,
    this.firebaseUserAuth,
    this.user,
    this.settings,
  });
}
