import 'package:flutter/material.dart';
import 'package:onboarding_view/onboarding_view.dart';

import 'onboarding_data.dart';
import 'style_gallery.dart';

/// A single storage instance shared across the app so the persistence toggle
/// and the "already seen?" check stay in sync.
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
      home: const StyleGalleryScreen(),
    );
  }
}

/// Opens the onboarding flow for the chosen [style] and returns to the gallery
/// (or lands on a stub home screen) when finished.
void openOnboarding(BuildContext context, OnboardingStyle style) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => OnboardingView(
        style: style,
        storage: appStorage,
        storageKey: storageKeyFor(style),
        transition: transitionFor(style),
        pages: pagesFor(style),
        onFinish: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => HomeScreen(style: style)),
        ),
      ),
    ),
  );
}

/// Simple destination shown after onboarding completes.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.style});

  final OnboardingStyle style;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('You made it 🎉')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.rocket_launch, size: 72),
            const SizedBox(height: 16),
            Text(
              'Finished the ${style.name} onboarding.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                    builder: (_) => const StyleGalleryScreen()),
                (route) => false,
              ),
              child: const Text('Back to gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
