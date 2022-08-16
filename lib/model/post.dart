class Post {
  String id;
  String userId;
  String? imageUrl;
  String caption;
  List likes;
  Post(this.id, this.userId, this.imageUrl, this.caption, this.likes);
}
