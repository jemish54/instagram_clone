import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:instagram_clone/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _currentIndex = index;
        },
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        items: const [],
      ),
      body: const HomeScreen(),
    );
  }

  Widget navItem(IconData iconData, bool isSelected) {
    return Container();
  }
}
