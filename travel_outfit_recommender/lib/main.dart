import 'package:flutter/material.dart';
import 'package:travel_outfit_recommender/screen/welcome_screen.dart';
import 'screens/welcome_screen.dart';

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
          title: const Text('Your Smart Wardrobe'),
          backgroundColor: Colors.teal,
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
