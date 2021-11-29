import 'package:flutter/material.dart';
import '../../utils/theme/app_theme_utils.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;
  List<String> selectedChoices;
  MultiSelectChip(this.reportList,
      {this.onSelectionChanged, this.selectedChoices});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices;

  @override
  void initState() {
    super.initState();
    selectedChoices = widget.selectedChoices ?? [];
  }

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedShadowColor: Theme.of(context).primaryColor,
          selectedColor: Theme.of(context).primaryColor,
          disabledColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.grey[400],
          label: Text(
            item,
            style: AppThemeUtils.normalBoldSize(color: Colors.white),
          ),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
