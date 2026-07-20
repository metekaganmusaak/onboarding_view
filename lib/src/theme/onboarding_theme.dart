import 'package:flutter/material.dart';

import '../indicators/onboarding_indicator.dart';
import '../transitions/page_transitions.dart';
import 'onboarding_style.dart';

/// Visual variant for the navigation buttons.
enum OnboardingButtonVariant { filled, tonal, outlined, text }

/// Styling + labels for the skip / back / next / finish buttons.
@immutable
class OnboardingButtonConfig {
  const OnboardingButtonConfig({
    this.variant = OnboardingButtonVariant.filled,
    this.borderRadius = 14,
    this.showIcons = true,
    this.nextLabel = 'Next',
    this.backLabel = 'Back',
    this.skipLabel = 'Skip',
    this.finishLabel = 'Get started',
    this.foregroundColor,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.textStyle,
  });

  final OnboardingButtonVariant variant;
  final double borderRadius;
  final bool showIcons;
  final String nextLabel;
  final String backLabel;
  final String skipLabel;
  final String finishLabel;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  OnboardingButtonConfig copyWith({
    OnboardingButtonVariant? variant,
    double? borderRadius,
    bool? showIcons,
    String? nextLabel,
    String? backLabel,
    String? skipLabel,
    String? finishLabel,
    Color? foregroundColor,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    return OnboardingButtonConfig(
      variant: variant ?? this.variant,
      borderRadius: borderRadius ?? this.borderRadius,
      showIcons: showIcons ?? this.showIcons,
      nextLabel: nextLabel ?? this.nextLabel,
      backLabel: backLabel ?? this.backLabel,
      skipLabel: skipLabel ?? this.skipLabel,
      finishLabel: finishLabel ?? this.finishLabel,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// Timing for page + indicator animations.
@immutable
class OnboardingAnimationConfig {
  const OnboardingAnimationConfig({
    this.pageDuration = const Duration(milliseconds: 450),
    this.pageCurve = Curves.easeInOutCubic,
    this.contentDuration = const Duration(milliseconds: 350),
    this.contentCurve = Curves.easeOut,
  });

  final Duration pageDuration;
  final Curve pageCurve;
  final Duration contentDuration;
  final Curve contentCurve;

  OnboardingAnimationConfig copyWith({
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? contentDuration,
    Curve? contentCurve,
  }) {
    return OnboardingAnimationConfig(
      pageDuration: pageDuration ?? this.pageDuration,
      pageCurve: pageCurve ?? this.pageCurve,
      contentDuration: contentDuration ?? this.contentDuration,
      contentCurve: contentCurve ?? this.contentCurve,
    );
  }
}

/// The single source of truth for how an onboarding flow looks and animates.
///
/// Build one from a preset with [OnboardingTheme.fromStyle] and tailor it with
/// [copyWith], or construct entirely by hand for full control.
@immutable
class OnboardingTheme {
  const OnboardingTheme({
    this.style = OnboardingStyle.material,
    this.surfaceStyle = OnboardingSurfaceStyle.flat,
    this.accentColor = const Color(0xFF6750A4),
    this.foregroundColor,
    this.backgroundColor,
    this.backgroundGradient,
    this.connectedGradientColors,
    this.titleStyle,
    this.descriptionStyle,
    this.indicator = const IndicatorConfig(),
    this.buttons = const OnboardingButtonConfig(),
    this.animation = const OnboardingAnimationConfig(),
    this.transition = OnboardingTransition.fade,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 28),
    this.mediaFlex = 5,
    this.textFlex = 4,
    this.glassBlur = 18,
    this.glassOpacity = 0.15,
  });

  final OnboardingStyle style;
  final OnboardingSurfaceStyle surfaceStyle;
  final Color accentColor;

  /// Text/icon color. Defaults to a contrast color for the background.
  final Color? foregroundColor;

  /// Solid background. Ignored if [backgroundGradient] or
  /// [connectedGradientColors] is set.
  final Color? backgroundColor;

  /// A fixed gradient for the whole flow.
  final Gradient? backgroundGradient;

  /// One color per page; the live background lerps between them as the user
  /// swipes, so the pages feel like one connected surface.
  final List<Color>? connectedGradientColors;

  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final IndicatorConfig indicator;
  final OnboardingButtonConfig buttons;
  final OnboardingAnimationConfig animation;
  final OnboardingTransition transition;
  final EdgeInsetsGeometry contentPadding;

  /// Flex weight of the media area vs the [textFlex] text area.
  final int mediaFlex;
  final int textFlex;

  final double glassBlur;
  final double glassOpacity;

  OnboardingTheme copyWith({
    OnboardingStyle? style,
    OnboardingSurfaceStyle? surfaceStyle,
    Color? accentColor,
    Color? foregroundColor,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    List<Color>? connectedGradientColors,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    IndicatorConfig? indicator,
    OnboardingButtonConfig? buttons,
    OnboardingAnimationConfig? animation,
    OnboardingTransition? transition,
    EdgeInsetsGeometry? contentPadding,
    int? mediaFlex,
    int? textFlex,
    double? glassBlur,
    double? glassOpacity,
  }) {
    return OnboardingTheme(
      style: style ?? this.style,
      surfaceStyle: surfaceStyle ?? this.surfaceStyle,
      accentColor: accentColor ?? this.accentColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      connectedGradientColors:
          connectedGradientColors ?? this.connectedGradientColors,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      indicator: indicator ?? this.indicator,
      buttons: buttons ?? this.buttons,
      animation: animation ?? this.animation,
      transition: transition ?? this.transition,
      contentPadding: contentPadding ?? this.contentPadding,
      mediaFlex: mediaFlex ?? this.mediaFlex,
      textFlex: textFlex ?? this.textFlex,
      glassBlur: glassBlur ?? this.glassBlur,
      glassOpacity: glassOpacity ?? this.glassOpacity,
    );
  }

  /// Builds a ready-to-use theme for a high-level [style].
  ///
  /// [brightness] and [seedColor] let each preset adapt to light/dark and your
  /// brand color. Everything can be refined afterwards via [copyWith].
  factory OnboardingTheme.fromStyle(
    OnboardingStyle style, {
    Brightness brightness = Brightness.light,
    Color seedColor = const Color(0xFF6750A4),
  }) {
    final isDark = brightness == Brightness.dark;
    final onColor = isDark ? Colors.white : const Color(0xFF1A1A2E);

    switch (style) {
      case OnboardingStyle.glassmorphism:
        return OnboardingTheme(
          style: style,
          surfaceStyle: OnboardingSurfaceStyle.glass,
          accentColor: Colors.white,
          foregroundColor: Colors.white,
          connectedGradientColors: const [
            Color(0xFF6A11CB),
            Color(0xFF2575FC),
            Color(0xFFEC4899),
            Color(0xFF06B6D4),
          ],
          transition: OnboardingTransition.parallax,
          indicator: const IndicatorConfig(
            effect: IndicatorEffect.expanding,
            activeColor: Colors.white,
          ),
          buttons: const OnboardingButtonConfig(
            variant: OnboardingButtonVariant.outlined,
            borderRadius: 30,
            finishLabel: 'Get started',
          ),
          glassBlur: 20,
          glassOpacity: 0.16,
          titleStyle: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        );

      case OnboardingStyle.liquidGlass:
        return OnboardingTheme(
          style: style,
          surfaceStyle: OnboardingSurfaceStyle.liquidGlass,
          accentColor: const Color(0xFF0A84FF),
          foregroundColor: Colors.white,
          connectedGradientColors: const [
            Color(0xFF1D2B64),
            Color(0xFF3A1C71),
            Color(0xFF283593),
            Color(0xFF0F2027),
          ],
          transition: OnboardingTransition.depth,
          animation: const OnboardingAnimationConfig(
            pageDuration: Duration(milliseconds: 620),
            pageCurve: Curves.easeOutBack,
          ),
          indicator: const IndicatorConfig(
            effect: IndicatorEffect.worm,
            activeColor: Colors.white,
          ),
          buttons: const OnboardingButtonConfig(
            variant: OnboardingButtonVariant.tonal,
            borderRadius: 26,
          ),
          glassBlur: 32,
          glassOpacity: 0.12,
          titleStyle: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        );

      case OnboardingStyle.minimal:
        return OnboardingTheme(
          style: style,
          surfaceStyle: OnboardingSurfaceStyle.flat,
          accentColor: onColor,
          foregroundColor: onColor,
          backgroundColor: isDark ? const Color(0xFF0E0E10) : Colors.white,
          transition: OnboardingTransition.fade,
          indicator: IndicatorConfig(
            effect: IndicatorEffect.line,
            activeColor: onColor,
            inactiveColor: onColor.withValues(alpha: 0.15),
            dotSize: 3,
          ),
          buttons: const OnboardingButtonConfig(
            variant: OnboardingButtonVariant.text,
            showIcons: false,
          ),
          titleStyle: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
            color: onColor,
          ),
          descriptionStyle: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: onColor.withValues(alpha: 0.6),
          ),
        );

      case OnboardingStyle.material:
        final scheme = ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: brightness,
        );
        return OnboardingTheme(
          style: style,
          surfaceStyle: OnboardingSurfaceStyle.flat,
          accentColor: scheme.primary,
          foregroundColor: scheme.onSurface,
          backgroundColor: scheme.surface,
          transition: OnboardingTransition.scale,
          indicator: IndicatorConfig(
            effect: IndicatorEffect.expanding,
            activeColor: scheme.primary,
            inactiveColor: scheme.primary.withValues(alpha: 0.24),
          ),
          buttons: const OnboardingButtonConfig(
            variant: OnboardingButtonVariant.filled,
          ),
        );

      case OnboardingStyle.adaptive:
        final scheme = ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: brightness,
        );
        return OnboardingTheme(
          style: style,
          surfaceStyle: OnboardingSurfaceStyle.flat,
          accentColor: scheme.primary,
          foregroundColor: scheme.onSurface,
          backgroundColor: scheme.surface,
          transition: OnboardingTransition.parallax,
          indicator: IndicatorConfig(
            effect: IndicatorEffect.scale,
            activeColor: scheme.primary,
            inactiveColor: scheme.primary.withValues(alpha: 0.24),
          ),
          buttons: const OnboardingButtonConfig(
            variant: OnboardingButtonVariant.tonal,
          ),
        );
    }
  }
}
