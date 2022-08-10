import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 96,
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) {
                  return const ProfileStory(
                    isViewed: false,
                  );
                })),
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: ((context, index) => const PostItem())),
          )
        ],
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
                    : const NeumorphicBorder(color: Colors.blue, width: 2),
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
  const PostItem({Key? key}) : super(key: key);

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
            const ListTile(
              leading: CircleAvatar(
                  radius: 26,
                  foregroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60')),
              title: Text('Jemish Mavani'),
              subtitle: Text('@jamespatel54'),
              contentPadding: EdgeInsets.only(top: 8, left: 20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                    'https://images.unsplash.com/photo-1619360142632-031d811d1678?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDQ3fDZzTVZqVExTa2VRfHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
                    fit: BoxFit.fitWidth),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
              child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse convallis dolor volutpat consectetur vulputate. Nulla luctus placerat purus vitae ultrices."),
            ),
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
