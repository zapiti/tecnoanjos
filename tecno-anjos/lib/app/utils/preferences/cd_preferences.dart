import 'package:localstorage/localstorage.dart';
import 'package:synchronized/synchronized.dart';

var codePreferences = _CdPreferences();
LocalStorage storage = LocalStorage('score_teno_app_flutter');

class _CdPreferences {
  static const _prefix = "cd_tecno_";

  _CdPreferences();

  void clear() async {
    final lock = Lock();
    return lock.synchronized(() {
      return storage.clear();
    });
  }

  set({String key, dynamic value, String prefix}) async {
    final lock = Lock();
    return lock.synchronized(() {
      try {
        return storage.setItem(prefix ?? _prefix + key, value);
      } catch (e) {
        return null;
      }
    });
  }

  Future<String> getString({String key, String ifNotExists}) async {
    final lock = Lock();
    return lock.synchronized(() {
      try {
        String value = ifNotExists;

        value = storage.getItem(_prefix + key);
        return value ?? ifNotExists;
      } catch (e) {
        return null;
      }
    });
  }

  Future<bool> getBoolean({String key, bool ifNotExists}) async {
    final lock = Lock();
    return lock.synchronized(() {
      try {
        bool value = ifNotExists;
        value = storage.getItem(_prefix + key);
        return value ?? ifNotExists;
      } catch (e) {
        return false;
      }
    });
  }
}
