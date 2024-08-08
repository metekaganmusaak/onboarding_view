<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Onboarding View

Clean and minimalistic Onboarding View widget for those seeking simplicity.

![onboarding_view](https://github.com/user-attachments/assets/bafebdf5-2a69-482a-8e29-4f231e5a41a9)

## Features
- Finish button callback
- Custom Skip Button action
- You can define animation duration and curve for page scrolling.

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  onboarding_view: ^0.0.1
```

Import these:

```dart
import 'package:onboarding_view/onboarding_view.dart';
import 'package:onboarding_view/onboarding.dart';
```

## Usage

First, create your Onboarding pages that you want to show.

```dart
final onboardings = [
    Onboarding(
      image: Icon(
        Icons.filter_1,
        size: MediaQuery.sizeOf(context).width * 0.7,
      ),
      title: Text(
        'First',
        style: Theme.of(context).textTheme.displayLarge,
        textAlign: TextAlign.center,
      ),
      description: Text(
        'This is some explanation about the first onboarding.',
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
      footer: Text(
        'This is the footer of the first onboarding.',
        style: Theme.of(context).textTheme.labelMedium,
        textAlign: TextAlign.center,
      ),
    ),
    Onboarding(
      image: Icon(
        Icons.filter_2,
        size: MediaQuery.sizeOf(context).width * 0.7,
      ),
      title: Text(
        'Second',
        style: Theme.of(context).textTheme.displayLarge,
        textAlign: TextAlign.center,
      ),
      description: Text(
        'This is some explanation about the second onboarding.',
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
      footer: Text(
        'This is the footer of the second onboarding.',
        style: Theme.of(context).textTheme.labelMedium,
        textAlign: TextAlign.center,
      ),
    ),
    Onboarding(
      image: Icon(
        Icons.filter_3,
        size: MediaQuery.sizeOf(context).width * 0.7,
      ),
      title: Text(
        'Third',
        style: Theme.of(context).textTheme.displayLarge,
        textAlign: TextAlign.center,
      ),
      description: Text(
        'This is some explanation about the third onboarding.',
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
      footer: Text(
        'This is the footer of the third onboarding.',
        style: Theme.of(context).textTheme.labelMedium,
        textAlign: TextAlign.center,
      ),
    ),
    Onboarding(
      image: Icon(
        Icons.filter_4,
        size: MediaQuery.sizeOf(context).width * 0.7,
      ),
      title: Text(
        'Fourth',
        style: Theme.of(context).textTheme.displayLarge,
        textAlign: TextAlign.center,
      ),
      description: Text(
        'This is some explanation about the fourth onboarding.',
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
      footer: Text(
        'This is the footer of the fourth onboarding.',
        style: Theme.of(context).textTheme.labelMedium,
        textAlign: TextAlign.center,
      ),
    ),
  ];
```

Than pass this list of onboardings to the Onboarding View.

```dart
 OnboardingView(
      pageAnimationDuration: const Duration(seconds: 1),
      pageAnimation: Curves.fastEaseInToSlowEaseOut,
      ///
      /// ! This callback is used for skipping all of the onboardings and
      /// ! navigating to the last screen of the onboarding. But you can customize it like below.
      ///
      // onSkip: () {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(
      //       builder: (context) => const MyHomeView(),
      //     ),
      //   );
      // },
      padding: const EdgeInsets.all(8),
      onboardings: onboardings
      skipText: 'Skip',
      nextText: 'Next',
      finishText: 'Finish',
      backText: 'Back',
      onFinish: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MyHomeView(),
          ),
        );
      },
      showSkipButton: true,
    );
```

That's it. You can see the full example below.
```dart
class MyOnboarding extends StatelessWidget {
  const MyOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingView(
      pageAnimationDuration: const Duration(seconds: 1),
      pageAnimation: Curves.fastEaseInToSlowEaseOut,

      ///
      /// ! This callback is used for skipping all of the onboardings and
      /// ! navigating to the last screen of the onboarding. But you can customize it like below.
      ///
      // onSkip: () {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(
      //       builder: (context) => const MyHomeView(),
      //     ),
      //   );
      // },

      padding: const EdgeInsets.all(8),
      onboardings: [
        Onboarding(
          image: Icon(
            Icons.filter_1,
            size: MediaQuery.sizeOf(context).width * 0.7,
          ),
          title: Text(
            'First',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          description: Text(
            'This is some explanation about the first onboarding.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          footer: Text(
            'This is the footer of the first onboarding.',
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Onboarding(
          image: Icon(
            Icons.filter_2,
            size: MediaQuery.sizeOf(context).width * 0.7,
          ),
          title: Text(
            'Second',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          description: Text(
            'This is some explanation about the second onboarding.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          footer: Text(
            'This is the footer of the second onboarding.',
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Onboarding(
          image: Icon(
            Icons.filter_3,
            size: MediaQuery.sizeOf(context).width * 0.7,
          ),
          title: Text(
            'Third',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          description: Text(
            'This is some explanation about the third onboarding.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          footer: Text(
            'This is the footer of the third onboarding.',
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Onboarding(
          image: Icon(
            Icons.filter_4,
            size: MediaQuery.sizeOf(context).width * 0.7,
          ),
          title: Text(
            'Fourth',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          description: Text(
            'This is some explanation about the fourth onboarding.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          footer: Text(
            'This is the footer of the fourth onboarding.',
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
      skipText: 'Skip',
      nextText: 'Next',
      finishText: 'Finish',
      backText: 'Back',
      onFinish: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MyHomeView(),
          ),
        );
      },
      showSkipButton: true,
    );
  }
}
```

Also you can check whole example code here:
https://github.com/metekaganmusaak/onboarding_view/blob/main/example/lib/main.dart


## Additional information

Package's repo: https://github.com/metekaganmusaak/onboarding_view
