

import 'package:localstorage/localstorage.dart';
LocalStorage storage = LocalStorage('omni_score_code_app');
class LocalDataStore {

  setData({String key, dynamic value}) async {
    await storage.ready.then((_) => _printStorage(key));
    await storage.setItem(key, value);
    await storage.ready.then((_) => _printStorage(key));
  }

  removeData({String key}) async {
    await  storage.ready.then((_) => _printStorage(key));
    storage.deleteItem(key);
  }

  dynamic getData({String key}) async {
    try {
      await storage.ready.then((_) => _printStorage(key));
      return storage.getItem(key);
    } on Exception catch (_) {
      return null;
    }
  }

  deleteAll() async {
    await storage.ready;

    return storage.clear();
  }
  dynamic getValue({String key})  {
    try {
      storage.ready.then((_) => _printStorage(key));
      return storage.getItem(key);
    } on Exception catch (_) {
      return null;
    }
  }
  void _printStorage(String key) async {
    try {
    //debugPrint("before ready: $key => " + storage.getItem(key).toString());

      //wait until ready
      await storage.ready;
    } on Exception catch (_) {}
    //this will still print null:
  }
}
