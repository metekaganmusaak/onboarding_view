import 'dart:ui';

import 'package:flutter/material.dart';

/// A reusable frosted-glass surface built on [BackdropFilter].
///
/// Powers the `glassmorphism` and `liquidGlass` styles but is public so you can
/// drop the same effect into custom pages. Pure `dart:ui` — no dependencies.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 18,
    this.opacity = 0.15,
    this.tint,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.borderColor,
    this.borderWidth = 1.2,
    this.padding = const EdgeInsets.all(20),
    this.addHighlight = true,
  });

  /// The content rendered on top of the glass.
  final Widget child;

  /// Gaussian blur sigma applied to whatever is behind the surface.
  final double blur;

  /// Opacity of the frosting fill (0 fully clear, 1 opaque).
  final double opacity;

  /// Fill/tint color; defaults to a theme-appropriate white or black.
  final Color? tint;

  final BorderRadius borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;

  /// When true, paints a soft top highlight for the Apple "liquid glass" sheen.
  final bool addHighlight;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = tint ?? (isDark ? Colors.white : Colors.white);
    final border = borderColor ??
        (isDark ? Colors.white : Colors.white).withValues(alpha: 0.35);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: border, width: borderWidth),
            gradient: addHighlight
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      base.withValues(alpha: opacity + 0.12),
                      base.withValues(alpha: opacity),
                      base.withValues(alpha: (opacity - 0.05).clamp(0.0, 1.0)),
                    ],
                  )
                : null,
            color: addHighlight ? null : base.withValues(alpha: opacity),
          ),
          child: child,
        ),
      ),
    );
  }
}
