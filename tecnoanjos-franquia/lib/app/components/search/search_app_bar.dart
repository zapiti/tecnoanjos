import 'dart:math';

import 'package:flutter/material.dart';
import '../../components/search/search_bloc.dart';
import '../../components/search/searcher.dart';

import 'app_bar_painter.dart';
import 'default_bloc.dart';
import 'filter.dart';
import 'search_widget.dart';

class SearchAppBar<T> extends StatefulWidget implements PreferredSizeWidget {
  final Searcher searcher = DefaultBloc() as Searcher;
  final Filter<T> filter;
  final Widget title;
  final ValueChanged<String> changeLabel;
  final bool centerTitle;
  final IconThemeData iconTheme;
  final Color backgroundColor;
  final Color searchBackgroundColor;
  final Color searchElementsColor;
  final String hintText;
  final bool flattenOnSearch;
  final TextCapitalization capitalization;
  final List<Widget> actions;
  final int _searchButtonPosition;
  final bool containsSearch;
  final Widget bottom;
  final double height;
  final TabController tabController;
  final TextInputType keyboardType;

  SearchAppBar({
    this.filter,
    this.title,
    this.keyboardType,
    this.tabController,
    this.changeLabel,
    this.height,
    this.centerTitle = false,
    this.iconTheme,
    this.backgroundColor,
    this.searchBackgroundColor,
    this.searchElementsColor,
    this.hintText,
    this.bottom,
    this.containsSearch = true,
    this.flattenOnSearch = false,
    this.capitalization = TextCapitalization.none,
    this.actions = const <Widget>[],
    int searchButtonPosition,
  }) : _searchButtonPosition = (searchButtonPosition != null &&
                (0 <= searchButtonPosition &&
                    searchButtonPosition <= actions.length))
            ? searchButtonPosition
            : max(actions.length, 0);

  // search button position defaults to the end.

  @override
  Size get preferredSize => Size.fromHeight(height ?? 56.0);

  _SearchAppBarState<T> createState() => _SearchAppBarState<T>();
}

class _SearchAppBarState<T> extends State<SearchAppBar<T>>
    with SingleTickerProviderStateMixin<SearchAppBar<T>> {
  SearchBloc<T> bloc;
  double _rippleStartX, _rippleStartY;
  AnimationController _controller;
  Animation _animation;
  double _elevation = 4.0;

  @override
  void initState() {
    super.initState();
    bloc = SearchBloc<T>(
      searcher: widget.searcher,
      filter: widget.filter,
    );
    _controller =
        AnimationController(vsync: this,duration: Duration(milliseconds: 150));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener(animationStatusListener);
    widget?.tabController?.addListener(() {
      cancelSearch();
    });
  }

  animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      bloc?.setSearchMode(true);

      if (widget.flattenOnSearch) _elevation = 0.0;
    }
  }

  void onSearchTapUp(TapUpDetails details) {
    _rippleStartX = details.globalPosition.dx;
    _rippleStartY = details.globalPosition.dy;
    _controller.forward();
  }

  void cancelSearch() {
    bloc?.setSearchMode(false);
    bloc?.onClearSearchQuery();
    _elevation = 4.0;
    _controller.reverse();
  }

  Future<bool> _onWillPop(bool isInSearchMode) async {
    if (isInSearchMode) {
      cancelSearch();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
        stream: bloc?.isInSearchMode,
        builder: (context, snapshot) {
          final isInSearchMode = snapshot.data ?? false;
          return WillPopScope(
            onWillPop: () => _onWillPop(isInSearchMode),
            child: Stack(
              children: [
                _buildAppBar(context),
                _buildAnimation(screenWidth),
                _buildSearchWidget(isInSearchMode, context),
              ],
            ),
          );
        });
  }

  AppBar _buildAppBar(BuildContext context) {
    final searchButton =
        widget.containsSearch ? _buildSearchButton(context) : null;
    final increasedActions = List<Widget>();
    increasedActions.addAll(widget.actions);
    if (searchButton != null) {
      increasedActions.insert(widget._searchButtonPosition, searchButton);
    }
    return AppBar(
      backgroundColor: widget.backgroundColor ?? Theme.of(context).primaryColor,
      iconTheme: widget.iconTheme ?? Theme.of(context).iconTheme,
      title: widget.title,
      bottom: widget.bottom,
      elevation: _elevation,
      centerTitle: widget.centerTitle,
      actions: increasedActions,
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return GestureDetector(
      child: IconButton(
        onPressed: null,
        icon: Icon(
          Icons.search,
          color: widget.iconTheme?.color ?? Theme.of(context).iconTheme.color,
        ),
      ),
      onTapUp: onSearchTapUp,
    );
  }

  AnimatedBuilder _buildAnimation(double screenWidth) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: AppBarPainter(
            containerHeight: 56,
            center: Offset(_rippleStartX ?? 0, _rippleStartY ?? 0),
            // increase radius in % from 0% to 100% of screenWidth
            radius: _animation.value * screenWidth,
            context: context,
            color: widget.searchBackgroundColor ?? Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildSearchWidget(bool isInSearchMode, BuildContext context) {
    return isInSearchMode
        ? SearchWidget(
            bloc: bloc,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            color: widget.searchElementsColor ?? Theme.of(context).primaryColor,
            onCancelSearch: cancelSearch,
            valueChanged: widget.changeLabel,
            textCapitalization: widget.capitalization,
            hintText: widget.hintText,
          )
        : Container();
  }
}
