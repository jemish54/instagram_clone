import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:instagram_clone/domain/database_service.dart';
import 'package:instagram_clone/model/post.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: ((context, snapshot) => const MyProfileSection())),
      ),
    );
  }
}

class MyProfileSection extends StatelessWidget {
  const MyProfileSection({Key? key}) : super(key: key);

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
                      CustomElevatedButton(
                        iconData: Icons.edit_rounded,
                        onPressed: () {},
                      ),
                      CustomElevatedButton(
                        iconData: Icons.settings,
                        onPressed: () {},
                      )
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
        const ConnectionsCard(),
        StreamBuilder<List<Post>>(
            stream: DatabaseService().getUserPosts(),
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
                      return profilePostItem(snapshot.data![index]);
                    }));
              } else {
                return const CircularProgressIndicator();
              }
            })
      ],
    );
  }
}

Widget profilePostItem(Post post) {
  return Neumorphic(
    style: const NeumorphicStyle(
      color: Colors.white,
      surfaceIntensity: 0,
      depth: 4,
      shape: NeumorphicShape.convex,
    ),
    child: post.postImageUrl != null
        ? Image.network(
            post.postImageUrl!,
            fit: BoxFit.cover,
          )
        : Center(
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              post.postCaption,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          )),
  );
}

class ConnectionsCard extends StatelessWidget {
  const ConnectionsCard({Key? key}) : super(key: key);

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
                children: const [
                  Text(
                    '54',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Followers',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Column(
                children: const [
                  Text(
                    '09',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  SizedBox(height: 4),
                  Text(
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
  final Function onPressed;

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
        onPressed: () {
          onPressed();
        },
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
