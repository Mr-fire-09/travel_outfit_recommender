import 'package:flutter/material.dart';
import 'package:travel_outfit_recommender/screen/welcome_screen.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Smart Wardrobe',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Welcome to Your Smart Wardrobe',
                textStyle: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 1,
            displayFullTextOnTap: true,
          ),
        ),
        body: const WelcomeScreen(),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.teal,
          child: const Text(
            'Created by Neeraj',
            style: TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
