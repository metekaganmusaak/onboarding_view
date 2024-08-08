import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyOnboarding(),
    );
  }
}

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

class MyHomeView extends StatelessWidget {
  const MyHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
    );
  }
}
