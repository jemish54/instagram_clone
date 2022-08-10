import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> authStateStream() => _auth.authStateChanges();

  Future<String> signUpUser(
    String username,
    String email,
    String password,
  ) async {
    String res = "Some Error Occured";
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return "Error Empty";
    } else {
      try {
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await _firestore.collection('users').doc(userCred.user!.uid).set({
          'uid': userCred.user!.uid,
          'username': username,
          'followers': [],
          'following': [],
        });
        res = "Success";
      } catch (e) {
        res = e.toString();
      }
      return res;
    }
  }

  Future<String> logInUser(
    String email,
    String password,
  ) async {
    String res = "Some Error Occured";
    if (email.isEmpty || password.isEmpty) {
      return "Error Empty";
    } else {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } catch (e) {
        res = e.toString();
      }
      return res;
    }
  }
}
