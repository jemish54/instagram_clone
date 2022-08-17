import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/domain/storage_service.dart';
import 'package:instagram_clone/model/app_user.dart';

final authServiceProvider = Provider<AuthService>(((ref) => AuthService()));
final authStateStreamProvider = StreamProvider<User?>(
    (ref) => ref.read(authServiceProvider).authStateStream);

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateStream => _auth.authStateChanges();

  User? get user => _auth.currentUser;

  Stream<AppUser> currentAppUser() {
    final userStream =
        _firestore.collection('users').doc(user!.uid).snapshots();
    return userStream.map((event) => AppUser.toAppUser(event));
  }

  Future<String> signUpUser(
    String username,
    String email,
    String password,
  ) async {
    String res = "Some Error Occured";
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return "Empty Field Not Allowed";
    } else {
      try {
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await _firestore.collection('users').doc(userCred.user!.uid).set(
            AppUser(userCred.user!.uid, username, '', null, null, [], [])
                .toJson());
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

  Future<void> editUserDetails(String username, String bio,
      Uint8List? profileImage, Uint8List? coverImage) async {
    final profileImageUrl = profileImage != null
        ? await StorageService().storeProfileImage(profileImage)
        : null;
    final coverImageUrl = coverImage != null
        ? await StorageService().storeProfileCoverImage(coverImage)
        : null;
    final userDataRef = _firestore.collection('users').doc(user!.uid);
    final userOldData = AppUser.toAppUser(await userDataRef.get());
    if (username != userOldData.username) {
      userDataRef.update({'name': username});
    }
    if (bio != userOldData.bio) {
      userDataRef.update({'bio': bio});
    }
    if (profileImageUrl != null) {
      userDataRef.update({'profileImageUrl': profileImageUrl});
    }
    if (coverImageUrl != null) {
      userDataRef.update({'coverImageUrl': coverImageUrl});
    }
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
  }
}
