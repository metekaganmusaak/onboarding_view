import 'package:flutter/material.dart';

/// A piece of visual content shown at the top of an onboarding page.
///
/// Supports every common source so a page can display an asset image, a
/// network image, an animated GIF (asset or network — Flutter's [Image]
/// decodes GIFs natively), a Material icon, or any custom widget.
///
/// ```dart
/// OnboardingMedia.network('https://picsum.photos/600');
/// OnboardingMedia.asset('assets/intro.png');
/// OnboardingMedia.gif('https://media.giphy.com/media/xyz/giphy.gif');
/// OnboardingMedia.icon(Icons.rocket_launch);
/// OnboardingMedia.custom(MyLottieView());
/// ```
@immutable
sealed class OnboardingMedia {
  const OnboardingMedia({this.fit = BoxFit.contain, this.size});

  /// How the media should be inscribed into its box. Ignored by
  /// [OnboardingIconMedia] and [OnboardingCustomMedia].
  final BoxFit fit;

  /// Optional fixed size. When null the media fills the available media area.
  final Size? size;

  /// Image from the app's asset bundle. Animated GIFs are supported.
  const factory OnboardingMedia.asset(
    String path, {
    BoxFit fit,
    Size? size,
    Color? color,
  }) = OnboardingAssetMedia;

  /// Image fetched from the network, with graceful loading + error states.
  /// Animated GIFs are supported.
  const factory OnboardingMedia.network(
    String url, {
    BoxFit fit,
    Size? size,
    Widget? placeholder,
    Widget? errorWidget,
  }) = OnboardingNetworkMedia;

  /// Convenience alias for [OnboardingMedia.network] to make GIF intent clear.
  const factory OnboardingMedia.gif(
    String url, {
    bool isAsset,
    BoxFit fit,
    Size? size,
    Widget? placeholder,
    Widget? errorWidget,
  }) = OnboardingGifMedia;

  /// A Material [IconData] rendered at [size] (defaults to a large glyph).
  const factory OnboardingMedia.icon(
    IconData icon, {
    double glyphSize,
    Color? color,
  }) = OnboardingIconMedia;

  /// Any custom widget (Lottie, Rive, video, illustration, …).
  const factory OnboardingMedia.custom(Widget child) = OnboardingCustomMedia;

  /// Builds the concrete widget for this media, tinted with [defaultColor]
  /// when the media itself does not specify one.
  Widget build(BuildContext context, {Color? defaultColor});
}

/// Asset-backed [OnboardingMedia].
class OnboardingAssetMedia extends OnboardingMedia {
  const OnboardingAssetMedia(
    this.path, {
    super.fit,
    super.size,
    this.color,
  });

  final String path;
  final Color? color;

  @override
  Widget build(BuildContext context, {Color? defaultColor}) {
    return Image.asset(
      path,
      fit: fit,
      width: size?.width,
      height: size?.height,
      color: color,
      gaplessPlayback: true,
    );
  }
}

/// Network-backed [OnboardingMedia] with loading + error handling.
class OnboardingNetworkMedia extends OnboardingMedia {
  const OnboardingNetworkMedia(
    this.url, {
    super.fit,
    super.size,
    this.placeholder,
    this.errorWidget,
  });

  final String url;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context, {Color? defaultColor}) {
    return Image.network(
      url,
      fit: fit,
      width: size?.width,
      height: size?.height,
      gaplessPlayback: true,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Center(
          child: placeholder ??
              CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
              ),
        );
      },
      errorBuilder: (context, error, stack) =>
          Center(child: errorWidget ?? const _MediaError()),
    );
  }
}

/// GIF [OnboardingMedia]; resolves to an asset or network image.
class OnboardingGifMedia extends OnboardingMedia {
  const OnboardingGifMedia(
    this.url, {
    this.isAsset = false,
    super.fit,
    super.size,
    this.placeholder,
    this.errorWidget,
  });

  final String url;
  final bool isAsset;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context, {Color? defaultColor}) {
    if (isAsset) {
      return OnboardingAssetMedia(url, fit: fit, size: size).build(context);
    }
    return OnboardingNetworkMedia(
      url,
      fit: fit,
      size: size,
      placeholder: placeholder,
      errorWidget: errorWidget,
    ).build(context);
  }
}

/// Icon-backed [OnboardingMedia].
class OnboardingIconMedia extends OnboardingMedia {
  const OnboardingIconMedia(
    this.icon, {
    this.glyphSize = 120,
    this.color,
  }) : super();

  final IconData icon;
  final double glyphSize;
  final Color? color;

  @override
  Widget build(BuildContext context, {Color? defaultColor}) {
    return Icon(
      icon,
      size: glyphSize,
      color: color ?? defaultColor ?? Theme.of(context).colorScheme.primary,
    );
  }
}

/// Custom-widget [OnboardingMedia].
class OnboardingCustomMedia extends OnboardingMedia {
  const OnboardingCustomMedia(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context, {Color? defaultColor}) => child;
}

class _MediaError extends StatelessWidget {
  const _MediaError();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withValues(alpha: .4);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.broken_image_outlined, size: 48, color: color),
        const SizedBox(height: 8),
        Text('Image unavailable', style: TextStyle(color: color)),
      ],
    );
  }
}
