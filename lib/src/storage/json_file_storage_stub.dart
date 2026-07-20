import 'onboarding_storage.dart';

/// Web stub for [JsonFileOnboardingStorage].
///
/// The browser has no writable filesystem via `dart:io`, so this keeps the
/// same public surface but stores everything in memory. It exists purely so
/// that `JsonFileOnboardingStorage` remains a valid type on the web.
class JsonFileOnboardingStorage extends MemoryOnboardingStorage {
  JsonFileOnboardingStorage({Object? file});
  JsonFileOnboardingStorage.atPath(this.path);

  /// Mirrors the IO API; on the web this is just the requested path (unused).
  String path = 'memory://onboarding_state.json';
}
