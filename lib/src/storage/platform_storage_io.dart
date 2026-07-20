import 'json_file_storage.dart';
import 'onboarding_storage.dart';

/// IO (mobile / desktop) factory: persist to a local JSON file.
OnboardingStorage createPlatformStorage() => JsonFileOnboardingStorage();
