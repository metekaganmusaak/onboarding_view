import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/onboarding_controller.dart';
import '../models/onboarding_page.dart';
import '../storage/onboarding_storage.dart';
import '../theme/onboarding_style.dart';
import '../theme/onboarding_theme.dart';
import '../transitions/page_transitions.dart';
import 'onboarding_footer.dart';
import 'onboarding_page_view.dart';

/// A fully-featured, highly customizable onboarding flow.
///
/// ```dart
/// OnboardingView(
///   style: OnboardingStyle.glassmorphism,
///   storageKey: 'seen_intro',
///   onFinish: () => context.go('/home'),
///   pages: const [
///     OnboardingPage(
///       title: 'Welcome',
///       description: 'Everything you need, in one place.',
///       media: OnboardingMedia.network('https://picsum.photos/600'),
///     ),
///   ],
/// );
/// ```
class OnboardingView extends StatefulWidget {
  const OnboardingView({
    super.key,
    required this.pages,
    required this.onFinish,
    this.theme,
    this.style = OnboardingStyle.material,
    this.controller,
    this.transition,
    this.showSkip = true,
    this.showBack = true,
    this.completeOnSkip = true,
    this.onSkip,
    this.onPageChanged,
    this.storage,
    this.storageKey,
    this.persistenceEnabled = true,
    this.onCompleted,
    this.enableKeyboardNavigation = true,
    this.wideLayoutBreakpoint = 720,
    this.skipBuilder,
    this.backBuilder,
    this.nextBuilder,
    this.finishBuilder,
    this.indicatorBuilder,
  }) : assert(pages.length > 0, 'Provide at least one onboarding page.');

  /// The pages, in order.
  final List<OnboardingPage> pages;

  /// Called when the user finishes (or skips, when [completeOnSkip] is true).
  final VoidCallback onFinish;

  /// Explicit theme. When null, one is derived from [style] using the ambient
  /// [Brightness].
  final OnboardingTheme? theme;

  /// Preset used when [theme] is null.
  final OnboardingStyle style;

  /// Optional external controller. When null one is created and disposed here.
  final OnboardingController? controller;

  /// Overrides the theme's page transition.
  final OnboardingTransition? transition;

  final bool showSkip;
  final bool showBack;

  /// Whether skipping also marks the onboarding as completed in storage.
  final bool completeOnSkip;

  /// Custom skip action. Defaults to jumping to the last page.
  final VoidCallback? onSkip;

  final ValueChanged<int>? onPageChanged;

  /// Persistence backend. Defaults to a platform-appropriate storage (JSON file
  /// on IO, in-memory on web) the first time it's needed.
  final OnboardingStorage? storage;

  /// Key under which completion is recorded. Persistence is skipped when null.
  final String? storageKey;

  /// Master persistence toggle, forwarded to [storage.persistenceEnabled].
  final bool persistenceEnabled;

  /// Raw callback fired with [storageKey] when the flow completes — use this to
  /// plug in your own persistence without a storage object.
  final ValueChanged<String?>? onCompleted;

  /// Enables ← / → and Page Up/Down keyboard navigation (desktop / web).
  final bool enableKeyboardNavigation;

  /// Above this width the layout switches to a side-by-side wide layout.
  final double wideLayoutBreakpoint;

  final OnboardingButtonBuilder? skipBuilder;
  final OnboardingButtonBuilder? backBuilder;
  final OnboardingButtonBuilder? nextBuilder;
  final OnboardingButtonBuilder? finishBuilder;
  final OnboardingButtonBuilder? indicatorBuilder;

  /// Whether the onboarding under [key] has already been completed.
  ///
  /// Call at app start to decide whether to show onboarding at all.
  static Future<bool> hasCompleted(String key, {OnboardingStorage? storage}) {
    final store = storage ?? OnboardingStorage.defaultStorage();
    return store.isCompleted(key);
  }

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late OnboardingController _controller;
  late OnboardingStorage _storage;
  bool _ownsController = false;
  final FocusNode _focusNode = FocusNode();

  OnboardingTheme get _resolvedTheme =>
      widget.theme ??
      OnboardingTheme.fromStyle(
        widget.style,
        brightness: Theme.of(context).brightness,
      );

  @override
  void initState() {
    super.initState();
    _storage = widget.storage ?? OnboardingStorage.defaultStorage();
    _storage.persistenceEnabled = widget.persistenceEnabled;
    _setupController();
  }

  void _setupController() {
    final theme = widget.theme ?? OnboardingTheme.fromStyle(widget.style);
    _controller = widget.controller ??
        OnboardingController(
          animationDuration: theme.animation.pageDuration,
          animationCurve: theme.animation.pageCurve,
        );
    _ownsController = widget.controller == null;
    _controller.attachPageCount(widget.pages.length);
  }

