
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';


class MultiSelectChip<T> extends StatefulWidget {
  final List<T> reportList;
  final Function(dynamic) onSelectionChanged;
  final List<T> selectedChoices;
  final bool disableClick;
  final Color bgColor;
  final bool isRemoved;

  MultiSelectChip(this.reportList,
      {this.onSelectionChanged,
      this.selectedChoices,
      this.isRemoved = false,
      this.bgColor,
      this.disableClick = false});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState<T> extends State<MultiSelectChip> {

  List selectedChoices = [];

  @override
  void initState() {
    super.initState();
    selectedChoices = widget.selectedChoices ?? [];
  }

  _buildChoiceList() {
    List<Widget> choices = List.empty();

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedShadowColor: Theme.of(context).primaryColor,
          selectedColor: Theme.of(context).primaryColor,
          disabledColor: Theme.of(context).primaryColor,
          backgroundColor: widget.bgColor ?? Colors.grey[400],
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item?.name ?? "--",
                style: AppThemeUtils.normalBoldSize(color: Colors.white),
              ),
              widget.isRemoved
                  ? Container(
                      height: 30,
                      width: 30,
                      child: Center(
                          child: ElevatedButton(
                              child: Icon(
                                Icons.cancel,
                                color: AppThemeUtils.whiteColor,
                              ),
                              onPressed: () {

                                selectedChoices.remove(item);
                                widget.reportList.remove(item);
                              })))
                  : SizedBox()
            ],
          ),
          selected: selectedChoices.firstWhere(
                  (element) => element?.name == item?.name,
                  orElse: () => null) !=
              null,
          onSelected: (selected) {
            if (!widget.disableClick) {
              setState(() {
                var element = selectedChoices.firstWhere(
                    (element) => element.name == item.name,
                    orElse: () => null);
                element != null
                    ? selectedChoices.remove(element)
                    : selectedChoices.add(item);
                var list = ObjectUtils.parseToObjectList<T>(selectedChoices);
                widget.onSelectionChanged(list);
              });
            }
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

//
// class MultiSelectChipQualifications<Qualifications> extends StatefulWidget {
//   final List<Qualifications> reportList;
//   final Function(dynamic) onSelectionChanged;
//   List<Qualifications> selectedChoices;
//   final bool disableClick;
//
//   MultiSelectChipQualifications(this.reportList,
//       {this.onSelectionChanged,
//         this.selectedChoices,
//         this.disableClick = false});
//
//   @override
//   _MultiSelectChipQualificationsState createState() =>
//       _MultiSelectChipQualificationsState();
// }
//
// class _MultiSelectChipQualificationsState<T>
//     extends State<MultiSelectChipQualifications> {
//   // String selectedChoice = "";
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   _buildChoiceList() {
//     List<Widget> choices = List();
//
// //     InputChip(
// //       padding: EdgeInsets.all(2.0),showCheckmark: false,
// //
// //       label: Text('James Watson'),tooltip: "Editar",
// //       selected: true,
// //       selectedColor: AppThemeUtils.colorPrimary,
// //       onSelected: (bool selected) {
// //
// //       },
// // // onPressed: () {
// // //   //
// // // },
// //
// //     )
//     var listItens = [];
//
//     if (widget.reportList is List) {
//       if (widget.reportList.length > widget.selectedChoices.length) {}
//       widget.selectedChoices.forEach((point) {
//         var item = widget.reportList
//             .firstWhere((e) => e.name == point.name, orElse: () => null);
//         if (item == null) {
//           listItens.add(point);
//         }
//       });
//       if (listItens.length != 0) {
//         listItens.forEach((point) {
//           widget.reportList.add(point);
//         });
//       }
//     }
//
//     widget.reportList.forEach((item) {
//       Qualification selectedItem = widget.selectedChoices.firstWhere(
//               (element) => element?.name == item?.name,
//           orElse: () => null);
//       choices.add(Container(
//         padding: const EdgeInsets.all(2.0),
//         child:
//         InputChip(
//           selectedShadowColor: Theme.of(context).primaryColor,
//           selectedColor: Theme.of(context).primaryColor,
//           disabledColor: Theme.of(context).primaryColor,
//           onDeleted: item?.ishours == true
//               ? null
//               : () {
//             var myQtd = (selectedItem ?? item)?.quantity ?? 0;
//             controllPlussLessButton.text =
//             myQtd < 10 ? "0$myQtd" : "$myQtd";
//             showUpdateValues(item ?? selectedItem, context: context,
//                 positiveCallback: (qtd) {
//                   var myqtd = int.tryParse(qtd) ?? 0;
//                   if (myqtd == 0) {
//                     item?.quantity = myqtd;
//                     selectedItem?.quantity = myqtd;
//                     updateQualification(item, selectedItem);
//                   } else {
//                     item?.quantity = myqtd;
//                     selectedItem?.quantity = myqtd;
//                     var myItem = widget.selectedChoices.firstWhere(
//                             (element) =>
//                         element?.id == (item?.id ?? selectedItem?.id),
//                         orElse: () => null);
//
//                     setState(() {
//                       if (myItem != null) {
//                         widget.selectedChoices.remove(myItem);
//                       }
//
//                       widget.selectedChoices.add(item);
//                       List<Qualification> list =
//                       ObjectUtils.parseToObjectList<Qualification>(
//                           widget.selectedChoices)
//                           .toList();
//                       var temp = list
//                           .where((element) => element.origin != "OLDITEMS")
//                           .toList();
//                       widget.onSelectionChanged(temp);
//                     });
//                   }
//                 });
//           },
//           showCheckmark: false,
//           backgroundColor: Colors.grey[400],
//           tooltip: "Editar",
//           deleteIcon: item?.ishours == true
//               ? null
//               : Icon(MaterialCommunityIcons.circle_edit_outline),
//           label: Text(
//             item?.name ?? "--",
//             style: AppThemeUtils.normalBoldSize(color: Colors.white),
//           ),
//           selected: selectedItem != null,
//           avatar: CircleAvatar(
//             backgroundColor: AppThemeUtils.black,
//             child: AutoSizeText(
//               selectedItem?.quantity?.toString() ?? "0",
//               maxLines: 1,
//               minFontSize: 6,
//               style: AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),
//             ),
//           ),
//           onSelected: (selected) {
//             if (!widget.disableClick) {
//               updateQualification(item, selectedItem);
//             }
//           },
//         ),
//       ));
//     });
//
//     return choices;
//   }
//
//   void updateQualification(Qualification item, Qualification selectedItem) {
//     setState(() {
//       if ((item?.quantity?.toString() ?? "0") == "0") {
//         item?.quantity = 1;
//       }
//       if ((selectedItem?.quantity?.toString() ?? "0") == "0") {
//         selectedItem?.quantity = 1;
//       }
//       if (selectedItem != null) {
//         widget.selectedChoices.remove(selectedItem);
//       } else {
//         widget.selectedChoices.add(item);
//       }
//
//       List<Qualification> list =
//       ObjectUtils.parseToObjectList<Qualification>(widget.selectedChoices)
//           .toList();
//
//       widget.onSelectionChanged(list);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: _buildChoiceList(),
//     );
//   }
// }
