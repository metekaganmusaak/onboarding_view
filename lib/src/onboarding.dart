import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({
    super.key,
    required this.image,
    this.title,
    this.description,
    this.footer,
  });

  /// Should be any widget like icon, text, image etc.
  /// But most of the time it will be an image.
  /// This image will be displayed %70 of the screen.
  final Widget image;

  /// Title widget for the onboarding screen.
  final Widget? title;

  /// You can write extra information about the title or anything you want.
  final Widget? description;

  /// Footer widget for the onboarding screen.
  /// This widget will be displayed %5 of the screen.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 14,
          child: image,
        ),
        Expanded(
          flex: 5,
          child: Column(
            children: [
              title ?? const SizedBox(),
              description ?? const SizedBox(),
            ],
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 1,
          child: footer ?? const SizedBox(),
        ),
      ],
    );
  }
}
