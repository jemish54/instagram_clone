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
    String? imageUrl;
    if (image != null) {
      imageUrl = await StorageService().storePostImage(id, image);
    }
    await _firestore.collection('posts').doc(id).set({
      'postId': id,
      'postUserId': _auth.currentUser!.uid,
      'postImageUrl': imageUrl,
      'postCaption': caption,
      'postLikes': [],
    });
  }

  deletePost(String postId, String? postImageUrl) async {
    await _firestore.collection('posts').doc(postId).delete();
    if (postImageUrl != null) {
      await StorageService().deletePostImage(postImageUrl);
    }
  }

  Stream<List<Post>> getFeedPosts() {
    Stream<QuerySnapshot> postsStream =
        _firestore.collection('posts').snapshots();

    return postsStream.map((event) => event.docs
        .map((e) => Post(
              e['postId'],
              e['postUserId'],
              e['postImageUrl'],
              e['postCaption'],
              e['postLikes'],
            ))
        .toList());
  }

  Stream<List<Post>> getUserPosts(String uid) {
    Stream<QuerySnapshot> postsStream = _firestore
        .collection('posts')
        .where('postUserId', isEqualTo: uid)
        .snapshots();

    return postsStream.map((event) => event.docs
        .map((e) => Post(
              e['postId'],
              e['postUserId'],
              e['postImageUrl'],
              e['postCaption'],
              e['postLikes'],
            ))
        .toList());
  }
}
