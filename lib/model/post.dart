import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String userId;
  String userName;
  String? userProfileImageUrl;
  String? imageUrl;
  String caption;
  List likes;
  Post(this.id, this.userId, this.userName, this.userProfileImageUrl,
      this.imageUrl, this.caption, this.likes);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userProfileImageUrl': userProfileImageUrl,
      'imageUrl': imageUrl,
      'caption': caption,
      'likes': likes,
    };
  }

  static Post toAppUser(DocumentSnapshot snap) {
    final map = snap.data()! as Map<String, dynamic>;
    return Post(
        map['id'],
        map['userId'],
        map['userName'],
        map['userProfileImageUrl'],
        map['imageUrl'],
        map['caption'],
        map['likes']);
  }
}
