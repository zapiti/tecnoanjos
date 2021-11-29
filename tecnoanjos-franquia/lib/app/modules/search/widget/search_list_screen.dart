import 'package:tecnoanjos_franquia/app/components/builder/builder_component.dart';
import 'package:tecnoanjos_franquia/app/components/search/filter.dart';
import 'package:tecnoanjos_franquia/app/components/search/search_app_bar.dart';
import 'package:tecnoanjos_franquia/app/models/pairs.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../search_bloc.dart';

class SearchListScreen extends StatefulWidget {
  final String title;

  SearchListScreen(this.title);

  @override
  _SearchListScreenState createState() => new _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  final searchBloc = Modular.get<MySearchBloc>();

  bool _isSearching;
  String _searchText = "";

  _SearchListScreenState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  backgroundColor: Colors.white,
      key: key,
      appBar: buildBar(context),
      body: builderComponent(
          buildBodyFunc: buildSearchListBody,
          defaultValue: [],
          stream: searchBloc.searchElement),
    );
  }

  ListView buildSearchListBody(BuildContext context, List<Pairs> elemets) {
    return ListView(
      padding: new EdgeInsets.symmetric(vertical: 8.0),
      children: _isSearching ? _buildSearchList(elemets) : _buildList(elemets),
    );
  }

  List<ChildItem> _buildList(List listElements) {
    return listElements.map((contact) => new ChildItem(contact)).toList();
  }

  List<ChildItem> _buildSearchList(List listElements) {
    if (_searchText.isEmpty) {
      return listElements.map((contact) => new ChildItem(contact)).toList();
    } else {
      List<Pairs> _searchList = List();
      for (int i = 0; i < listElements.length; i++) {
        Pairs name = listElements.elementAt(i);
        if (name.second.toLowerCase().contains(_searchText.toLowerCase()) ||
            name.first
                .toString()
                .toLowerCase()
                .contains(_searchText.toLowerCase()) || name.third
            .toString()
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }
      return _searchList.map((contact) => new ChildItem(contact)).toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return SearchAppBar<String>(
      title: Text(widget.title,style: AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary,fontSize: 18),),
      hintText: "Buscar...",
      backgroundColor: AppThemeUtils.whiteColor,

      changeLabel: (value) {
        _searchQuery.text = value;
      },
      filter: Filters.contains,
      iconTheme: IconThemeData(color: AppThemeUtils.iconColor),
    );
  }
}

class ChildItem extends StatelessWidget {
  final Pairs elements;

  ChildItem(this.elements);

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: ListTile(
      title: Container(
        child: Text(this.elements.second),
        margin: EdgeInsets.all(10),
      ),subtitle: Container(
    child: Text(this.elements.third), margin: EdgeInsets.all(10),),
      trailing:  Icon(
        Icons.arrow_forward_ios,
        size: 20,
      ),
      onTap: () {
        Navigator.pop(context, this.elements);
      },
    ));
  }
}
