import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/domain/authentication.dart';
import 'package:instagram_clone/domain/database_service.dart';
import 'package:instagram_clone/model/app_user.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/post_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: MyProfileSection(),
      ),
    );
  }
}

class MyProfileSection extends ConsumerStatefulWidget {
  const MyProfileSection({Key? key}) : super(key: key);

  @override
  ConsumerState<MyProfileSection> createState() => _MyProfileSectionState();
}

class _MyProfileSectionState extends ConsumerState<MyProfileSection> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder<AppUser>(
          future: ref.watch(authServiceProvider).currentAppUser(),
          builder: (context, snapshot) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  const SizedBox(
                    height: 230,
                    width: double.infinity,
                  ),
                  Positioned(
                      child: Image.network(
                    'https://images.unsplash.com/photo-1519638399535-1b036603ac77?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YW5pbWV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                  )),
                  Positioned(
                      bottom: 0,
                      left: 30,
                      child: Neumorphic(
                        style: const NeumorphicStyle(
                          color: Colors.white,
                          depth: 8,
                          lightSource: LightSource.top,
                          border:
                              NeumorphicBorder(color: Colors.white, width: 2),
                          boxShape: NeumorphicBoxShape.circle(),
                          shape: NeumorphicShape.convex,
                        ),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            CustomElevatedButton(
                              iconData: Icons.edit_rounded,
                              onPressed: () {},
                            ),
                            CustomElevatedButton(
                              iconData: Icons.logout_rounded,
                              onPressed: () async {
                                await ref
                                    .read(authServiceProvider)
                                    .signOutUser();
                                if (mounted) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const LoginScreen()));
                                }
                              },
                            )
                          ],
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 12),
                child: Text(
                  snapshot.hasData ? snapshot.data!.username : 'Null',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 2),
                child: Text(
                  "@jamespatel54",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              snapshot.hasData
                  ? snapshot.data!.bio.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            snapshot.data!.bio,
                            maxLines: 3,
                          ),
                        )
                  : const SizedBox(),
              ConnectionsCard(
                followersCount:
                    snapshot.hasData ? snapshot.data!.followers.length : 0,
                followingCount:
                    snapshot.hasData ? snapshot.data!.following.length : 0,
              ),
            ],
          ),
        ),
        StreamBuilder<List<Post>>(
            stream: DatabaseService()
                .getUserPosts(ref.read(authServiceProvider).user!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.all(15),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return profilePostItem(snapshot.data![index], () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PostDetailScreen(post: snapshot.data![index]),
                          ),
                        );
                      });
                    }));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })
      ],
    );
  }
}

Widget profilePostItem(Post post, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Neumorphic(
      style: const NeumorphicStyle(
        color: Colors.white,
        surfaceIntensity: 0,
        depth: 4,
        shape: NeumorphicShape.convex,
      ),
      child: post.imageUrl != null
          ? Image.network(
              post.imageUrl!,
              fit: BoxFit.cover,
            )
          : Center(
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                post.caption,
                textAlign: TextAlign.center,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            )),
    ),
  );
}

class ConnectionsCard extends StatelessWidget {
  final int followingCount;
  final int followersCount;
  const ConnectionsCard(
      {Key? key, required this.followingCount, required this.followersCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Neumorphic(
        style: const NeumorphicStyle(
          color: Colors.white,
          surfaceIntensity: 0,
          depth: 4,
          shape: NeumorphicShape.convex,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$followersCount',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Followers',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$followingCount',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Following',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: NeumorphicButton(
        padding: const EdgeInsets.all(6),
        onPressed: onPressed,
        style: NeumorphicStyle(
            color: Colors.white,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
            shape: NeumorphicShape.convex),
        child: Icon(
          iconData,
          color: Colors.blue,
        ),
      ),
    );
  }
}
