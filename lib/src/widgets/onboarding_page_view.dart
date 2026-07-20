import 'package:flutter/material.dart';

import '../models/onboarding_page.dart';
import '../theme/glass_decoration.dart';
import '../theme/onboarding_style.dart';
import '../theme/onboarding_theme.dart';

/// Renders a single [OnboardingPage] using the active [OnboardingTheme].
///
/// Honours per-page overrides (colors, custom widgets) and, for glass styles,
/// wraps the text block in a [GlassContainer].
class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    super.key,
    required this.page,
    required this.theme,
    required this.isWide,
  });

  final OnboardingPage page;
  final OnboardingTheme theme;

  /// True on desktop/web wide layouts — media and text sit side by side.
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    if (page.contentBuilder != null) {
      return page.contentBuilder!(context);
    }

    final foreground =
        page.foregroundColor ?? theme.foregroundColor ?? Colors.black;
    final accent = page.accentColor ?? theme.accentColor;

    final media = page.media == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(16),
            child: page.media!.build(context, defaultColor: accent),
          );

    final textBlock = _TextBlock(
      page: page,
      theme: theme,
      foreground: foreground,
    );

    final framedText = switch (theme.surfaceStyle) {
      OnboardingSurfaceStyle.flat => textBlock,
      OnboardingSurfaceStyle.glass => GlassContainer(
          blur: theme.glassBlur,
          opacity: theme.glassOpacity,
          child: textBlock,
        ),
      OnboardingSurfaceStyle.liquidGlass => GlassContainer(
          blur: theme.glassBlur,
          opacity: theme.glassOpacity,
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          addHighlight: true,
          child: textBlock,
        ),
    };

    final content = isWide
        ? Row(
            children: [
              Expanded(flex: theme.mediaFlex, child: media),
              Expanded(
                flex: theme.textFlex,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: framedText,
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: theme.mediaFlex, child: Center(child: media)),
              // Let the text block take the space it needs but never overflow on
              // short screens — it scrolls internally instead of clipping.
              Flexible(
                flex: theme.textFlex,
                child: SingleChildScrollView(
                  child: framedText,
                ),
              ),
            ],
          );

    return Padding(padding: theme.contentPadding, child: content);
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({
    required this.page,
    required this.theme,
    required this.foreground,
  });

  final OnboardingPage page;
  final OnboardingTheme theme;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final defaultTitle = theme.titleStyle ??
        Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: foreground, fontWeight: FontWeight.bold);
    final defaultDesc = theme.descriptionStyle ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: foreground.withValues(alpha: 0.7),
              height: 1.5,
            );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (page.titleWidget != null)
          page.titleWidget!
        else if (page.title != null)
          Text(page.title!, style: defaultTitle),
        if ((page.title != null || page.titleWidget != null) &&
            (page.description != null || page.descriptionWidget != null))
          const SizedBox(height: 12),
        if (page.descriptionWidget != null)
          page.descriptionWidget!
        else if (page.description != null)
          Text(page.description!, style: defaultDesc),
      ],
    );
  }
}
