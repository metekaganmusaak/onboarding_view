import 'package:flutter/material.dart';
import 'package:onboarding_view/onboarding_view.dart';

import 'main.dart';
import 'onboarding_data.dart';

/// Landing screen: a gallery of onboarding styles plus persistence controls.
class StyleGalleryScreen extends StatefulWidget {
  const StyleGalleryScreen({super.key});

  @override
  State<StyleGalleryScreen> createState() => _StyleGalleryScreenState();
}

class _StyleGalleryScreenState extends State<StyleGalleryScreen> {
  bool _persist = true;

  @override
  void initState() {
    super.initState();
    _persist = appStorage.persistenceEnabled;
  }

  Future<void> _resetAll() async {
    for (final style in OnboardingStyle.values) {
      await appStorage.reset(storageKeyFor(style));
    }
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Onboarding state cleared.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding styles'),
        actions: [
          IconButton(
            tooltip: 'Reset all onboarding state',
            icon: const Icon(Icons.restart_alt),
            onPressed: _resetAll,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PersistenceCard(
            value: _persist,
            onChanged: (v) {
              setState(() => _persist = v);
              appStorage.persistenceEnabled = v;
            },
          ),
          const SizedBox(height: 16),
          Text('Pick a look', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 640 ? 3 : 2;
              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.82,
                children: [
                  for (final preset in _presets)
                    _StyleCard(
                      preset: preset,
                      onTap: () => openOnboarding(context, preset.style),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PersistenceCard extends StatelessWidget {
  const _PersistenceCard({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        title: const Text('Remember completion'),
        subtitle: Text(
          value
              ? 'State is written to the local JSON file.'
              : 'Nothing is persisted — every launch shows onboarding.',
        ),
        secondary: const Icon(Icons.save_outlined),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  const _StyleCard({required this.preset, required this.onTap});

  final _StylePreset preset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(gradient: preset.gradient),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(preset.icon, color: Colors.white, size: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preset.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preset.blurb,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StylePreset {
  const _StylePreset({
    required this.style,
    required this.label,
    required this.blurb,
    required this.icon,
    required this.gradient,
  });

  final OnboardingStyle style;
  final String label;
  final String blurb;
  final IconData icon;
  final Gradient gradient;
}

const _presets = <_StylePreset>[
  _StylePreset(
    style: OnboardingStyle.glassmorphism,
    label: 'Glassmorphism',
    blurb: 'Frosted cards, vivid gradient',
    icon: Icons.blur_on,
    gradient: LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)]),
  ),
  _StylePreset(
    style: OnboardingStyle.liquidGlass,
    label: 'Liquid Glass',
    blurb: 'Apple-style depth & sheen',
    icon: Icons.water_drop,
    gradient: LinearGradient(colors: [Color(0xFF1D2B64), Color(0xFF3A1C71)]),
  ),
  _StylePreset(
    style: OnboardingStyle.minimal,
    label: 'Minimal',
    blurb: 'Typography-first, flat',
    icon: Icons.horizontal_rule,
    gradient: LinearGradient(colors: [Color(0xFF232526), Color(0xFF414345)]),
  ),
  _StylePreset(
    style: OnboardingStyle.material,
    label: 'Material',
    blurb: 'Material 3, filled buttons',
    icon: Icons.widgets,
    gradient: LinearGradient(colors: [Color(0xFF7F53AC), Color(0xFF647DEE)]),
  ),
  _StylePreset(
    style: OnboardingStyle.adaptive,
    label: 'Adaptive',
    blurb: 'Responsive + keyboard nav',
    icon: Icons.devices,
    gradient: LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
  ),
];
