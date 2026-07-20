# CHANGELOG

## 1.0.1

### Fixed
- **Footer overflow** on small / embedded screens. The page indicator now sits
  on its own row above the navigation buttons, giving it the full width. The
  indicator scales to fit (`FittedBox`) and the back / next / finish buttons
  shrink gracefully, so the footer never overflows — even inside a phone-sized
  preview.
- **Vertical overflow** of long page content on short screens: the title +
  description block now scrolls internally instead of clipping.

### Added
- 🌐 **Live demo:** <https://torchingale.com/packages/onboarding-view/index.html>

## 1.0.0

Complete redesign — a modern, highly customizable onboarding toolkit.

**Breaking:** the old `Onboarding` / `OnboardingView` API has been replaced.

### Added

- **Five built-in styles** via `OnboardingStyle`: `glassmorphism`, `liquidGlass`
  (Apple-style), `minimal`, `material` (Material 3) and `adaptive`.
- **`OnboardingTheme`** — a fully `copyWith`-able theme covering colors,
  typography, indicator, buttons, animation timing, layout ratios and glass
  blur/opacity. Build from a preset with `OnboardingTheme.fromStyle`.
- **Rich media** through `OnboardingMedia`: `.asset`, `.network` (with loading
  - error states), `.gif`, `.icon` and `.custom`.
- **Page transitions** (`OnboardingTransition`): fade, scale, parallax, cube,
  depth — driven by the live scroll position so pages feel connected. A shared
  "connected gradient" background blends between pages as you swipe.
- **Animated page indicators** (`IndicatorEffect`): dots, expanding, worm,
  scale and line/progress, all tappable.
- **`OnboardingController`** — external navigation control with fractional page
  tracking, `next` / `back` / `skip` / `progress`.
- **Zero-dependency local persistence**: `OnboardingStorage` interface with a
  default JSON-file implementation (`dart:io`) and an in-memory web fallback.
  Includes a runtime `persistenceEnabled` toggle and `onCompleted` callback for
  bring-your-own storage. `OnboardingView.hasCompleted(key)` for app startup.
- **Highly customizable chrome**: builder hooks for skip / back / next / finish
  buttons and the indicator; configurable labels, variants and shapes.
- **Desktop & web ready**: responsive wide layout and keyboard (← / →) navigation.
- Redesigned example app: a style gallery with a live persistence toggle.

## 0.0.3

- Nothing much... Updated new package logo!

## 0.0.2

- Change pubspec.yaml description.

## 0.0.1

- Initial
