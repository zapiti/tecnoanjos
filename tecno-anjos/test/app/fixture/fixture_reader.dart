import 'dart:io';

String fixture(String name) {
  var currentDirectory = Directory.current.toString().replaceAll('\'', '');
  var lastDirectory = currentDirectory.split('/')[currentDirectory.split('/').length - 1];
  if (lastDirectory == 'test') {
    return File('app/fixture/$name').readAsStringSync();
  } else {
    return File('test/app/fixture/$name').readAsStringSync();
  }
}