import 'package:flutter/material.dart';

/// The visual animation style of the page indicator.
enum IndicatorEffect {
  /// Simple dots; the active dot is highlighted.
  dots,

  /// The active dot stretches into a pill.
  expanding,

  /// A single accent dot slides ("worms") between positions.
  worm,

  /// The active dot scales up, neighbours scale down.
  scale,

  /// A continuous progress bar instead of dots.
  line,
}

/// Fully describes how a [PageIndicator] looks and animates.
@immutable
class IndicatorConfig {
  const IndicatorConfig({
    this.effect = IndicatorEffect.expanding,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 8,
    this.expandedWidth = 24,
    this.spacing = 6,
    this.radius = 8,
  });

  final IndicatorEffect effect;

  /// Active/selected color. Falls back to the theme accent when null.
  final Color? activeColor;

  /// Inactive color. Falls back to a muted accent when null.
  final Color? inactiveColor;

  final double dotSize;

  /// Width of the active dot for [IndicatorEffect.expanding].
  final double expandedWidth;

  final double spacing;
  final double radius;

  IndicatorConfig copyWith({
    IndicatorEffect? effect,
    Color? activeColor,
    Color? inactiveColor,
    double? dotSize,
    double? expandedWidth,
    double? spacing,
    double? radius,
  }) {
    return IndicatorConfig(
      effect: effect ?? this.effect,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      dotSize: dotSize ?? this.dotSize,
      expandedWidth: expandedWidth ?? this.expandedWidth,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
    );
  }
}

/// Animated page indicator driven by a fractional [page] value so it stays in
/// sync with the live swipe position, not just settled indices.
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.count,
    required this.page,
    required this.config,
    required this.accent,
    this.onDotTapped,
  });

  final int count;

  /// Fractional page position (e.g. 1.4 while swiping).
  final double page;

  final IndicatorConfig config;

  /// Resolved accent color used when the config leaves colors null.
  final Color accent;

  final ValueChanged<int>? onDotTapped;

  @override
  Widget build(BuildContext context) {
    final active = config.activeColor ?? accent;
    final inactive = config.inactiveColor ?? accent.withValues(alpha: 0.28);

    if (config.effect == IndicatorEffect.line) {
      return _LineIndicator(
        count: count,
        page: page,
        active: active,
        inactive: inactive,
        config: config,
      );
    }

    return Semantics(
      label: 'Page ${page.round() + 1} of $count',
      child: SizedBox(
        height: config.dotSize * 2.4,
        child: CustomPaint(
          painter: _DotsPainter(
            count: count,
            page: page,
            active: active,
            inactive: inactive,
            config: config,
          ),
          child: onDotTapped == null
              ? null
              : _DotHitTargets(
                  count: count,
                  config: config,
                  onDotTapped: onDotTapped!,
                ),
        ),
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  _DotsPainter({
    required this.count,
    required this.page,
    required this.active,
    required this.inactive,
    required this.config,
  });

  final int count;
  final double page;
  final Color active;
  final Color inactive;
  final IndicatorConfig config;

  double _slotWidth(int i) {
    // Width contribution of dot i, factoring the expanding effect.
    if (config.effect == IndicatorEffect.expanding) {
      final t = (1 - (page - i).abs()).clamp(0.0, 1.0);
      return config.dotSize + (config.expandedWidth - config.dotSize) * t;
    }
    return config.dotSize;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Total width to center the row.
    double total = 0;
    for (var i = 0; i < count; i++) {
      total += _slotWidth(i);
      if (i != count - 1) total += config.spacing;
    }
    var x = (size.width - total) / 2;
    final cy = size.height / 2;

    for (var i = 0; i < count; i++) {
      final w = _slotWidth(i);
      final proximity = (1 - (page - i).abs()).clamp(0.0, 1.0);
      final color = Color.lerp(inactive, active, proximity)!;
      final paint = Paint()..color = color;

      var h = config.dotSize;
      if (config.effect == IndicatorEffect.scale) {
        h = config.dotSize * (1 + 0.6 * proximity);
      }

      final rect = Rect.fromCenter(
        center: Offset(x + w / 2, cy),
        width: config.effect == IndicatorEffect.scale ? h : w,
        height: config.effect == IndicatorEffect.scale ? h : config.dotSize,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(config.radius)),
        paint,
      );
      x += w + config.spacing;
    }

    // The "worm" accent dot slides continuously over the inactive dots.
    if (config.effect == IndicatorEffect.worm) {
      final slot = config.dotSize + config.spacing;
      final startX = (size.width - (slot * count - config.spacing)) / 2;
      final wormX = startX + page * slot;
      final rect = Rect.fromCenter(
        center: Offset(wormX + config.dotSize / 2, cy),
        width: config.dotSize * 1.6,
        height: config.dotSize,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(config.radius)),
        Paint()..color = active,
      );
    }
  }

  @override
  bool shouldRepaint(_DotsPainter old) =>
      old.page != page ||
      old.count != count ||
      old.active != active ||
      old.inactive != inactive;
}

class _DotHitTargets extends StatelessWidget {
  const _DotHitTargets({
    required this.count,
    required this.config,
    required this.onDotTapped,
  });

  final int count;
  final IndicatorConfig config;
  final ValueChanged<int> onDotTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onDotTapped(i),
            child: SizedBox(
              width: config.expandedWidth,
              height: config.dotSize * 2.4,
            ),
          ),
      ],
    );
  }
}

class _LineIndicator extends StatelessWidget {
  const _LineIndicator({
    required this.count,
    required this.page,
    required this.active,
    required this.inactive,
    required this.config,
  });

  final int count;
  final double page;
  final Color active;
  final Color inactive;
  final IndicatorConfig config;

  @override
  Widget build(BuildContext context) {
    final progress = count <= 1 ? 1.0 : (page / (count - 1)).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(0.0, 220.0);
        return Center(
          child: SizedBox(
            width: width,
            height: config.dotSize,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: inactive,
                    borderRadius: BorderRadius.circular(config.radius),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: active,
                      borderRadius: BorderRadius.circular(config.radius),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
