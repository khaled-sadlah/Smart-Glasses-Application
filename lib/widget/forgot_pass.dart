import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widget/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final padH = (w * 0.04).clamp(8.0, 24.0);
    final fontSize = (w * 0.04).clamp(12.0, 16.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padH),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () => myDialogBox(context),
          child: Text(
            "Forgot Password?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void myDialogBox(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final dialogW = (w * 0.9).clamp(280.0, 520.0);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dialogW),
            child: Padding(
              padding: EdgeInsets.all((w * 0.05).clamp(14.0, 22.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Forgot Your Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: (h * 0.02).clamp(12.0, 20.0)),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter the Email",
                      hintText: "eg abc@gmail.com",
                    ),
                  ),
                  SizedBox(height: (h * 0.02).clamp(12.0, 20.0)),
                  SizedBox(
                    height: (h * 0.06).clamp(44.0, 56.0),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final email = emailController.text.trim();
                        if (email.isEmpty) {
                          showAppSnackBar(
                            dialogContext,
                            "Please enter your email",
                            type: SnackType.warning,
                          );
                          return;
                        }

                        try {
                          await auth.sendPasswordResetEmail(email: email);

                          if (!mounted) return;

                          showAppSnackBar(
                            context,
                            "Reset link sent ✅ Check your email",
                            type: SnackType.success,
                          );
                        } catch (e) {
                          if (!mounted) return;
                          showAppSnackBar(
                            context,
                            e.toString(),
                            type: SnackType.error,
                          );
                        }

                        Navigator.pop(dialogContext);
                        emailController.clear();
                      },
                      child: const Text(
                        "Send",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
