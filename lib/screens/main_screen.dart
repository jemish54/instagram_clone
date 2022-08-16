import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/empty_screen.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/other_profile_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final screenList = const [
    HomeScreen(),
    OtherProfileScreen(),
    AddPostScreen(),
    EmptyScreen(index: 3),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(10.0),
        child: Neumorphic(
          style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(18)),
              color: Colors.white,
              depth: 8,
              shape: NeumorphicShape.concave,
              surfaceIntensity: 0),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: navItem(Icons.home_rounded, _currentIndex == 0),
              ),
              BottomNavigationBarItem(
                label: 'Search',
                icon: navItem(Icons.search_rounded, _currentIndex == 1),
              ),
              BottomNavigationBarItem(
                label: 'Add Post',
                icon: navItem(Icons.add_circle_rounded, _currentIndex == 2),
              ),
              BottomNavigationBarItem(
                label: 'Activity',
                icon: navItem(Icons.notifications, _currentIndex == 3),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: navItem(Icons.person, _currentIndex == 4),
              ),
            ],
          ),
        ),
      ),
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: screenList),
    );
  }

  Widget navItem(IconData icon, bool isSelected) {
    return Neumorphic(
      style: NeumorphicStyle(
          depth: isSelected ? 6 : 0,
          color: isSelected ? Colors.blue : Colors.transparent,
          shape: isSelected ? NeumorphicShape.convex : NeumorphicShape.flat,
          boxShape: const NeumorphicBoxShape.circle()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
