import 'package:flutter/material.dart';
import 'package:maj_project/Screens/RoleSelectionScreen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return RoleSelectionScreen();
  }
}
