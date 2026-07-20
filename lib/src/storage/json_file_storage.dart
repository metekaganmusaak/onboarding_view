import 'dart:convert';
import 'dart:io';

import 'onboarding_storage.dart';

/// Default, dependency-free [OnboardingStorage] that persists state to a local
/// JSON file via `dart:io`.
///
/// ```dart
/// final storage = JsonFileOnboardingStorage(); // temp dir default
/// // or point it at your own location:
/// final storage = JsonFileOnboardingStorage.atPath('/data/onboarding.json');
/// ```
///
/// On the web this class is replaced by an in-memory stub of the same name, so
/// code that references it keeps compiling everywhere.
class JsonFileOnboardingStorage extends OnboardingStorage {
  JsonFileOnboardingStorage({File? file})
      : _file =
            file ?? File('${Directory.systemTemp.path}/onboarding_state.json');

  /// Creates a storage pointed at an explicit file [path].
  JsonFileOnboardingStorage.atPath(String path) : _file = File(path);

  final File _file;
  Map<String, dynamic>? _cache;

  /// The backing file location (handy for logging / debugging).
  String get path => _file.path;

  Future<Map<String, dynamic>> _load() async {
    if (_cache != null) return _cache!;
    try {
      if (await _file.exists()) {
        final raw = await _file.readAsString();
        if (raw.trim().isNotEmpty) {
          final decoded = jsonDecode(raw);
          if (decoded is Map<String, dynamic>) {
            return _cache = decoded;
          }
        }
      }
    } catch (_) {
      // Corrupt / unreadable file — start fresh rather than crashing the app.
    }
    return _cache = <String, dynamic>{};
  }

  Future<void> _flush() async {
    final data = _cache ?? <String, dynamic>{};
    try {
      await _file.create(recursive: true);
      await _file.writeAsString(jsonEncode(data));
    } catch (_) {
      // Best-effort persistence; never let a disk error break onboarding.
    }
  }

  @override
  Future<bool> isCompleted(String key) async {
    final data = await _load();
    return data[key] == true;
  }

  @override
  Future<void> setCompleted(String key, {bool value = true}) async {
    if (!persistenceEnabled) return;
    final data = await _load();
    data[key] = value;
    await _flush();
  }

  @override
  Future<void> reset(String key) async {
    final data = await _load();
    data.remove(key);
    await _flush();
  }

  @override
  Future<Map<String, dynamic>> readAll() async =>
      Map<String, dynamic>.from(await _load());

  @override
  Future<void> writeAll(Map<String, dynamic> data) async {
    if (!persistenceEnabled) return;
    _cache = Map<String, dynamic>.from(data);
    await _flush();
  }
}
