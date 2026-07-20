# Onboarding View

A modern, **highly customizable** onboarding package for Flutter.

Five ready-made looks — **glassmorphism**, **Apple liquid glass**, **minimal**,
**material** and **adaptive** — with rich page & indicator animations,
network / GIF / asset / icon / custom media, and **zero-dependency** local
persistence. Works on mobile, desktop and web.

## Features

- 🎨 **Five built-in styles** (`OnboardingStyle`) — or craft your own `OnboardingTheme`.
- 🖼️ **Any media** — `OnboardingMedia.network` (with loading/error states),
  `.gif`, `.asset`, `.icon`, `.custom`.
- 🌀 **Page transitions** — fade, scale, parallax, cube, depth. Driven by the live
  swipe position with a shared "connected gradient" background.
- ● **Animated indicators** — dots, expanding, worm, scale, line/progress (tappable).
- 🎛️ **Fully customizable** — builder hooks for skip/back/next/finish + the
  indicator, configurable labels, button variants, layout ratios, blur/opacity.
- 💾 **Local persistence, no dependencies** — a JSON file on device (web falls
  back to memory), with a runtime on/off toggle and callbacks for your own storage.
- ⌨️ **Desktop & web** — responsive wide layout and ← / → keyboard navigation.

## Install

```yaml
dependencies:
  onboarding_view: ^1.0.0
```

```dart
import 'package:onboarding_view/onboarding_view.dart';
```

## Quick start

```dart
OnboardingView(
  style: OnboardingStyle.glassmorphism,
  storageKey: 'seen_intro',            // remembers completion (JSON file)
  onFinish: () => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const HomeScreen()),
  ),
  pages: const [
    OnboardingPage(
      title: 'Welcome aboard',
      description: 'Everything you need, in one beautiful place.',
      media: OnboardingMedia.network('https://picsum.photos/600'),
    ),
    OnboardingPage(
      title: 'Any media you want',
      description: 'Images, GIFs, icons or custom widgets.',
      media: OnboardingMedia.gif('https://example.com/intro.gif'),
    ),
    OnboardingPage(
      title: 'You are all set',
      description: 'Tap get started to jump in.',
      media: OnboardingMedia.icon(Icons.rocket_launch),
    ),
  ],
);
```

### Show onboarding only once

```dart
final seen = await OnboardingView.hasCompleted('seen_intro');
runApp(MyApp(showOnboarding: !seen));
```

## Styles

| Style | Look |
| --- | --- |
| `glassmorphism` | Frosted translucent cards over a vivid gradient |
| `liquidGlass` | Apple-style heavy blur, sheen and springy motion |
| `minimal` | Flat, typography-first, line indicator |
| `material` | Material 3, filled buttons, expanding dots |
| `adaptive` | Responsive layout + keyboard nav for desktop/web |

Start from a preset and tweak anything:

```dart
final theme = OnboardingTheme.fromStyle(OnboardingStyle.material).copyWith(
  accentColor: Colors.teal,
  transition: OnboardingTransition.parallax,
  indicator: const IndicatorConfig(effect: IndicatorEffect.worm),
  buttons: const OnboardingButtonConfig(finishLabel: "Let's go"),
);

OnboardingView(theme: theme, onFinish: ..., pages: ...);
```

## Persistence

Persistence is dependency-free. By default state is written to a local JSON
file (`JsonFileOnboardingStorage`); on the web it transparently falls back to
`MemoryOnboardingStorage`.

```dart
final storage = OnboardingStorage.defaultStorage();

// Toggle writing at runtime (e.g. from a settings switch):
storage.persistenceEnabled = false;

OnboardingView(
  storage: storage,
  storageKey: 'seen_intro',
  onCompleted: (key) => debugPrint('completed: $key'), // bring-your-own hook
  onFinish: ...,
  pages: ...,
);
```

Provide your own backend (Hive, SQLite, a REST API…) by extending
`OnboardingStorage`.

## Customizing buttons & indicator

```dart
OnboardingView(
  nextBuilder: (context, controller) =>
      IconButton(icon: const Icon(Icons.chevron_right), onPressed: controller.next),
  indicatorBuilder: (context, controller) => MyCustomIndicator(controller),
  onFinish: ...,
  pages: ...,
);
```

## Example

The [`example/`](example/) app is a **style gallery**: tap a card to preview each
style, toggle persistence live, and reset saved state.

```bash
cd example
flutter run   # mobile, desktop or -d chrome for web
```

## License

MIT
