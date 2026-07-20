import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Animated transition applied to each page as it scrolls.
///
/// Every effect is driven by [delta] = `pageIndex - controller.page`, so pages
/// stay visually linked to one another instead of animating in isolation.
enum OnboardingTransition {
  /// Plain horizontal paging.
  none,

  /// Cross-fade between pages.
  fade,

  /// Incoming page scales up from slightly smaller.
  scale,

  /// Media/content drifts at a different rate than the swipe (depth of field).
  parallax,

  /// 3D cube rotation around the vertical axis.
  cube,

  /// Depth stack: outgoing page recedes and fades while the next rises.
  depth,
}

/// Wraps [child] with the given [transition], using the live [delta] between
/// this page's index and the current fractional scroll position.
Widget applyOnboardingTransition({
  required OnboardingTransition transition,
  required double delta,
  required Widget child,
}) {
  // Clamp so far-away pages don't compute absurd transforms.
  final d = delta.clamp(-1.5, 1.5);
  final ad = d.abs();

  switch (transition) {
    case OnboardingTransition.none:
      return child;

    case OnboardingTransition.fade:
      return Opacity(opacity: (1 - ad).clamp(0.0, 1.0), child: child);

    case OnboardingTransition.scale:
      final scale = (1 - ad * 0.25).clamp(0.75, 1.0);
      return Opacity(
        opacity: (1 - ad * 0.6).clamp(0.0, 1.0),
        child: Transform.scale(scale: scale, child: child),
      );

    case OnboardingTransition.parallax:
      // Content shifts opposite to the swipe at 40% rate for a layered feel.
      return LayoutBuilder(
        builder: (context, constraints) {
          final dx = -d * constraints.maxWidth * 0.4;
          return Opacity(
            opacity: (1 - ad * 0.4).clamp(0.0, 1.0),
            child: Transform.translate(offset: Offset(dx, 0), child: child),
          );
        },
      );

    case OnboardingTransition.cube:
      final rotation = d * (math.pi / 2.2);
      return Transform(
        alignment: d <= 0 ? Alignment.centerRight : Alignment.centerLeft,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..rotateY(rotation),
        child: child,
      );

    case OnboardingTransition.depth:
      if (d <= 0) {
        // Outgoing page recedes.
        final scale = (1 - ad * 0.2).clamp(0.8, 1.0);
        return Opacity(
          opacity: (1 - ad).clamp(0.0, 1.0),
          child: Transform.scale(scale: scale, child: child),
        );
      }
      // Incoming page slides up from below.
      return LayoutBuilder(
        builder: (context, constraints) {
          final dy = ad * constraints.maxHeight * 0.15;
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
      );
  }
}
