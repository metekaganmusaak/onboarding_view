import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onboarding_view/onboarding_view.dart';

void main() {
  group('OnboardingController', () {
    test('reports first/last and progress correctly', () {
      final c = OnboardingController()..attachPageCount(3);
      addTearDown(c.dispose);

      expect(c.index, 0);
      expect(c.isFirst, isTrue);
      expect(c.isLast, isFalse);
      expect(c.progress, 0);

      c.onPageChanged(2);
      expect(c.isLast, isTrue);
      expect(c.progress, 1.0);
    });
  });

  group('MemoryOnboardingStorage', () {
    test('persists and resets completion', () async {
      final store = MemoryOnboardingStorage();
      expect(await store.isCompleted('k'), isFalse);

      await store.setCompleted('k');
      expect(await store.isCompleted('k'), isTrue);

      await store.reset('k');
      expect(await store.isCompleted('k'), isFalse);
    });

    test('honours the persistence toggle', () async {
      final store = MemoryOnboardingStorage()..persistenceEnabled = false;
      await store.setCompleted('k');
      expect(await store.isCompleted('k'), isFalse);

      store.enablePersistence();
      await store.setCompleted('k');
      expect(await store.isCompleted('k'), isTrue);
    });
  });

  group('OnboardingTheme.fromStyle', () {
    test('produces a glass surface for glassmorphism', () {
      final theme = OnboardingTheme.fromStyle(OnboardingStyle.glassmorphism);
      expect(theme.surfaceStyle, OnboardingSurfaceStyle.glass);
      expect(theme.connectedGradientColors, isNotNull);
    });
  });

  testWidgets('OnboardingView renders and advances to finish',
      (tester) async {
    var finished = false;
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingView(
          style: OnboardingStyle.material,
          onFinish: () => finished = true,
          pages: const [
            OnboardingPage(title: 'One', description: 'First page'),
            OnboardingPage(title: 'Two', description: 'Second page'),
          ],
        ),
      ),
    );

    expect(find.text('One'), findsOneWidget);

    // Advance to the last page.
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Two'), findsOneWidget);

    // Finish.
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(finished, isTrue);
  });
}
