import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> create(data) async {
    if (isLoggedIn()) {
      Firestore.instance.collection('users').add(data).catchError((e) {
        print(e);
      });
    } else {
      print('Você deve se logar.');
    }
  }

  list() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection('users').getDocuments();

    return qn.documents;
  }

  update(selectedDoc, newValues) {
    Firestore.instance
        .collection('users')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  delete(DocumentSnapshot doc, context) async {
    await Firestore.instance
        .collection('users')
        .document(doc.documentID)
        .delete();
  }
}
