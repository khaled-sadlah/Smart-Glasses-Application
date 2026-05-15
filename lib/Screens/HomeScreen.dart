import 'package:flutter/material.dart';
import 'package:senior/Screens/QR.dart';
import 'package:senior/Screens/new_face.dart';
import 'package:senior/Screens/new_map.dart';
import 'package:senior/widget/navigation_bar.dart';
import '../widget/sign_out_option.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  Widget _actionCard({
    required BuildContext context,
    required VoidCallback onTap,
    required String title,
    required String asset,
  }) {
    final w = MediaQuery.of(context).size.width;
    final isTablet = w >= 700;

    final iconSize = (isTablet ? w * 0.14 : w * 0.22).clamp(70.0, 110.0);
    final fontSize = (isTablet ? w * 0.025 : w * 0.045).clamp(14.0, 20.0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: EdgeInsets.all((w * 0.03).clamp(10.0, 16.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(asset),
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
            SizedBox(height: (w * 0.02).clamp(8.0, 14.0)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final isTablet = w >= 700;

    final pad = (w * 0.05).clamp(14.0, 26.0);
    final titleSize = (isTablet ? w * 0.035 : w * 0.06).clamp(22.0, 34.0);

    final topCardRadius = 50.0;
    final topCardAspect = isTablet ? 1.6 : 1.05;
    final topTitle1 = (isTablet ? w * 0.03 : w * 0.06).clamp(18.0, 30.0);
    final topTitle2 = (isTablet ? w * 0.028 : w * 0.055).clamp(16.0, 28.0);
    final topIcon = (isTablet ? w * 0.20 : w * 0.28).clamp(90.0, 150.0);

    final crossAxis = isTablet ? 3 : 2;
    final spacing = (w * 0.04).clamp(10.0, 18.0);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleSize),
        ),
        backgroundColor: const Color.fromARGB(255, 247, 206, 77),
        actions: const [SignOutMenu()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(pad),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: topCardAspect,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(topCardRadius),
                  ),
                  padding: EdgeInsets.all((w * 0.04).clamp(12.0, 22.0)),
                  child: Center(
                    child: uid == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: const AssetImage('assets/p6.png'),
                                width: topIcon,
                                height: topIcon,
                              ),
                              SizedBox(height: (h * 0.02).clamp(10.0, 18.0)),
                              Text(
                                "Not logged in",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: topTitle1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('locations')
                                .doc(uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: const AssetImage('assets/p6.png'),
                                      width: topIcon,
                                      height: topIcon,
                                    ),
                                    SizedBox(
                                        height: (h * 0.02).clamp(10.0, 18.0)),
                                    Text(
                                      "Loading...",
                                      style: TextStyle(
                                        fontSize: topTitle1,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              if (snapshot.hasError) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: const AssetImage('assets/p6.png'),
                                      width: topIcon,
                                      height: topIcon,
                                    ),
                                    SizedBox(
                                        height: (h * 0.02).clamp(10.0, 18.0)),
                                    Text(
                                      "Error reading location",
                                      style: TextStyle(
                                        fontSize: topTitle2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                );
                              }

                              final data = snapshot.data?.data()
                                      as Map<String, dynamic>? ??
                                  {};
                              final placeName =
                                  (data['placeName'] ?? 'Unknown').toString();

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: const AssetImage('assets/p6.png'),
                                    width: topIcon,
                                    height: topIcon,
                                  ),
                                  SizedBox(
                                      height: (h * 0.02).clamp(10.0, 18.0)),
                                  Text(
                                    'Faculty of Engineering',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: topTitle1,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                      height: (h * 0.008).clamp(6.0, 10.0)),
                                  Text(
                                    placeName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: topTitle2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              GridView.count(
                crossAxisCount: crossAxis,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                childAspectRatio: isTablet ? 1.05 : 1.0,
                children: [
                  _actionCard(
                    context: context,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NewFace()),
                      );
                    },
                    title: "Add new\nface",
                    asset: 'assets/p5.png',
                  ),
                  _actionCard(
                    context: context,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NewMap()),
                      );
                    },
                    title: "Add new\nmap",
                    asset: 'assets/p7.png',
                  ),
                  _actionCard(
                    context: context,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) =>
                                const QRPage(isFirstAfterLogin: false)),
                      );
                    },
                    title: "Qr Code",
                    asset: 'assets/p11.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: (h * 0.11).clamp(70.0, 100.0),
        child: const navigation_bar(currentIndex: 1),
      ),
    );
  }
}
