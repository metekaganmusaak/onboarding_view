import 'package:flutter/material.dart';

/// A responsive phone frame that scales to fit its space while keeping a fixed
/// logical device size, so embedded content (like [OnboardingView]) always uses
/// the mobile layout regardless of the browser window size.
class PhoneMockup extends StatelessWidget {
  const PhoneMockup({
    super.key,
    required this.child,
    this.width = 360,
    this.height = 760,
  });

  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(48),
            border: Border.all(color: const Color(0xFF2A2A2A), width: 10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 60,
                spreadRadius: 4,
                offset: const Offset(0, 24),
              ),
            ],
          ),
          child: Stack(
            children: [
              // The actual screen content, clipped to the rounded display.
              ClipRRect(
                borderRadius: BorderRadius.circular(38),
                child: MediaQuery(
                  // Give the embedded app a phone-like MediaQuery.
                  data: MediaQueryData(
                    size: Size(width, height),
                    devicePixelRatio: 1,
                    padding: const EdgeInsets.only(top: 44, bottom: 20),
                  ),
                  child: child,
                ),
              ),
              // Dynamic-island style pill.
              Positioned(
                top: 14,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 110,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
