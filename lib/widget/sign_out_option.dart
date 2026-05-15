import 'package:flutter/material.dart';
import 'package:senior/services/authentication.dart';
import 'package:senior/Screens/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOutMenu extends StatelessWidget {
  const SignOutMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        if (value == 'signout') {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text("Sign Out"),
                content: const Text(
                  "Are you sure you want to sign out?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );

          if (confirm == true) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('needsQR', false);

            await AuthMethod().signOut();

            if (!context.mounted) return;

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
              (route) => false,
            );
          }
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem<String>(
          value: 'signout',
          child: Text('Sign Out'),
        ),
      ],
    );
  }
}
