import 'package:flutter/material.dart';
import 'package:senior/Screens/QR.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:senior/Screens/sign_up.dart';
import '../Widget/Button.dart';
import '../widget/snackbar.dart';
import '../Widget/text_field.dart';
import '../services/authentication.dart';
import '../widget/forgot_pass.dart';

class SignInScreen extends StatefulWidget {
  final String? successMessage;
  const SignInScreen({super.key, this.successMessage});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    loadUserCredentials();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final msg = widget.successMessage;
      if (msg != null && msg.isNotEmpty) {
        showAppSnackBar(context, msg, type: SnackType.success);
      }
    });
  }

  Future<void> loadUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = (prefs.getString('email') ?? '').trim();
    passwordController.text = (prefs.getString('password') ?? '').trim();
    isChecked = prefs.getBool('rememberMe') ?? false;
    if (mounted) setState(() {});
  }

  Future<void> saveUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isChecked) {
      await prefs.setString('email', emailController.text.trim());
      await prefs.setString('password', passwordController.text.trim());
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  void SignInUser() async {
    setState(() => isLoading = true);

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => isLoading = false);
      showAppSnackBar(
        context,
        "Please enter email and password",
        type: SnackType.warning,
      );
      return;
    }

    final String res = await AuthMethod().SignInUser(
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (res == "success") {
      await saveUserCredentials();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('needsQR', true);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const QRPage(
            isFirstAfterLogin: true,
            successMessage: "Signed in successfully ✅",
          ),
        ),
            (route) => false,
      );
    } else {
      setState(() => isLoading = false);

      final lower = res.toLowerCase();
      final SnackType t =
      lower.contains("please enter") ? SnackType.warning : SnackType.error;

      showAppSnackBar(context, res, type: t);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final isTablet = w >= 700;
    final bg = const Color.fromARGB(255, 247, 206, 77);

    final padH = (w * 0.07).clamp(16.0, 40.0);
    final padVTop = (h * 0.08).clamp(24.0, 60.0);

    final cardRadius = (isTablet ? 50.0 : 40.0);
    final titleSize = (isTablet ? w * 0.04 : w * 0.08).clamp(22.0, 34.0);
    final subSize = (isTablet ? w * 0.022 : w * 0.045).clamp(14.0, 18.0);

    final gap = (h * 0.02).clamp(12.0, 20.0);
    final imgH = (isTablet ? h * 0.30 : h * 0.27).clamp(160.0, 260.0);

    final bottomTextSize = (isTablet ? w * 0.02 : w * 0.035).clamp(12.0, 16.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                      padding: EdgeInsets.fromLTRB(
                        padH,
                        padVTop,
                        padH,
                        (h * 0.04).clamp(18.0, 36.0),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(cardRadius),
                          bottomRight: Radius.circular(cardRadius),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: (h * 0.008).clamp(6.0, 10.0)),
                          Text(
                            'Sign in to continue',
                            style: TextStyle(
                              fontSize: subSize,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: gap),
                          TextFieldInput(
                            textEditingController: emailController,
                            hintText: "Email",
                          ),
                          SizedBox(height: (h * 0.012).clamp(8.0, 14.0)),
                          TextFieldInput(
                            textEditingController: passwordController,
                            hintText: "Password",
                            isPass: true,
                          ),
                          SizedBox(height: gap),
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() => isChecked = value ?? false);
                                },
                              ),
                              Text(
                                'Remember Me',
                                style: TextStyle(fontSize: bottomTextSize),
                              ),
                              const Spacer(),
                              const ForgotPassword(),
                            ],
                          ),
                          SizedBox(height: (h * 0.015).clamp(10.0, 16.0)),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : MyButtons(onTap: SignInUser, text: "Sign in"),
                        ],
                      ),
                    ),
                    SizedBox(height: (h * 0.02).clamp(10.0, 18.0)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: (w * 0.04).clamp(12.0, 24.0)),
                      child: Image(
                        image: const AssetImage('assets/p2.png'),
                        height: imgH,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(bottom: (h * 0.03).clamp(12.0, 24.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(fontSize: bottomTextSize),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                              );
                            },
                            child: Text(
                              "Create Account",
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