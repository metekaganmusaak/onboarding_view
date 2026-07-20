# Onboarding View

A modern, **highly customizable** onboarding package for Flutter.

Five ready-made looks — **glassmorphism**, **Apple liquid glass**, **minimal**,
**material** and **adaptive** — with rich page & indicator animations,
network / GIF / asset / icon / custom media, and **zero-dependency** local
persistence. Runs on mobile, desktop and web.

## 🌐 Live demo

**Try every style right in your browser:**
👉 <https://torchingale.com/packages/onboarding-view/index.html>

Pick a style on the left and preview it live inside a phone mockup on the right.

---

## Contents

- [Features](#features)
- [Install](#install)
- [Quick start](#quick-start)
- [Show onboarding only once](#show-onboarding-only-once)
- [Styles](#styles)
- [Media types](#media-types)
- [Page transitions](#page-transitions)
- [Indicators](#indicators)
- [Theming](#theming)
- [Persistence](#persistence)
- [Custom buttons & builders](#custom-buttons--builders)
- [Controlling the flow](#controlling-the-flow)
- [Desktop & web](#desktop--web)
- [API overview](#api-overview)
- [Example app](#example-app)

## Features

- 🎨 **Five built-in styles** (`OnboardingStyle`) — or craft your own `OnboardingTheme`.
- 🖼️ **Any media** — `OnboardingMedia.network` (with loading/error states),
  `.gif`, `.asset`, `.icon`, `.custom`.
- 🌀 **Page transitions** — fade, scale, parallax, cube, depth. Driven by the live
  swipe position, with a shared "connected gradient" background so pages feel linked.
- ● **Animated indicators** — dots, expanding, worm, scale, line/progress (tappable).
- 🎛️ **Fully customizable** — builder hooks for skip/back/next/finish + the
  indicator, configurable labels, button variants, layout ratios, blur/opacity.
- 💾 **Local persistence, no dependencies** — a JSON file on device (web falls
  back to memory), with a runtime on/off toggle and callbacks for your own storage.
- ⌨️ **Desktop & web ready** — responsive wide layout and ← / → keyboard navigation.
- 📦 **Zero dependencies** — pure Flutter/Dart (`BackdropFilter`, `Image`, `dart:io`).

## Install

```yaml
dependencies:
  onboarding_view: ^1.0.1
```

```dart
import 'package:onboarding_view/onboarding_view.dart';
```

Requires Flutter `>=3.27.0` (uses `Color.withValues`).

## Quick start

The whole flow is two widgets: **`OnboardingView`** (the flow) and a list of
**`OnboardingPage`** (plain data — the theme handles the visuals).

```dart
OnboardingView(
  style: OnboardingStyle.glassmorphism, // pick a look
  storageKey: 'seen_intro',             // remembers completion (JSON file)
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

That's it. Skip / back / next / finish buttons, the animated indicator, page
transitions and the background are all wired up by the chosen `style`.

## Show onboarding only once

Check completion at startup and route accordingly:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final seen = await OnboardingView.hasCompleted('seen_intro');
  runApp(MyApp(showOnboarding: !seen));
}
```

When the user finishes (or skips, if `completeOnSkip` is true — the default),
the key is written to storage automatically.

## Styles

Each `OnboardingStyle` maps to a fully-formed theme. Preview them all in the
[live demo](https://torchingale.com/packages/onboarding-view/index.html).

| Style           | Look                                             | Default transition | Default indicator |
| --------------- | ------------------------------------------------ | ------------------ | ----------------- |
| `glassmorphism` | Frosted translucent cards over a vivid gradient  | parallax           | expanding         |
| `liquidGlass`   | Apple-style heavy blur, sheen & springy motion   | depth              | worm              |
| `minimal`       | Flat, typography-first                           | fade               | line/progress     |
| `material`      | Material 3, filled buttons                       | scale              | expanding         |
| `adaptive`      | Responsive layout + keyboard nav for desktop/web | parallax           | scale             |

You can pass a `style` **or** a fully custom `theme` (see [Theming](#theming)).

## Media types

`OnboardingMedia` is the hero visual at the top of each page:

```dart
OnboardingMedia.asset('assets/intro.png');          // bundled image (or GIF)
OnboardingMedia.network('https://…/photo.jpg');     // remote image, with
                                                    // loading + error states
OnboardingMedia.gif('https://…/anim.gif');          // network GIF (or isAsset:true)
OnboardingMedia.icon(Icons.rocket_launch);          // Material icon
OnboardingMedia.custom(MyLottieOrRiveWidget());     // literally anything
```

Network media shows a progress spinner while loading and a graceful fallback on
error — override both with `placeholder:` / `errorWidget:`.

## Page transitions

Set `transition:` on `OnboardingView` (or in the theme). Every effect is driven
by the **live scroll position**, so pages stay visually connected instead of
animating in isolation:

`OnboardingTransition.none` · `fade` · `scale` · `parallax` · `cube` · `depth`

Styles that define `connectedGradientColors` also blend the background color
between pages as you swipe — the flow reads as one continuous surface.

## Indicators

Configure via `IndicatorConfig` (colors, sizes, spacing). Effects:

`IndicatorEffect.dots` · `expanding` · `worm` · `scale` · `line`

The indicator sits on its own row above the buttons, is tappable (jumps to a
page), and animates smoothly with the swipe.

```dart
theme: OnboardingTheme.fromStyle(OnboardingStyle.material).copyWith(
  indicator: const IndicatorConfig(
    effect: IndicatorEffect.worm,
    activeColor: Colors.teal,
    dotSize: 10,
    spacing: 8,
  ),
),
```

## Theming

Start from a preset and tweak anything with `copyWith`, or build an
`OnboardingTheme` from scratch:

```dart
final theme = OnboardingTheme.fromStyle(
  OnboardingStyle.material,
  brightness: Brightness.dark,
  seedColor: Colors.teal,
).copyWith(
  accentColor: Colors.teal,
  transition: OnboardingTransition.parallax,
  indicator: const IndicatorConfig(effect: IndicatorEffect.worm),
  buttons: const OnboardingButtonConfig(
    variant: OnboardingButtonVariant.tonal,
    finishLabel: "Let's go",
    borderRadius: 24,
  ),
  animation: const OnboardingAnimationConfig(
    pageDuration: Duration(milliseconds: 500),
    pageCurve: Curves.easeOutCubic,
  ),
  mediaFlex: 5,   // media vs text height ratio
  textFlex: 4,
  glassBlur: 24,
  glassOpacity: 0.14,
);

OnboardingView(theme: theme, onFinish: ..., pages: ...);
```

Per-page overrides live on `OnboardingPage` (`backgroundColor`,
`backgroundGradient`, `foregroundColor`, `accentColor`, or a full
`contentBuilder` escape hatch).

## Persistence

Persistence is **dependency-free**. By default, state is written to a local JSON
file (`JsonFileOnboardingStorage`); on the web it transparently falls back to
`MemoryOnboardingStorage`.

```dart
final storage = OnboardingStorage.defaultStorage();

OnboardingView(
  storage: storage,
  storageKey: 'seen_intro',
  persistenceEnabled: true,                 // master on/off toggle
  onCompleted: (key) => log('done: $key'),  // bring-your-own hook
  onFinish: ...,
  pages: ...,
);

// Flip persistence at runtime (e.g. from a settings switch):
storage.persistenceEnabled = false;

// Read / clear:
final seen = await storage.isCompleted('seen_intro');
await storage.reset('seen_intro');
```

**Custom backend** (Hive, SQLite, a REST API…): extend `OnboardingStorage` and
pass it as `storage:`.

```dart
class MyStorage extends OnboardingStorage {
  @override
  Future<bool> isCompleted(String key) async => /* your read */;
  @override
  Future<void> setCompleted(String key, {bool value = true}) async { /* write */ }
  // …reset / readAll / writeAll
}
```

## Custom buttons & builders

Replace any piece of chrome without touching the rest:

```dart
OnboardingView(
  skipBuilder:  (ctx, c) => TextButton(onPressed: c.skipToEnd, child: const Text('Skip')),
  backBuilder:  (ctx, c) => IconButton(onPressed: c.back, icon: const Icon(Icons.chevron_left)),
  nextBuilder:  (ctx, c) => IconButton(onPressed: c.next, icon: const Icon(Icons.chevron_right)),
  finishBuilder:(ctx, c) => FilledButton(onPressed: () {}, child: const Text('Done')),
  indicatorBuilder: (ctx, c) => MyCustomIndicator(controller: c),
  onFinish: ...,
  pages: ...,
);
```

Or just change labels/variants via `OnboardingButtonConfig` in the theme.

## Controlling the flow

Pass your own `OnboardingController` to drive navigation from outside:

```dart
final controller = OnboardingController();

// …
controller.next();
controller.back();
controller.animateToPage(2);
controller.skipToEnd();
controller.progress;   // 0..1
controller.isLast;

OnboardingView(controller: controller, onFinish: ..., pages: ...);
```

## Desktop & web

- **Responsive:** above `wideLayoutBreakpoint` (default 720px) the layout switches
  to a side-by-side media/text arrangement.
- **Keyboard:** ← / → and Page Up/Down navigate pages (`enableKeyboardNavigation`).
- Content scrolls internally on short screens, so it never overflows.

## API overview

| Type                                  | Purpose                                                                        |
| ------------------------------------- | ------------------------------------------------------------------------------ |
| `OnboardingView`                      | The flow widget                                                                |
| `OnboardingPage`                      | Per-page data (title, description, media, overrides)                           |
| `OnboardingMedia`                     | `.asset` / `.network` / `.gif` / `.icon` / `.custom`                           |
| `OnboardingStyle`                     | Preset look                                                                    |
| `OnboardingTheme`                     | Full visual config (`fromStyle`, `copyWith`)                                   |
| `OnboardingButtonConfig`              | Button labels, variant, shape                                                  |
| `IndicatorConfig` / `IndicatorEffect` | Indicator look & animation                                                     |
| `OnboardingTransition`                | Page transition effect                                                         |
| `OnboardingAnimationConfig`           | Durations & curves                                                             |
| `OnboardingController`                | External navigation control                                                    |
| `OnboardingStorage`                   | Persistence interface (`JsonFileOnboardingStorage`, `MemoryOnboardingStorage`) |
| `GlassContainer`                      | Reusable frosted-glass surface                                                 |

## Example app

The [`example/`](example/) app is the same **web showcase** as the live demo:
a style picker on the left, a live phone preview on the right.

```bash
cd example
flutter run -d chrome    # or any device
```

## License

MIT
