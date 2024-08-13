import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/Home_screen%20.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Home() ,);
  }
}