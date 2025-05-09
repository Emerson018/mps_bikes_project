import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(String email, String name) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({
            'id': _auth.currentUser!.uid,
            'email': email,
            'name': name, // <-- Adiciona o campo "name"
          });
      return true;
    } catch (e) {
      return false;
    }
  }
}