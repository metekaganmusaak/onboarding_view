/// High-level visual presets. Each maps to a fully-formed `OnboardingTheme`
/// via `OnboardingTheme.fromStyle`, which you can then `copyWith` to tweak.
enum OnboardingStyle {
  /// Frosted translucent cards over a vivid gradient.
  glassmorphism,

  /// Apple-inspired "liquid glass": heavy blur, bright sheen, springy motion.
  liquidGlass,

  /// Clean, flat, typography-first. No shadows or blur.
  minimal,

  /// Material 3 — filled buttons, tonal surfaces, classic expanding dots.
  material,

  /// Adapts layout, sizing and interaction to the host platform
  /// (mobile vs desktop / web: wider content, hover, keyboard navigation).
  adaptive,
}

/// How page content is framed. Derived from [OnboardingStyle] but exposed so
/// custom themes can opt into the glass surface independently.
enum OnboardingSurfaceStyle {
  /// Content sits directly on the background.
  flat,

  /// Content is wrapped in a frosted [GlassContainer].
  glass,

  /// Content is wrapped in a heavier, glossier liquid-glass surface.
  liquidGlass,
}
