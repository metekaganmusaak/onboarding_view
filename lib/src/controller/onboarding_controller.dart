import 'package:flutter/widgets.dart';

/// Drives an onboarding flow: page navigation, progress and lifecycle.
///
/// Wraps a [PageController] and exposes convenient, animatable navigation plus
/// a fractional [page] value so indicators and page transitions can react to
/// the live scroll position (not just discrete index changes).
///
/// You may construct one yourself to control the flow from the outside, or let
/// `OnboardingView` create one internally.
class OnboardingController extends ChangeNotifier {
  OnboardingController({
    int initialPage = 0,
    this.animationDuration = const Duration(milliseconds: 450),
    this.animationCurve = Curves.easeInOutCubic,
  })  : _index = initialPage,
        _page = initialPage.toDouble(),
        pageController = PageController(initialPage: initialPage) {
    pageController.addListener(_onScroll);
  }

  /// The underlying [PageController] wired into the `PageView`.
  final PageController pageController;

  /// Default duration for programmatic page animations.
  final Duration animationDuration;

  /// Default curve for programmatic page animations.
  final Curve animationCurve;

  int _index;
  double _page;
  int _pageCount = 0;

  /// The current, settled page index.
  int get index => _index;

  /// The live fractional page position (e.g. 1.5 mid-swipe). Great for driving
  /// indicator and transition interpolation.
  double get page => _page;

  /// Total number of pages. Set by the flow widget.
  int get pageCount => _pageCount;

  /// Completion progress in the range 0..1.
  double get progress => _pageCount <= 1 ? 1 : _index / (_pageCount - 1);

  bool get isFirst => _index <= 0;
  bool get isLast => _pageCount == 0 || _index >= _pageCount - 1;

  /// Called by the flow to report how many pages exist.
  void attachPageCount(int count) {
    if (_pageCount != count) {
      _pageCount = count;
      notifyListeners();
    }
  }

  void _onScroll() {
    if (!pageController.hasClients) return;
    final p = pageController.page;
    if (p != null && p != _page) {
      _page = p;
      final rounded = p.round();
      if (rounded != _index) _index = rounded;
      notifyListeners();
    }
  }

  /// Advances to the next page (no-op on the last page).
  Future<void> next() async {
    if (isLast) return;
    await animateToPage(_index + 1);
  }

  /// Returns to the previous page (no-op on the first page).
  Future<void> back() async {
    if (isFirst) return;
    await animateToPage(_index - 1);
  }

  /// Jumps straight to the final page (used by the default skip action).
  Future<void> skipToEnd() async {
    if (_pageCount == 0) return;
    await animateToPage(_pageCount - 1);
  }

  /// Animates to an arbitrary [target] page, clamped to valid bounds.
  Future<void> animateToPage(int target) async {
    if (!pageController.hasClients || _pageCount == 0) return;
    final clamped = target.clamp(0, _pageCount - 1);
    await pageController.animateToPage(
      clamped,
      duration: animationDuration,
      curve: animationCurve,
    );
  }

  /// Called by the `PageView` when the settled page changes.
  void onPageChanged(int newIndex) {
    if (_index != newIndex) {
      _index = newIndex;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}
