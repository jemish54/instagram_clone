import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/domain/authentication.dart';
import 'package:instagram_clone/domain/database_service.dart';
import 'package:instagram_clone/model/app_user.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/screens/post_detail_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

class OtherProfileScreen extends StatelessWidget {
  final AppUser user;
  const OtherProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OtherProfileSection(user),
      ),
    );
  }
}

class OtherProfileSection extends ConsumerStatefulWidget {
  final AppUser user;
  const OtherProfileSection(this.user, {Key? key}) : super(key: key);

  @override
  ConsumerState<OtherProfileSection> createState() =>
      _OtherProfileSectionState();
}

class _OtherProfileSectionState extends ConsumerState<OtherProfileSection> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          children: [
            const SizedBox(
              height: 230,
              width: double.infinity,
            ),
            Positioned(
                child: Image.network(
              widget.user.coverImageUrl ??
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
                    border: NeumorphicBorder(color: Colors.white, width: 2),
                    boxShape: NeumorphicBoxShape.circle(),
                    shape: NeumorphicShape.convex,
                  ),
                  child: Image.network(
                    widget.user.profileImageUrl ??
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
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.blue,
                        elevation: 4.0,
                        shape: const StadiumBorder(),
                        child: const Text(
                          'Message',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      StreamBuilder<bool>(
                          stream: ref
                              .read(authServiceProvider)
                              .currentAppUser()
                              .map((event) =>
                                  event.following.contains(widget.user.uid)),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return MaterialButton(
                                onPressed: () async {
                                  await DatabaseService().followEvent(
                                      snapshot.data!, widget.user.uid);
                                },
                                color: snapshot.data!
                                    ? Colors.blueGrey
                                    : Colors.blue,
                                elevation: 4.0,
                                shape: const StadiumBorder(),
                                child: Text(
                                  snapshot.data! ? 'Following' : 'Follow',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                    ],
                  ),
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 12),
          child: Text(
            widget.user.username,
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            widget.user.bio,
            maxLines: 3,
          ),
        ),
        ConnectionsCard(
            followersCount: widget.user.followers.length,
            followingCount: widget.user.following.length),
        StreamBuilder<List<Post>>(
            stream: DatabaseService().getUserPosts(widget.user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Container();
                } else {
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
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })
      ],
    );
  }
}
