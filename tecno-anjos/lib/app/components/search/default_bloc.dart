import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';
import 'package:tecnoanjostec/app/components/search/searcher.dart';

class DefaultBloc extends Disposable implements Searcher<String> {
  final _filteredData = BehaviorSubject<List<String>>();

  final dataList = [
    '',
  ];

  Stream<List<String>> get filteredData => _filteredData.stream;

  DefaultBloc() {
    _filteredData.add(dataList);
  }

  @override
  get onDataFiltered => _filteredData.add;

  @override
  get data => dataList;

  @override
  void dispose() {
    _filteredData.close();
  }
}
