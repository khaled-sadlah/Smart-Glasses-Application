import 'package:flutter/material.dart';
import '../widget/navigation_bar.dart';
import '../widget/sign_out_option.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final isTablet = w >= 700;

    final appBarTitleSize = (isTablet ? w * 0.035 : w * 0.06).clamp(22.0, 34.0);
    final pagePadH = (w * 0.06).clamp(14.0, 40.0);
    final pagePadV = (h * 0.04).clamp(18.0, 60.0);

    final headerSize = (isTablet ? w * 0.045 : w * 0.085).clamp(26.0, 42.0);
    final bodySize = (isTablet ? w * 0.022 : w * 0.045).clamp(16.0, 24.0);

    final imageH = (isTablet ? h * 0.35 : h * 0.28).clamp(180.0, 320.0);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'About Us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: appBarTitleSize,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 247, 206, 77),
        actions: const [SignOutMenu()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.symmetric(horizontal: pagePadH, vertical: pagePadV),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image(
                  image: const AssetImage('assets/p4.jpeg'),
                  height: imageH,
                  width: isTablet ? w * 0.7 : double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: (h * 0.03).clamp(12.0, 24.0)),
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: headerSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: (h * 0.02).clamp(10.0, 18.0)),
              Text(
                'We are three computer engineering students who built these smart glasses with name BKM Glasses for blind people '
                'to help visually impaired students move around the university safely and independently.\n\n'
                'The glasses can guide you step by step, read signs and documents out loud, recognize people, '
                'and detect objects around you.\n\n'
                'They also let a personal assistant know your location and reserve a notification on emergency for extra safety.\n\n'
                'Our goal is to make campus life easier, more independent, and more social for everyone.\n\n'
                'Founders:\n'
                '  Basant Jaradat\n'
                '  Khalid Sadlah\n'
                '  Maria Ghanem\n',
                style: TextStyle(
                  fontSize: bodySize,
                  color: Colors.grey,
                  height: 1.4,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: (h * 0.11).clamp(70.0, 100.0),
        child: navigation_bar(currentIndex: 0),
      ),
    );
  }
}
