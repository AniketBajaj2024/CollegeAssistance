import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maj_project/Colors.dart';
import 'package:maj_project/Databases/database.dart';
import 'package:maj_project/Screens/Timetablescreen.dart';

final DatabaseManager _databaseManager = DatabaseManager();

final email = TextEditingController();
final password = TextEditingController();
signup(String email, String password, BuildContext context) async {
  try {
    await _databaseManager.addUser(email, password);
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print("success");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TimeTableScree()));

    return userCredential.user;

    // store in database
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e.message.toString()),
      backgroundColor: primary.shade900,
    ));
    if (e.code == 'week-password') {
      print('The password provided is too week');
    } else if (e.code == 'email already in use ') {
      print('The account already exist');
    }
  } catch (e) {
    print(e);
  }
}

signin(String email, String password, BuildContext context) async {
  try {
    await _databaseManager.addUser(email, password);

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    // update database
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TimeTableScree()));
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e.message.toString()),
      backgroundColor: primary.shade900,
    ));
    if (e.code == 'user-not-found') {
      print('No user found for that email ');
    } else if (e.code == 'wrong-password') {
      print('Wrong password');
    }
  }
}
