import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> storeProfileImage(Uint8List file) async {
    Reference ref =
        _storage.ref().child('profileImages').child(_auth.currentUser!.uid);
    TaskSnapshot snap = await ref.putData(file);
    return await snap.ref.getDownloadURL();
  }

  Future<String?> storePostImage(String id, Uint8List file) async {
    Reference ref = _storage
        .ref()
        .child('postImage')
        .child(_auth.currentUser!.uid)
        .child(id);
    TaskSnapshot snap = await ref.putData(file);
    return await snap.ref.getDownloadURL();
  }

  deletePostImage(String postImageUrl) async {
    await _storage.refFromURL(postImageUrl).delete();
  }
}
