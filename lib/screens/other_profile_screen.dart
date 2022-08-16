import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/domain/authentication.dart';
import 'package:instagram_clone/domain/database_service.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/screens/post_detail_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

class OtherProfileScreen extends StatelessWidget {
  const OtherProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: OtherProfileSection(),
      ),
    );
  }
}

class OtherProfileSection extends ConsumerStatefulWidget {
  const OtherProfileSection({Key? key}) : super(key: key);

  @override
  ConsumerState<OtherProfileSection> createState() =>
      _OtherProfileSectionState();
}

class _OtherProfileSectionState extends ConsumerState<OtherProfileSection> {
  bool isFollowing = false;

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
                      StatefulBuilder(builder: (context, setState) {
                        return MaterialButton(
                          onPressed: () {
                            setState(() {
                              isFollowing = !isFollowing;
                            });
                          },
                          color: isFollowing ? Colors.blueGrey : Colors.blue,
                          elevation: 4.0,
                          shape: const StadiumBorder(),
                          child: Text(
                            isFollowing ? 'Following' : 'Follow',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                    ],
                  ),
                )),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 12),
          child: Text(
            "Jemish Mavani",
            style: TextStyle(fontSize: 18),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 2),
          child: Text(
            "@jamespatel54",
            style: TextStyle(fontSize: 14),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            'hcabjsbkjxas xhzjcbzx kbzuxnmzx jzbxc,m suiac xsnmc scc h cnms ciusax cm,an xuiasxs,nm xhaxhasx xusxks',
            maxLines: 3,
          ),
        ),
        const ConnectionsCard(followersCount: 54, followingCount: 09),
        StreamBuilder<List<Post>>(
            stream: null,
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
                return const Center(child: Text('NOT IMPLEMENTED'));
              }
            })
      ],
    );
  }
}
