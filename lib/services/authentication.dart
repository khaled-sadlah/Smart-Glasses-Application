import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final e = email.trim();
      final p = password.trim();
      final n = name.trim();
      final ph = phone.trim();

      if (e.isEmpty || p.isEmpty || n.isEmpty || ph.isEmpty) {
        return "Please enter all the fields";
      }

      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: e,
        password: p,
      );

      await _firestore.collection("users").doc(cred.user!.uid).set({
        'name': n,
        'uid': cred.user!.uid,
        'email': e,
        'phone': ph,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return "success";
    } on FirebaseAuthException catch (err) {
      if (err.code == 'email-already-in-use') {
        return "This email is already registered";
      } else if (err.code == 'invalid-email') {
        return "Invalid email format";
      } else if (err.code == 'weak-password') {
        return "Password is too weak";
      }
      return err.message ?? err.code;
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> SignInUser({
    required String email,
    required String password,
  }) async {
    try {
      final e = email.trim();
      final p = password.trim();

      if (e.isEmpty || p.isEmpty) {
        return "Please enter email and password";
      }

      await _auth.signInWithEmailAndPassword(
        email: e,
        password: p,
      );

      return "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return "This email is not registered";
        case 'wrong-password':
          return "Wrong password";
        case 'invalid-email':
          return "Invalid email format";
        case 'user-disabled':
          return "This account has been disabled";
        case 'too-many-requests':
          return "Too many attempts. Try again later";
        case 'invalid-credential':
          return "Email or password is incorrect";
        default:
          return "Login failed. Please try again";
      }
    } catch (_) {
      return "Login failed. Please try again";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String? getUserId() {
    return _auth.currentUser?.uid;
  }
}
