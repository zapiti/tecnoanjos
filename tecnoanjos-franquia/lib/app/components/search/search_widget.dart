import 'package:tecnoanjos_franquia/app/components/tectfields/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/search/search_bloc.dart';

class SearchWidget extends StatelessWidget implements PreferredSizeWidget {
  final SearchBloc bloc;
  final Color color;
  final VoidCallback onCancelSearch;
  final TextCapitalization textCapitalization;
  final ValueChanged<String> valueChanged;
  final String hintText;
  final TextInputType keyboardType;

  SearchWidget({
    @required this.bloc,
    @required this.onCancelSearch,
    this.color,
    this.keyboardType,
    this.textCapitalization,
    this.valueChanged,
    this.hintText,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    // to handle notches properly
    return SafeArea(
      top: true,
      child: GestureDetector(
        child: Container(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildBackButton(),
                  _buildCustomTextField(),
                  _buildClearButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return StreamBuilder<String>(
      stream: bloc.searchQuery,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.isEmpty != false)
          return Container();
        return IconButton(
          icon: Icon(
            Icons.close,
            color: color,
          ),
          onPressed: () {
            bloc.onClearSearchQuery();
            valueChanged("");
          },
        );
      },
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: color),
      onPressed: onCancelSearch,
    );
  }

  Widget _buildCustomTextField() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 8.0,
        ),
        child: StreamBuilder<String>(
          stream: bloc.searchQuery,
          builder: (context, snapshot) {
            TextEditingController controller = _getController(snapshot);
            return CustomTextField(
              controller: controller,
              autofocus: true,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization ?? TextCapitalization.none,

              onChanged: (value) {
                valueChanged(value);
                bloc.onSearchQueryChanged(value);
              },
            );
          },
        ),
      ),
    );
  }

  TextEditingController _getController(AsyncSnapshot<String> snapshot) {
    final controller = TextEditingController();
    controller.value = TextEditingValue(text: snapshot.data ?? '');
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text?.length ?? 0),
    );
    return controller;
  }
}
