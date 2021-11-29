
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';

class MySearchBloc extends Disposable {
  //dispose will be called automatically by closing its streams
  var searchElement = BehaviorSubject<List<Pairs>>();

  getSearch(Future<ResponsePaginated> result) async {
    searchElement.sink.add(null);
    var searchResult = await result;
    searchElement.sink.add(searchResult.content );
  }
  @override
  void dispose() {
    searchElement.drain();
  }
}
