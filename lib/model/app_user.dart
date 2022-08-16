import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String uid;
  String username;
  String bio;
  String? profileImageUrl;
  String? coverImageUrl;
  List following;
  List followers;

  AppUser(this.uid, this.username, this.bio, this.profileImageUrl,
      this.coverImageUrl, this.following, this.followers);

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'name': username,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'following': following,
      'followers': followers,
    };
  }

  static AppUser toAppUser(DocumentSnapshot snap) {
    final map = snap.data()! as Map<String, dynamic>;
    return AppUser(
      map['id'],
      map['name'],
      map['bio'],
      map['profileImageUrl'],
      map['coverImageUrl'],
      map['following'],
      map['followers'],
    );
  }
}
