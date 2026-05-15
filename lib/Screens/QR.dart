import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:senior/Screens/HomeScreen.dart';
import 'package:senior/widget/snackbar.dart';

class QRPage extends StatefulWidget {
  final bool isFirstAfterLogin;
  final String? successMessage;

  const QRPage({
    super.key,
    this.isFirstAfterLogin = false,
    this.successMessage,
  });

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final msg = widget.successMessage;
      if (msg != null && msg.isNotEmpty) {
        showAppSnackBar(context, msg, type: SnackType.success);
      }
    });
  }

  Future<void> _goHome(BuildContext context) async {
    if (widget.isFirstAfterLogin) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('needsQR', false);

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final isTablet = w >= 700;
    final bg = const Color.fromARGB(255, 247, 206, 77);

    final titleSize = (isTablet ? w * 0.022 : w * 0.045).clamp(16.0, 22.0);
    final btnFont = (isTablet ? w * 0.02 : w * 0.045).clamp(16.0, 22.0);

    final qrSize =
        (size.shortestSide * (isTablet ? 0.45 : 0.7)).clamp(200.0, 360.0);

    final btnHPad = (w * 0.08).clamp(22.0, 40.0);
    final btnVPad = (h * 0.018).clamp(12.0, 18.0);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: bg,
        body: const Center(child: Text("Please sign in to view QR")),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: (w * 0.08).clamp(18.0, 40.0),
              vertical: (h * 0.04).clamp(16.0, 40.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImageView(
                  data: user.uid,
                  version: QrVersions.auto,
                  size: qrSize,
                  foregroundColor: Colors.black,
                  backgroundColor: bg,
                ),
                SizedBox(height: (h * 0.02).clamp(14.0, 22.0)),
                Text(
                  "Scan this QR to verify your identity",
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: (h * 0.03).clamp(18.0, 30.0)),
                ElevatedButton(
                  onPressed: () => _goHome(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: bg,
                    padding: EdgeInsets.symmetric(
                      horizontal: btnHPad,
                      vertical: btnVPad,
                    ),
                    textStyle: TextStyle(
                      fontSize: btnFont,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child:
                      Text(widget.isFirstAfterLogin ? 'Home' : 'Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
