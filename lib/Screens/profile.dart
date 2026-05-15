import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior/widget/display_faces.dart';
import 'package:senior/widget/navigation_bar.dart';
import '../widget/display_maps.dart';
import '../widget/sign_out_option.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = "";
  Widget selectedDisplay = const DisplayImages();
  bool isFacesSelected = true;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          userName =
              (userDoc.data() as Map<String, dynamic>?)?['name'] ?? 'User Name';
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final isTablet = w >= 700;

    final appBarTitleSize = (isTablet ? w * 0.035 : w * 0.06).clamp(22.0, 34.0);

    final headerHeight = (h * 0.20).clamp(130.0, 180.0);
    final avatarSize = (headerHeight * 0.62).clamp(70.0, 120.0);
    final nameSize = (isTablet ? w * 0.03 : w * 0.06).clamp(18.0, 30.0);

    final topBarWidth = (isTablet ? w * 0.55 : w * 0.88).clamp(280.0, 520.0);
    final topBarHeight = (h * 0.075).clamp(54.0, 72.0);

    final padSide = (w * 0.04).clamp(12.0, 22.0);
    final topBarTopPad = (h * 0.02).clamp(12.0, 24.0);

    final btnFont = (isTablet ? w * 0.02 : w * 0.045).clamp(16.0, 22.0);
    final btnHPad = (w * 0.05).clamp(14.0, 24.0);
    final btnVPad = (h * 0.012).clamp(8.0, 12.0);

    final displayTopPad =
        topBarTopPad + topBarHeight + (h * 0.02).clamp(14.0, 22.0);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 247, 206, 77),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: appBarTitleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [SignOutMenu()],
      ),
      body: Container(
        color: const Color.fromARGB(255, 247, 206, 77),
        child: Column(
          children: [
            SizedBox(
              height: headerHeight,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage('assets/p10.png'),
                    height: avatarSize,
                    width: avatarSize,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: (h * 0.01).clamp(6.0, 12.0)),
                  Text(
                    userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: nameSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: topBarTopPad),
                      child: Container(
                        width: topBarWidth,
                        height: topBarHeight,
                        padding: EdgeInsets.symmetric(horizontal: padSide),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(250, 226, 151, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedDisplay = const DisplayImages();
                                    isFacesSelected = true;
                                  });
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                      horizontal: btnHPad,
                                      vertical: btnVPad,
                                    ),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    isFacesSelected
                                        ? const Color.fromRGBO(252, 242, 211, 1)
                                        : const Color.fromRGBO(
                                            250, 226, 151, 1.0),
                                  ),
                                  elevation: MaterialStateProperty.all(0),
                                ),
                                child: Text(
                                  'Faces',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: btnFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: (w * 0.03).clamp(10.0, 18.0)),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedDisplay = const disMaps();
                                    isFacesSelected = false;
                                  });
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                      horizontal: btnHPad,
                                      vertical: btnVPad,
                                    ),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    !isFacesSelected
                                        ? const Color.fromRGBO(252, 242, 211, 1)
                                        : const Color.fromRGBO(
                                            250, 226, 151, 1.0),
                                  ),
                                  elevation: MaterialStateProperty.all(0),
                                ),
                                child: Text(
                                  'Maps',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: btnFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      padSide,
                      displayTopPad,
                      padSide,
                      (h * 0.02).clamp(12.0, 20.0),
                    ),
                    child: selectedDisplay,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: (h * 0.11).clamp(70.0, 100.0),
        child: navigation_bar(currentIndex: 2),
      ),
    );
  }
}
