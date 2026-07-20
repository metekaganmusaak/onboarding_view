import 'package:flutter/material.dart';
import 'package:onboarding_view/onboarding_view.dart';

import 'style_gallery.dart';

/// A single storage instance shared across the app so the persistence toggle
/// and completion state stay in sync between the panel and the live preview.
final OnboardingStorage appStorage = OnboardingStorage.defaultStorage();

void main() => runApp(const OnboardingDemoApp());

class OnboardingDemoApp extends StatelessWidget {
  const OnboardingDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'onboarding_view demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const StyleGalleryScreen(),
    );
  }
}
