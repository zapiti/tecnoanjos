

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/components/search/searcher.dart';

import 'filter.dart';


class SearchBloc<T> extends Disposable {
  final Searcher searcher;
  Filter<T> filter;

  final _isInSearchMode = BehaviorSubject<bool>();
  final _searchQuery = BehaviorSubject<String>();

  ///
  /// Inputs
  ///
  get onSearchQueryChanged => _searchQuery.add;

  get setSearchMode => _isInSearchMode.add;

  Function get onClearSearchQuery => () => onSearchQueryChanged('');

  ///
  /// Outputs
  ///
   get isInSearchMode => _isInSearchMode.stream;

  get searchQuery => _searchQuery.stream;

  ///
  /// Constructor
  ///
  SearchBloc({
    @required this.searcher,
    this.filter,
  }) {
    _configureFilter();
    searchQuery.listen((query) {
      final List<T> filtered =
          searcher.data.where((test) => filter(test, query)).toList();
      searcher.onDataFiltered(filtered);
    });
  }

  _configureFilter() {
    if (filter == null) {
      if (T == String) {
        filter = _defaultFilter;
      } else {
        throw (Exception(
            'If data is not a List of Strings, a filter function must be provided for SearchAppBar!'));
      }
    }
  }

  Filter get _defaultFilter => Filters.startsWith;

  @override
  void dispose() {
    _isInSearchMode.close();
    _searchQuery.close();
  }
}
