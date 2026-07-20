import 'platform_storage_stub.dart'
    if (dart.library.io) 'platform_storage_io.dart' as platform;

/// Contract for persisting onboarding completion state.
///
/// The package ships with two zero-dependency implementations:
///
/// * [JsonFileOnboardingStorage] — writes a small JSON file to disk using
///   `dart:io` (mobile / desktop).
/// * [MemoryOnboardingStorage] — in-memory only, used automatically on the
///   web where `dart:io` is unavailable.
///
/// You can supply your own implementation (Hive, SQLite, a REST backend, …)
/// by extending this class and passing it to `OnboardingView`.
abstract class OnboardingStorage {
  /// Master switch. When `false`, [setCompleted] / [writeAll] become no-ops
  /// so nothing is written to the underlying medium. Read operations still
  /// work. Toggle this at runtime to give users a "remember me" style choice.
  bool persistenceEnabled = true;

  /// Whether the onboarding identified by [key] has been completed before.
  Future<bool> isCompleted(String key);

  /// Marks [key] as completed (or not, via [value]).
  ///
  /// Honours [persistenceEnabled] — a no-op when persistence is disabled.
  Future<void> setCompleted(String key, {bool value = true});

  /// Clears any stored state for [key].
  Future<void> reset(String key);

  /// Reads the full raw state map. Useful for custom / advanced consumers.
  Future<Map<String, dynamic>> readAll();

  /// Overwrites the full raw state map.
  ///
  /// Honours [persistenceEnabled] — a no-op when persistence is disabled.
  Future<void> writeAll(Map<String, dynamic> data);

  /// Convenience toggles for wiring straight to a UI switch.
  void enablePersistence() => persistenceEnabled = true;
  void disablePersistence() => persistenceEnabled = false;

  /// Returns the recommended default storage for the current platform:
  /// a JSON file on IO platforms, in-memory on the web.
  static OnboardingStorage defaultStorage() => platform.createPlatformStorage();
}

/// A non-persistent [OnboardingStorage] kept entirely in memory.
///
/// Used as the automatic fallback on the web and handy in tests.
class MemoryOnboardingStorage extends OnboardingStorage {
  final Map<String, dynamic> _data = <String, dynamic>{};

  @override
  Future<bool> isCompleted(String key) async => _data[key] == true;

  @override
  Future<void> setCompleted(String key, {bool value = true}) async {
    if (!persistenceEnabled) return;
    _data[key] = value;
  }

  @override
  Future<void> reset(String key) async => _data.remove(key);

  @override
  Future<Map<String, dynamic>> readAll() async =>
      Map<String, dynamic>.from(_data);

  @override
  Future<void> writeAll(Map<String, dynamic> data) async {
    if (!persistenceEnabled) return;
    _data
      ..clear()
      ..addAll(data);
  }
}
