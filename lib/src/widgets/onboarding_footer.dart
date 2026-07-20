import 'package:flutter/material.dart';

import '../controller/onboarding_controller.dart';
import '../indicators/onboarding_indicator.dart';
import '../theme/onboarding_theme.dart';
import 'onboarding_buttons.dart';

/// Signature for replacing a default navigation button.
typedef OnboardingButtonBuilder = Widget Function(
  BuildContext context,
  OnboardingController controller,
);

/// The bottom chrome: back button, page indicator and next/finish button.
class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.controller,
    required this.theme,
    required this.foreground,
    required this.accent,
    required this.onNext,
    required this.onBack,
    required this.onFinish,
    required this.showBack,
    this.backBuilder,
    this.nextBuilder,
    this.finishBuilder,
    this.indicatorBuilder,
  });

  final OnboardingController controller;
  final OnboardingTheme theme;
  final Color foreground;
  final Color accent;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onFinish;
  final bool showBack;
  final OnboardingButtonBuilder? backBuilder;
  final OnboardingButtonBuilder? nextBuilder;
  final OnboardingButtonBuilder? finishBuilder;
  final OnboardingButtonBuilder? indicatorBuilder;

  @override
  Widget build(BuildContext context) {
    final buttons = theme.buttons;
    final isLast = controller.isLast;

    final indicator = indicatorBuilder?.call(context, controller) ??
        PageIndicator(
          count: controller.pageCount,
          page: controller.page,
          config: theme.indicator,
          accent: accent,
          onDotTapped: controller.animateToPage,
        );

    final back = !showBack || controller.isFirst
        ? const SizedBox(width: 48)
        : backBuilder?.call(context, controller) ??
            OnboardingActionButton(
              label: buttons.backLabel,
              onPressed: onBack,
              config: buttons,
              accent: accent,
              foreground: foreground,
              icon: Icons.arrow_back,
              emphasized: false,
            );

    final Widget forward;
    if (isLast) {
      forward = finishBuilder?.call(context, controller) ??
          OnboardingActionButton(
            label: buttons.finishLabel,
            onPressed: onFinish,
            config: buttons,
            accent: accent,
            foreground: foreground,
            icon: Icons.check,
          );
    } else {
      forward = nextBuilder?.call(context, controller) ??
          OnboardingActionButton(
            label: buttons.nextLabel,
            onPressed: onNext,
            config: buttons,
            accent: accent,
            foreground: foreground,
            icon: Icons.arrow_forward,
          );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Row(
        children: [
          back,
          Expanded(child: Center(child: indicator)),
          forward,
        ],
      ),
    );
  }
}
