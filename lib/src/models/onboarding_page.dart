import 'package:flutter/material.dart';

import 'onboarding_media.dart';

/// Immutable data description of a single onboarding page.
///
/// A page is *data*, not a widget — the rendering (layout, glass effect,
/// typography) is decided by the active `OnboardingTheme`. For full control
/// you can bypass all of that with [contentBuilder].
@immutable
class OnboardingPage {
  const OnboardingPage({
    this.title,
    this.description,
    this.media,
    this.titleWidget,
    this.descriptionWidget,
    this.backgroundColor,
    this.backgroundGradient,
    this.foregroundColor,
    this.accentColor,
    this.contentBuilder,
  });

  /// Plain-text title. Styled by the theme. Ignored if [titleWidget] is set.
  final String? title;

  /// Plain-text description/body. Styled by the theme. Ignored if
  /// [descriptionWidget] is set.
  final String? description;

  /// The hero media (image / gif / network / icon / custom widget).
  final OnboardingMedia? media;

  /// Fully custom title widget, overriding [title] + theme styling.
  final Widget? titleWidget;

  /// Fully custom description widget, overriding [description] + theme styling.
  final Widget? descriptionWidget;

  /// Solid page background. Blended across pages for a "connected" feel.
  final Color? backgroundColor;

  /// Gradient page background. Takes precedence over [backgroundColor].
  final Gradient? backgroundGradient;

  /// Overrides the theme's text/icon color for this page.
  final Color? foregroundColor;

  /// Per-page accent (indicator active color, glass tint, buttons) override.
  final Color? accentColor;

  /// Escape hatch: build the entire page yourself. When set, all of the
  /// fields above are ignored and the theme only provides chrome (footer).
  final WidgetBuilder? contentBuilder;

  OnboardingPage copyWith({
    String? title,
    String? description,
    OnboardingMedia? media,
    Widget? titleWidget,
    Widget? descriptionWidget,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? foregroundColor,
    Color? accentColor,
    WidgetBuilder? contentBuilder,
  }) {
    return OnboardingPage(
      title: title ?? this.title,
      description: description ?? this.description,
      media: media ?? this.media,
      titleWidget: titleWidget ?? this.titleWidget,
      descriptionWidget: descriptionWidget ?? this.descriptionWidget,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      accentColor: accentColor ?? this.accentColor,
      contentBuilder: contentBuilder ?? this.contentBuilder,
    );
  }
}
