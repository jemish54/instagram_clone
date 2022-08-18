import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/domain/authentication.dart';
import 'package:instagram_clone/domain/database_service.dart';
import 'package:instagram_clone/model/app_user.dart';
import 'package:instagram_clone/model/post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 115,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    return ProfileStory(
                      isViewed: index.isEven,
                    );
                  })),
            ),
            StreamBuilder<AppUser>(
              stream: AuthService().currentAppUser(),
              builder: (context, snapshot) => snapshot.hasData
                  ? StreamBuilder<List<Post>>(
                      stream: DatabaseService()
                          .getFeedPosts(snapshot.data!.following),
                      builder: (context, postList) {
                        if (postList.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: postList.data!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context, index) {
                                return PostItem(
                                  post: postList.data![index],
                                );
                              }));
                        } else {
                          return const Center(
                              child: Text(
                            'Implementation is not done yet',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ));
                        }
                      },
                    )
                  : Container(),
            )
          ],
        ),
      )),
    );
  }
}

class ProfileStory extends StatelessWidget {
  final bool isViewed;
  const ProfileStory({Key? key, required this.isViewed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 10),
        child: Column(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Neumorphic(
                  style: NeumorphicStyle(
                      depth: 8,
                      border: isViewed
                          ? NeumorphicBorder(color: Colors.grey[400], width: 2)
                          : const NeumorphicBorder(
                              color: Colors.blue, width: 3),
                      color: Colors.white,
                      surfaceIntensity: 0,
                      shadowLightColor: Colors.white,
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(16))),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
            ),
            const SizedBox(height: 8),
            const Text(
              'jemspatel540',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final Post post;
  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onDoubleTap: () {},
        child: Neumorphic(
          style: NeumorphicStyle(
              depth: 8,
              color: Colors.white,
              surfaceIntensity: 0,
              shadowLightColor: Colors.white,
              shape: NeumorphicShape.concave,
              boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(12))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<AppUser>(
                future: DatabaseService().getUserById(post.userId),
                builder: (context, postUser) => ListTile(
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundImage: postUser.hasData
                        ? postUser.data!.profileImageUrl != null
                            ? NetworkImage(postUser.data!.profileImageUrl!)
                            : null
                        : null,
                  ),
                  title: Text(
                      postUser.hasData ? postUser.data!.username : 'username'),
                  subtitle: const Text('@jamespatel54'),
                  trailing: IconButton(
                    onPressed: () {
                      DatabaseService().deletePost(post.id, post.imageUrl);
                    },
                    icon: const Icon(Icons.delete_forever_rounded),
                  ),
                  contentPadding: const EdgeInsets.only(top: 8, left: 20),
                ),
              ),
              post.imageUrl != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(post.imageUrl!)),
                    )
                  : const SizedBox(),
              post.caption.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 8),
                      child: Text(post.caption),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.blue.withAlpha(18),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  child: Consumer(
                    builder: (context, ref, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Builder(builder: (context) {
                              final String userUid =
                                  ref.read(authServiceProvider).user!.uid;
                              final isLiked = post.likes.contains(userUid);
                              return IconButton(
                                onPressed: () async {
                                  await DatabaseService()
                                      .likeEvent(isLiked, post.id, userUid);
                                },
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: Colors.blue,
                                ),
                              );
                            }),
                            Text('${post.likes.length}'),
                          ],
                        ),
                        const Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.blue,
                        ),
                        const Icon(
                          Icons.send_rounded,
                          color: Colors.blue,
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        const Icon(
                          Icons.bookmark_outline_rounded,
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
