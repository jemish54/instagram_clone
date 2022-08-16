import 'package:flutter/material.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/screens/home_screen.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text('Post Detail')),
        body: SafeArea(
            child: PostItem(
          post: post,
        )));
  }
}
