// import 'package:localstorage/localstorage.dart';
// LocalStorage storage = LocalStorage('score_client_app_flutter');
// class LocalDataStore {
//
//   setData({String key, dynamic value}) async {
//     await storage.ready.then((_) => _printStorage(key));
//     await storage.setItem(key, value);
//   }
//
//   removeData({String key}) async {
//     await  storage.ready.then((_) => _printStorage(key));
//     storage.deleteItem(key);
//   }
//
//   dynamic getData({String key}) async {
//     try {
//       await storage.ready.then((_) => _printStorage(key));
//       return storage.getItem(key);
//     } on Exception catch (_) {
//       return null;
//     }
//   }
//
//   deleteAll() async {
//     await storage.ready;
//
//     return storage.clear();
//   }
//
//   void _printStorage(String key) async {
//     try {
//   storage.getItem(key).toString()
//       ;
//
//       //wait until ready
//       await storage.ready;
//        storage.getItem(key).toString();
//     } on Exception catch (_) {}
//     //this will still print null:
//   }
// }
