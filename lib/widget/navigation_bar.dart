import 'package:flutter/material.dart';
import 'package:senior/Screens/HomeScreen.dart';
import 'package:senior/Screens/about_us.dart';
import '../Screens/profile.dart';

class navigation_bar extends StatelessWidget {
  final int currentIndex;

  const navigation_bar({
    super.key,
    this.currentIndex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final iconSize = (w * 0.08).clamp(24.0, 36.0);

    void onItemTapped(int index) {
      if (index == currentIndex) return;

      Widget page;
      switch (index) {
        case 0:
          page = const AboutUs();
          break;
        case 1:
          page = const HomePage();
          break;
        case 2:
          page = const Profile();
          break;
        default:
          return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemTapped,
      backgroundColor: const Color.fromRGBO(247, 206, 77, 1),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      iconSize: iconSize,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.info_rounded),
          label: 'About',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
