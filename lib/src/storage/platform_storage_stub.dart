import 'onboarding_storage.dart';

/// Web / fallback factory: `dart:io` is unavailable, so we keep state in memory.
OnboardingStorage createPlatformStorage() => MemoryOnboardingStorage();
