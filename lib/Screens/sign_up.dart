import 'package:flutter/material.dart';
import 'package:senior/Screens/sign_in.dart';
import '../services/authentication.dart';
import '../Widget/Button.dart';
import '../widget/snackbar.dart';
import '../widget/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void signupUser() async {
    final res = await AuthMethod().signupUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      phone: phoneController.text,
    );

    if (!mounted) return;

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SignInScreen(
            successMessage: "Account created ✅ Please sign in",
          ),
        ),
      );
    } else {
      showAppSnackBar(context, res, type: SnackType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final isTablet = w >= 700;

    final topImageH = (isTablet ? h * 0.33 : h * 0.30).clamp(200.0, 320.0);
    final padH = (w * 0.07).clamp(16.0, 40.0);
    final padV = (h * 0.03).clamp(18.0, 30.0);

    final titleSize = (isTablet ? w * 0.04 : w * 0.08).clamp(22.0, 34.0);
    final linkSize = (isTablet ? w * 0.022 : w * 0.045).clamp(14.0, 18.0);

    final cardRadius = (isTablet ? 50.0 : 40.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: h,
        width: w,
        color: const Color.fromARGB(255, 247, 206, 77),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: topImageH,
                width: double.infinity,
                child: Image(
                  image: const AssetImage('assets/p1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: h - topImageH),
                padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(cardRadius),
                    topRight: Radius.circular(cardRadius),
                  ),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(blurRadius: 25, color: Colors.black26),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create new Account',
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: (h * 0.01).clamp(8.0, 14.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style:
                          TextStyle(fontSize: linkSize, color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                            );
                          },
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: linkSize,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: (h * 0.02).clamp(12.0, 18.0)),
                    TextFieldInput(
                      textEditingController: nameController,
                      hintText: "Name",
                    ),
                    SizedBox(height: (h * 0.012).clamp(8.0, 14.0)),
                    TextFieldInput(
                      textEditingController: emailController,
                      hintText: "Email",
                    ),
                    SizedBox(height: (h * 0.012).clamp(8.0, 14.0)),
                    TextFieldInput(
                      textEditingController: phoneController,
                      hintText: "Phone",
                    ),
                    SizedBox(height: (h * 0.012).clamp(8.0, 14.0)),
                    TextFieldInput(
                      textEditingController: passwordController,
                      hintText: "Password",
                      isPass: true,
                    ),
                    SizedBox(height: (h * 0.02).clamp(14.0, 22.0)),
                    MyButtons(onTap: signupUser, text: "Sign up"),
                    SizedBox(height: (h * 0.02).clamp(14.0, 22.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}