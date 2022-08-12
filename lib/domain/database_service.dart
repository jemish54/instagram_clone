import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/domain/firebase_storage.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  storePost(Uint8List? image, String caption) async {
    if (image == null && caption.isEmpty) return;
    String id = const Uuid().v1();
    String? postImageUrl;
    if (image != null) {
      postImageUrl = await StorageService().storePostImage(id, image);
    }
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('posts')
        .doc(id)
        .set({
      'postId': id,
      'postImageUrl': postImageUrl,
      'postCaption': caption,
    });
  }

  deletePost(String postId, String? postImageUrl) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('posts')
        .doc(postId)
        .delete();
    if (postImageUrl != null) {
      await StorageService().deletePostImage(postImageUrl);
    }
  }

  Stream<List<Post>> getUserPosts() {
    Stream<QuerySnapshot> postsStream = _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('posts')
        .snapshots();

    return postsStream.map((event) => event.docs
        .map((e) => Post(e['postId'], e['postImageUrl'], e['postCaption']))
        .toList());
  }
}
