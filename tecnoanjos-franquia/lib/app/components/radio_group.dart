import 'package:tecnoanjos_franquia/app/models/pairs.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final List<Pairs> myList;

  final Pairs valueSelected;
  final ValueChanged<Pairs> selected;

  RadioGroup(this.myList,this.valueSelected, this.selected);

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: widget.myList
            .map((data) => Expanded(
                    child: Row(
                  children: [
                    Expanded(
                        child: RadioListTile(
                      title: Text(
                        "${data.second}",
                        style: AppThemeUtils.normalSize(fontSize: 14),
                      ),
                      groupValue:  widget.valueSelected.first,
                      value: data.first,
                      onChanged: (val) {
                        setState(() {
                          widget.selected(data);

                        });
                      },
                    ))
                  ],
                )))
            .toList(),
      ),
    );
  }
}
