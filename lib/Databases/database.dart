import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:maj_project/Functions/authFunction.dart';

class DatabaseManager {
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.reference().child('users');

  final DatabaseReference _loggedUserRef =
      FirebaseDatabase.instance.reference().child('loggedUsers');

  Future<void> addUser(String email, String password) async {
    try {
      final indianTime = await getCurrentIndianTime();
      final signUpTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(indianTime);
      // store user info in database
      await _userRef.push().set({
        'email': email,
        'password': password,
        'signupTime': DateTime.now().toUtc().toString(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DateTime> getCurrentIndianTime() async {
    final indiaOffset = Duration(hours: 5, minutes: 30);
    final now = DateTime.now();
    final indianTime = now.add(indiaOffset);
    return indianTime;
  }

  Future<void> updateLoginTimeForUsers(String userId) async {
    try {
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users/$userId');
      DatabaseEvent event = await userRef.once();
      if (event.snapshot != null && event.snapshot.value != null) {
        DataSnapshot snapshot = event.snapshot;
        Map<dynamic, dynamic> userData =
            snapshot.value as Map<dynamic, dynamic>;
        //update user info in database
        DatabaseReference loginDetailsRef =
            FirebaseDatabase.instance.reference().child('logindetails/$userId');
        await loginDetailsRef.set({
          'email': email,
          'password': password,
          'loginTime': getCurrentIndianTime(),
        });
      } else {
        print('user not found');
      }
      // S
      //tore the updated user information in the 'loggedUsers' node
    } catch (e) {
      print("error updating user login details : $e");
    }
  }
}