  @override
  void didUpdateWidget(OnboardingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.persistenceEnabled != widget.persistenceEnabled) {
      _storage.persistenceEnabled = widget.persistenceEnabled;
    }
    if (oldWidget.pages.length != widget.pages.length) {
      _controller.attachPageCount(widget.pages.length);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  Future<void> _markCompleted() async {
    final key = widget.storageKey;
    if (key != null && widget.persistenceEnabled) {
      await _storage.setCompleted(key);
    }
    widget.onCompleted?.call(key);
  }

  Future<void> _finish() async {
    await _markCompleted();
    widget.onFinish();
  }

  void _skip() {
    if (widget.completeOnSkip) _markCompleted();
    if (widget.onSkip != null) {
      widget.onSkip!();
    } else {
      _controller.skipToEnd();
    }
  }

  void _handleKey(KeyEvent event) {
    if (!widget.enableKeyboardNavigation || event is! KeyDownEvent) return;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.pageDown) {
      _controller.isLast ? _finish() : _controller.next();
    } else if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.pageUp) {
      _controller.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _resolvedTheme;
    final transition = widget.transition ?? theme.transition;
    final foreground = theme.foregroundColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black);

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.enableKeyboardNavigation,
      onKeyEvent: (_, event) {
        _handleKey(event);
        return KeyEventResult.ignored;
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final accent =
              widget.pages[_controller.index].accentColor ?? theme.accentColor;
          return Scaffold(
            body: Container(
              decoration:
                  BoxDecoration(gradient: _buildBackground(theme), color: null),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide =
                        constraints.maxWidth >= widget.wideLayoutBreakpoint;
                    return Column(
                      children: [
                        _buildTopBar(theme, foreground),
                        Expanded(
                          child: _buildPageView(theme, transition, isWide),
                        ),
                        OnboardingFooter(
                          controller: _controller,
                          theme: theme,
                          foreground: foreground,
                          accent: accent,
                          showBack: widget.showBack,
                          onNext: _controller.next,
                          onBack: _controller.back,
                          onFinish: _finish,
                          backBuilder: widget.backBuilder,
                          nextBuilder: widget.nextBuilder,
                          finishBuilder: widget.finishBuilder,
                          indicatorBuilder: widget.indicatorBuilder,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Gradient? _buildBackground(OnboardingTheme theme) {
    final colors = theme.connectedGradientColors;
    if (colors != null && colors.length >= 2) {
      // Blend between adjacent page colors based on the live scroll position,
      // so the whole flow reads as one continuous surface.
      final t = _controller.page.clamp(0, colors.length - 1).toDouble();
      final lower = t.floor();
      final upper = (lower + 1).clamp(0, colors.length - 1);
      final frac = t - lower;
      final top = Color.lerp(colors[lower], colors[upper], frac)!;
      final bottom = Color.lerp(
        colors[(lower + 1) % colors.length],
        colors[(upper + 1) % colors.length],
        frac,
      )!;
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [top, bottom],
      );
    }
    if (theme.backgroundGradient != null) return theme.backgroundGradient;
    if (theme.backgroundColor != null) {
      return LinearGradient(
        colors: [theme.backgroundColor!, theme.backgroundColor!],
      );
    }
    return null;
  }

  Widget _buildTopBar(OnboardingTheme theme, Color foreground) {
    final showSkip = widget.showSkip && !_controller.isLast;
    return SizedBox(
      height: 48,
      child: Align(
        alignment: Alignment.centerRight,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: showSkip ? 1 : 0,
          child: IgnorePointer(
            ignoring: !showSkip,
            child: widget.skipBuilder?.call(context, _controller) ??
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: TextButton(
                    onPressed: _skip,
                    style: TextButton.styleFrom(
                      foregroundColor: foreground.withValues(alpha: 0.8),
                    ),
                    child: Text(theme.buttons.skipLabel),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageView(
    OnboardingTheme theme,
    OnboardingTransition transition,
    bool isWide,
  ) {
    return PageView.builder(
      controller: _controller.pageController,
      itemCount: widget.pages.length,
      onPageChanged: (i) {
        _controller.onPageChanged(i);
        widget.onPageChanged?.call(i);
      },
      itemBuilder: (context, index) {
        final delta = index - _controller.page;
        return applyOnboardingTransition(
          transition: transition,
          delta: delta,
          child: OnboardingPageContent(
            page: widget.pages[index],
            theme: theme,
            isWide: isWide,
          ),
        );
      },
    );
  }
}
