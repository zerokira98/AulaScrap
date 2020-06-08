import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepo {
  Future setUser(Map data) async {
    return Firestore.instance.collection('users').document().setData(data);
  }

  Stream getUsers() {
    return Firestore.instance.collection('users').snapshots();
  }

  Stream getMessage() {
    return Firestore.instance.collection('message').snapshots();
  }
}
