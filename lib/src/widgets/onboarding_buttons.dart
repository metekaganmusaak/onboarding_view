import 'package:flutter/material.dart';

import '../theme/onboarding_theme.dart';

/// A navigation button rendered according to [OnboardingButtonConfig.variant].
///
/// Used for the back / next / finish actions. The skip action reuses the text
/// variant. All of these can be fully replaced via the builder hooks on
/// `OnboardingView` — this is only the default look.
class OnboardingActionButton extends StatelessWidget {
  const OnboardingActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.config,
    required this.accent,
    required this.foreground,
    this.icon,
    this.emphasized = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final OnboardingButtonConfig config;
  final Color accent;
  final Color foreground;
  final IconData? icon;

  /// Primary actions (next/finish) are emphasized; back is de-emphasized.
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(config.borderRadius),
    );
    final showIcon = config.showIcons && icon != null;
    final child = _content(showIcon);

    // De-emphasized (back) buttons always render as text for a clean hierarchy.
    final variant =
        emphasized ? config.variant : OnboardingButtonVariant.text;

    switch (variant) {
      case OnboardingButtonVariant.filled:
        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: config.backgroundColor ?? accent,
            foregroundColor: config.foregroundColor,
            padding: config.padding,
            shape: shape,
            textStyle: config.textStyle,
          ),
          child: child,
        );
      case OnboardingButtonVariant.tonal:
        return FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor:
                config.backgroundColor ?? accent.withValues(alpha: 0.18),
            foregroundColor: config.foregroundColor ?? foreground,
            padding: config.padding,
            shape: shape,
            textStyle: config.textStyle,
          ),
          child: child,
        );
      case OnboardingButtonVariant.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: config.foregroundColor ?? foreground,
            side: BorderSide(color: foreground.withValues(alpha: 0.6)),
            padding: config.padding,
            shape: shape,
            textStyle: config.textStyle,
          ),
          child: child,
        );
      case OnboardingButtonVariant.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: config.foregroundColor ??
                (emphasized ? accent : foreground.withValues(alpha: 0.7)),
            padding: config.padding,
            shape: shape,
            textStyle: config.textStyle,
          ),
          child: child,
        );
    }
  }

  Widget _content(bool showIcon) {
    if (!showIcon) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(width: 6),
        Icon(icon, size: 18),
      ],
    );
  }
}
