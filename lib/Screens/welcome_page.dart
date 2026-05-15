import 'package:flutter/material.dart';
import 'package:senior/Screens/sign_in.dart';
import 'package:senior/Screens/sign_up.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final isTablet = w >= 700;
    final bg = const Color.fromARGB(255, 247, 206, 77);

    final topPadH = (w * 0.07).clamp(16.0, 40.0);
    final topPadV = (h * 0.08).clamp(24.0, 70.0);

    final bottomPadV = (h * 0.06).clamp(18.0, 60.0);

    final titleSize = (isTablet ? w * 0.04 : w * 0.08).clamp(22.0, 34.0);
    final btnFont = (isTablet ? w * 0.02 : w * 0.045).clamp(14.0, 18.0);
    final bottomTextSize = (isTablet ? w * 0.02 : w * 0.035).clamp(12.0, 16.0);

    final logoH = (isTablet ? h * 0.28 : h * 0.25).clamp(160.0, 280.0);

    final btnH = (h * 0.065).clamp(44.0, 56.0);

    return Scaffold(
      body: Container(
        height: h,
        width: w,
        color: bg,
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: h - MediaQuery.of(context).padding.top),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: topPadH,
                        vertical: topPadV,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Welcome To..',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: (h * 0.02).clamp(12.0, 20.0)),
                          Image(
                            image: const AssetImage('assets/p3.png'),
                            height: logoH,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: (h * 0.015).clamp(10.0, 16.0)),
                          Text(
                            'BKM Glasses!',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: (h * 0.025).clamp(14.0, 22.0)),
                          SizedBox(
                            height: btnH,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: bg,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                textStyle: TextStyle(
                                  fontSize: btnFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Get started'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: topPadH,
                        vertical: bottomPadV,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(fontSize: bottomTextSize),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: bottomTextSize,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}