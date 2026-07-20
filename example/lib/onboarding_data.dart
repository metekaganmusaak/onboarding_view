import 'package:flutter/material.dart';
import 'package:onboarding_view/onboarding_view.dart';

/// Per-style storage keys so each demo remembers its own completion state.
String storageKeyFor(OnboardingStyle style) => 'seen_onboarding_${style.name}';

/// Showcases a different transition per style.
OnboardingTransition transitionFor(OnboardingStyle style) => switch (style) {
      OnboardingStyle.glassmorphism => OnboardingTransition.parallax,
      OnboardingStyle.liquidGlass => OnboardingTransition.depth,
      OnboardingStyle.minimal => OnboardingTransition.fade,
      OnboardingStyle.material => OnboardingTransition.scale,
      OnboardingStyle.adaptive => OnboardingTransition.cube,
    };

// A few stable network sources demonstrating remote images + GIFs.
const _img1 = 'https://picsum.photos/id/1005/600/600';
const _img2 = 'https://picsum.photos/id/1011/600/600';
const _img3 = 'https://picsum.photos/id/1025/600/600';
const _gif = 'https://media.giphy.com/media/3o7abKhOpu0NwenH3O/giphy.gif';

/// Builds four pages exercising every media type: network image, GIF, icon and
/// a fully custom widget.
List<OnboardingPage> pagesFor(OnboardingStyle style) {
  return [
    const OnboardingPage(
      title: 'Welcome aboard',
      description:
          'A modern onboarding that adapts to any style — glass, liquid, '
          'minimal or material.',
      media: OnboardingMedia.network(_img1),
    ),
    const OnboardingPage(
      title: 'Any media you want',
      description:
          'Network images, animated GIFs, asset art, icons or a custom widget '
          '— all first-class.',
      media: OnboardingMedia.gif(_gif),
    ),
    const OnboardingPage(
      title: 'Beautiful by default',
      description:
          'Rich indicator and page transitions keep every screen feeling '
          'connected as you swipe.',
      media: OnboardingMedia.network(_img2),
    ),
    OnboardingPage(
      title: 'Made for every platform',
      description:
          'Mobile, desktop and web — with keyboard navigation and responsive '
          'layouts out of the box.',
      accentColor: style == OnboardingStyle.material ? null : Colors.white,
      media: const OnboardingMedia.custom(_PulseBadge()),
    ),
    const OnboardingPage(
      title: 'You are all set',
      description: 'Tap get started to jump in.',
      media: OnboardingMedia.network(_img3),
    ),
  ];
}

/// A small animated custom-media widget to prove `OnboardingMedia.custom`.
class _PulseBadge extends StatefulWidget {
  const _PulseBadge();

  @override
  State<_PulseBadge> createState() => _PulseBadgeState();
}

class _PulseBadgeState extends State<_PulseBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: _c, curve: Curves.easeInOut),
      ),
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF6750A4)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6750A4).withValues(alpha: 0.5),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: const Icon(Icons.devices, size: 72, color: Colors.white),
      ),
    );
  }
}
