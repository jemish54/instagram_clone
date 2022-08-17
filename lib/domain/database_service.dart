import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/domain/storage_service.dart';
import 'package:instagram_clone/model/app_user.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AppUser> getUserById(String uId) async {
    final snap = await _firestore.collection('users').doc(uId).get();
    return AppUser.toAppUser(snap);
  }

  storePost(Uint8List? image, String caption) async {
    if (image == null && caption.isEmpty) return;
    String id = const Uuid().v1();
    String? imageUrl;
    if (image != null) {
      imageUrl = await StorageService().storePostImage(id, image);
    }
    AppUser user = await getUserById(_auth.currentUser!.uid);
    await _firestore.collection('posts').doc(id).set(Post(
          id,
          user.uid,
          user.username,
          user.profileImageUrl,
          imageUrl,
          caption,
          [],
        ).toJson());
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

    return postsStream
        .map((event) => event.docs.map((e) => Post.toAppUser(e)).toList());
  }

  Stream<List<Post>> getUserPosts(String uid) {
    Stream<QuerySnapshot> postsStream = _firestore
        .collection('posts')
        .where('userId', isEqualTo: uid)
        .snapshots();

    return postsStream
        .map((event) => event.docs.map((e) => Post.toAppUser(e)).toList());
  }
}
