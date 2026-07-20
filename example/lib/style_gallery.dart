import 'package:flutter/material.dart';
import 'package:onboarding_view/onboarding_view.dart';

import 'main.dart';
import 'onboarding_data.dart';
import 'phone_mockup.dart';

/// Web showcase: a selection panel on the left, a live phone preview on the
/// right. Picking a style instantly re-renders the onboarding inside the phone.
class StyleGalleryScreen extends StatefulWidget {
  const StyleGalleryScreen({super.key});

  @override
  State<StyleGalleryScreen> createState() => _StyleGalleryScreenState();
}

class _StyleGalleryScreenState extends State<StyleGalleryScreen> {
  OnboardingStyle _selected = OnboardingStyle.glassmorphism;
  bool _persist = true;

  // Bumped to force the preview to restart from the first page.
  int _reloadToken = 0;

  @override
  void initState() {
    super.initState();
    _persist = appStorage.persistenceEnabled;
  }

  void _select(OnboardingStyle style) {
    setState(() {
      _selected = style;
      _reloadToken++;
    });
  }

  void _restartPreview() => setState(() => _reloadToken++);

  Future<void> _resetPersistence() async {
    for (final style in OnboardingStyle.values) {
      await appStorage.reset(storageKeyFor(style));
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved onboarding state cleared.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0F17), Color(0xFF1A1230)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 900;
              final panel = _SelectionPanel(
                selected: _selected,
                onSelect: _select,
                persist: _persist,
                onPersistChanged: (v) {
                  setState(() => _persist = v);
                  appStorage.persistenceEnabled = v;
                },
                onResetPersistence: _resetPersistence,
              );
              final preview = _PreviewArea(
                key: ValueKey('$_selected-$_reloadToken'),
                style: _selected,
                onRestart: _restartPreview,
              );

              if (narrow) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SizedBox(height: 640, child: preview),
                    const SizedBox(height: 16),
                    panel,
                  ],
                );
              }
              // True 50/50 web split: selection on the left half, phone on the
              // right half. The left content is capped and centered so it never
              // clings to the window edge.
              return Row(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 40),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: panel,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF15111F), Color(0xFF0B0910)],
                        ),
                      ),
                      child: preview,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Left column: title, style chooser and persistence controls.
class _SelectionPanel extends StatelessWidget {
  const _SelectionPanel({
    required this.selected,
    required this.onSelect,
    required this.persist,
    required this.onPersistChanged,
    required this.onResetPersistence,
  });

  final OnboardingStyle selected;
  final ValueChanged<OnboardingStyle> onSelect;
  final bool persist;
  final ValueChanged<bool> onPersistChanged;
  final VoidCallback onResetPersistence;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Flutter package',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'onboarding_view',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'A modern, highly customizable onboarding for Flutter. '
          'Pick a style on the left and preview it live on the phone.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 16,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        for (final preset in stylePresets)
          _StyleTile(
            preset: preset,
            selected: preset.style == selected,
            onTap: () => onSelect(preset.style),
          ),
        const SizedBox(height: 16),
        Divider(color: Colors.white.withValues(alpha: 0.1)),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Remember completion',
              style: TextStyle(color: Colors.white)),
          subtitle: Text(
            persist ? 'Writing to local JSON file' : 'Persistence disabled',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          ),
          value: persist,
          onChanged: onPersistChanged,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onResetPersistence,
            icon: const Icon(Icons.restart_alt),
            label: const Text('Reset saved state'),
          ),
        ),
      ],
    );
  }
}

class _StyleTile extends StatelessWidget {
  const _StyleTile({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final StylePreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.white.withValues(alpha: 0.12),
                width: selected ? 2 : 1,
              ),
              color: selected
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: preset.gradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(preset.icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        preset.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        preset.blurb,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Right column: the phone mockup wrapping a live [OnboardingView].
class _PreviewArea extends StatefulWidget {
  const _PreviewArea({
    super.key,
    required this.style,
    required this.onRestart,
  });

  final OnboardingStyle style;
  final VoidCallback onRestart;

  @override
  State<_PreviewArea> createState() => _PreviewAreaState();
}

class _PreviewAreaState extends State<_PreviewArea> {
  bool _finished = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PhoneMockup(
        child: _finished
            ? _FinishedCard(
                style: widget.style,
                onRestart: () {
                  setState(() => _finished = false);
                  widget.onRestart();
                },
              )
            : OnboardingView(
                style: widget.style,
                storage: appStorage,
                storageKey: storageKeyFor(widget.style),
                transition: transitionFor(widget.style),
                pages: pagesFor(widget.style),
                onFinish: () => setState(() => _finished = true),
              ),
      ),
    );
  }
}

class _FinishedCard extends StatelessWidget {
  const _FinishedCard({required this.style, required this.onRestart});

  final OnboardingStyle style;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF12121A),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                color: Color(0xFF38EF7D), size: 64),
            const SizedBox(height: 16),
            const Text(
              'Onboarding complete',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              style.name,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: onRestart,
              icon: const Icon(Icons.replay),
              label: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
