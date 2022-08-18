import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String userId;
  String? imageUrl;
  String caption;
  List likes;
  Post(this.id, this.userId, this.imageUrl, this.caption, this.likes);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'caption': caption,
      'likes': likes,
    };
  }

  static Post toPost(DocumentSnapshot snap) {
    final map = snap.data()! as Map<String, dynamic>;
    return Post(
      map['id'],
      map['userId'],
      map['imageUrl'],
      map['caption'],
      map['likes'],
    );
  }
}
