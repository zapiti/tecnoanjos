import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tecno_anjos_landing/app/components/search/search_bloc.dart';

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
                  _buildTextField(),
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

  Widget _buildTextField() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 8.0,
        ),
        child: StreamBuilder<String>(
          stream: bloc.searchQuery,
          builder: (context, snapshot) {
            TextEditingController controller = _getController(snapshot);
            return TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(80),
              ],
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 12.0),
                hintText: hintText,
              ),
              keyboardType: keyboardType,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              style: GoogleFonts.ubuntu(fontSize: 18.0),
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
