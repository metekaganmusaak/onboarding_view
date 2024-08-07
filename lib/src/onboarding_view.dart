import 'package:flutter/material.dart';
import 'package:onboarding/src/onboarding.dart';

/// This widget is base widget for all onboarding screens. Create your
/// StatelessWidget and return this widget in the build method.
class OnboardingView extends StatefulWidget {
  const OnboardingView({
    super.key,
    required this.onboardings,
    this.padding = const EdgeInsets.all(16),
    required this.nextText,
    required this.finishText,
    required this.backText,
    required this.onFinish,
    this.showSkipButton = true,
    this.skipText = 'Skip',
    this.onSkip,
    this.pageAnimationDuration = kThemeAnimationDuration,
    this.pageAnimation = Curves.easeInOut,
  });

  /// List of Onboarding screens.
  final List<Onboarding> onboardings;

  /// Padding for the onboarding screen content.
  /// Default [EdgeInsets.all(16)]
  final EdgeInsets padding;

  /// Top right corner skip button will be displayed if this is true.
  /// Default [true]
  final bool showSkipButton;

  /// Define the text for the skip button.
  /// Default ['Skip']
  final String skipText;

  /// Define the text for the next button.
  final String nextText;

  /// Define the text for the finish button.
  final String finishText;

  /// Define the text for the back button.
  final String backText;

  /// Define the page animation duration.
  /// Default [kThemeAnimationDuration]
  final Duration pageAnimationDuration;
  // Define the page animation curve.
  /// Default [Curves.easeInOut]
  final Curve pageAnimation;

  /// You can use this callback to skip the onboarding.
  /// If you don't provide this callback, skip button will navigate to
  /// last onboarding screen that you defined.
  final VoidCallback? onSkip;

  /// You can use this callback to do something when the onboarding is finished.
  /// This is used for mostly navigating to the Sign In or Sign Up screen or Home screen.
  /// As this is a onboarding screen, please be sure to store isOnboardingSeen data to
  /// somewhere like shared preferences, database to prevent showing this screen every time.
  final VoidCallback onFinish;

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late PageController _pageController;

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    currentIndex = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          if (widget.showSkipButton)
            TextButton(
              onPressed: currentIndex == widget.onboardings.length - 1 ||
                      widget.onboardings.isEmpty
                  ? null
                  : widget.onSkip ??
                      () {
                        _pageController.animateToPage(
                          duration: widget.pageAnimationDuration,
                          curve: widget.pageAnimation,
                          widget.onboardings.length - 1,
                        );
                        setState(() {
                          currentIndex = widget.onboardings.length - 1;
                        });
                      },
              child: Text(widget.skipText),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: currentIndex == 0
                    ? null
                    : () {
                        _pageController.previousPage(
                          duration: widget.pageAnimationDuration,
                          curve: widget.pageAnimation,
                        );
                        setState(() {
                          currentIndex--;
                        });
                      },
                icon: const Icon(Icons.arrow_back),
                label: Text(widget.backText),
              ),
              const Spacer(),
              Row(
                children: [
                  for (int i = 0; i < widget.onboardings.length; i++)
                    AnimatedContainer(
                      duration: widget.pageAnimationDuration,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: currentIndex == i ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == currentIndex
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                ],
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: widget.onboardings.isEmpty
                    ? null
                    : () {
                        if (currentIndex == widget.onboardings.length - 1) {
                          widget.onFinish();
                        } else {
                          _pageController.nextPage(
                            duration: widget.pageAnimationDuration,
                            curve: widget.pageAnimation,
                          );
                          setState(() {
                            currentIndex++;
                          });
                        }
                      },
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                  currentIndex == widget.onboardings.length - 1
                      ? widget.finishText
                      : widget.nextText,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: widget.padding,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.onboardings.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) => widget.onboardings[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
