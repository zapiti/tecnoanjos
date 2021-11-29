
import 'package:localstorage/localstorage.dart';
import 'package:synchronized/synchronized.dart';


var codePreferences = _CdPreferences();
LocalStorage storage = LocalStorage('score_client_app_flutter');

class _CdPreferences {
  static const _prefix = "cd_tecno_";

  _CdPreferences() {
      storage.ready.then((_) => _printStorage(_prefix));
  }

  void clear() async {
    final lock = Lock();
    return lock.synchronized(() async {
      await  storage.ready.then((_) => _printStorage(_prefix));
      return storage.clear();
    });
  }

  set({String key, dynamic value, String prefix}) async {
    final lock = Lock();
    return lock.synchronized(() async {
      try {
        await  storage.ready.then((_) => _printStorage(key));
        return storage.setItem(prefix ?? _prefix + key, value);
      } catch (e) {
        return null;
      }
    });
  }

  Future<String> getString({String key, String ifNotExists}) async {
    final lock = Lock();
    return lock.synchronized(() async{
      try {
        String value = ifNotExists;
        await  storage.ready.then((_) => _printStorage(key));
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

  void _printStorage(String key) async {
    try {
  storage.getItem(key).toString()
      ;

      //wait until ready
      await storage.ready;
       storage.getItem(key).toString();
    } on Exception catch (_) {}
    //this will still print null:
  }