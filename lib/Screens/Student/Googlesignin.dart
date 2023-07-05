import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;

      final String? displayName = googleUser.displayName;
      final String? email = googleUser.email;
      final String? photoUrl = googleUser.photoUrl;

      // Handle the user's information as needed, e.g., store in database, navigate to a new screen, etc.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in with Google!'),
        ),
      );
      print('Signed in with Google!');
      print('Display Name: $displayName');
      print('Email: $email');
      print('Photo URL: $photoUrl');
    } else {
      // Sign-in canceled by the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google sign-in canceled.'),
        ),
      );
      print('Google sign-in canceled.');
    }
  } catch (error) {
    // Error occurred during the sign-in process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error signing in with Google: $error'),
      ),
    );
    print('Error signing in with Google: $error');
  }
}
