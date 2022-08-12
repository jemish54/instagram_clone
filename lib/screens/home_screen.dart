import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:instagram_clone/domain/database_service.dart';
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
              height: 96,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    return ProfileStory(
                      isViewed: index.isEven,
                    );
                  })),
            ),
            StreamBuilder<List<Post>>(
              stream: DatabaseService().getUserPosts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        return PostItem(
                          post: snapshot.data![index],
                        );
                      }));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: SizedBox(
        width: 56,
        height: 56,
        child: Neumorphic(
            style: NeumorphicStyle(
                depth: 8,
                border: isViewed
                    ? NeumorphicBorder(color: Colors.grey[400], width: 2)
                    : const NeumorphicBorder(color: Colors.blue, width: 3),
                color: Colors.white,
                surfaceIntensity: 0,
                shadowLightColor: Colors.white,
                shape: NeumorphicShape.convex,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(16))),
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
      child: Neumorphic(
        style: NeumorphicStyle(
            depth: 8,
            color: Colors.white,
            surfaceIntensity: 0,
            shadowLightColor: Colors.white,
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: const CircleAvatar(
                  radius: 26,
                  foregroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60')),
              title: const Text('Jemish Mavani'),
              subtitle: const Text('@jamespatel54'),
              trailing: IconButton(
                onPressed: () {
                  DatabaseService().deletePost(post.id, post.postImageUrl);
                },
                icon: const Icon(Icons.delete_forever_rounded),
              ),
              contentPadding: const EdgeInsets.only(top: 8, left: 20),
            ),
            post.postImageUrl != null
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(post.postImageUrl!)),
                  )
                : const SizedBox(),
            post.postCaption.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 8),
                    child: Text(post.postCaption),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.blue.withAlpha(18),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.favorite_rounded,
                      color: Colors.blue,
                    ),
                    Icon(
                      Icons.chat_bubble_rounded,
                      color: Colors.blue,
                    ),
                    Icon(
                      Icons.send_rounded,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Icon(
                      Icons.bookmark_outline_rounded,
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
