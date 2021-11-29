

import 'local_storage.dart';

var codePreferences = _CdPreferences();

class _CdPreferences {
  var localDataStore = LocalDataStore();
  static const _prefix = "omni_";

  _CdPreferences();

  void clear() async {
    localDataStore.deleteAll();
  }

  set({String key, dynamic value, String prefix}) async {
    localDataStore.setData(key: prefix ?? _prefix + key, value: value);
  }

  Future<String> getString({String key, String ifNotExists}) async {
    String value = ifNotExists;

    value = await localDataStore.getData(key: _prefix + key);
    return value ?? ifNotExists;
  }

  Future<bool> getBoolean({String key, bool ifNotExists}) async {
    bool value = ifNotExists;
    value = await localDataStore.getData(key: _prefix + key);
    return value ?? ifNotExists;
  }

  String getValue({String key}) {
    return localDataStore.getValue(key: _prefix + key);
  }
}
