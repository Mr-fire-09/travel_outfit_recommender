// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_outfit_recommender/screen/welcome_screen.dart';

void main() {
  testWidgets('Welcome screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify that the welcome text is present
    expect(find.text('Welcome to Your\nSmart Wardrobe!'), findsOneWidget);

    // Verify that the "Created by Neeraj" text is present
    expect(find.text('Created by Neeraj'), findsOneWidget);

    // Verify that the Create button is present
    expect(find.text('Create'), findsOneWidget);

    // Test navigation to outfit form page
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    // Verify that we're on the outfit form page
    expect(find.text('Outfit Recommender'), findsOneWidget);
  });

  testWidgets('Outfit form test', (WidgetTester tester) async {
    // Build the form page directly
    await tester.pumpWidget(const MaterialApp(home: OutfitFormPage()));

    // Verify that form elements are present
    expect(find.byIcon(Icons.place), findsOneWidget);
    expect(find.text('Summer'), findsOneWidget);
    expect(find.text('Beach'), findsOneWidget);
    expect(find.text('Vacation'), findsOneWidget);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(), // Your welcome page widget
    );
  }
}

class WelcomePage {}
