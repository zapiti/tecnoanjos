import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import 'divider/line_view_widget.dart';

TextEditingController controllPlussLessButton = TextEditingController();

buildPlusLessButtom(BuildContext context, Function(int) alterations) {
  controllPlussLessButton.selection =
      TextSelection.fromPosition(
          TextPosition(offset: controllPlussLessButton.text.length));
  int getValueController(TextEditingController controller) {
    var value =
    controller.value.text.isEmpty ? 0 : int.parse(controller.value.text);
    return value;
  }

  return PlusLessComponent(
      controller: controllPlussLessButton,
      containsValue: getValueController(controllPlussLessButton) >= 0,
      actionAdd: () {
        int value = getValueController(controllPlussLessButton);

        int qtd = value + 1;
        var number = qtd < 10 ? "0$qtd" : "$qtd";
        controllPlussLessButton.text = "$number";


        alterations(qtd);
        // NewOrderedBloc()
        //     .updateValue(_product, qtd, _scaffoldKey, desableMessage: true);
      },
      actionRemove: () {
        int value = getValueController(controllPlussLessButton);
        var qtd = 0;
        if (value > 0) {
          qtd = value - 1;
          var number = qtd < 10 ? "0$qtd" : "$qtd";
          controllPlussLessButton.text = "$number";
        }
        alterations(qtd);
      },
      changedValue: (valueChange) {
        int value2 = valueChange.isEmpty ? 0 : int.parse(valueChange);
        controllPlussLessButton.text = "$value2";
        alterations(value2);
      });
}

// ignore: must_be_immutable
class PlusLessComponent extends StatefulWidget {
 final  TextEditingController controller;
 final  Function actionAdd;
 final Function actionRemove;
 final  ValueChanged<String> changedValue;
 var  containsValue  =  false;

  PlusLessComponent({this.controller,
    this.actionAdd,
    this.actionRemove,
    this.changedValue,
    this.containsValue });

  @override
  _PlusLessComponentState createState() => _PlusLessComponentState();
}

class _PlusLessComponentState extends State<PlusLessComponent> {
  @override
  Widget build(BuildContext context) {
    return !widget.containsValue ? ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: AppThemeUtils.colorPrimary, shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.all(Radius.circular(4)),
      )),
      onPressed: () {
        widget.controller.text = 0.toString();
        widget.changedValue(0.toString());
        if (!widget.containsValue) {
          setState(() {
            widget.containsValue = !widget.containsValue;
          });
        }
        widget.actionAdd();
      },
      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
      child: Text(
        StringFile.addQuantidade,
        style: TextStyle(
            color: AppThemeUtils.whiteColor,
            fontSize: 16),
      ),

    ) : Container(
        height: 86,
        width: 100,
        child: Center(
            child: Container(
              height: widget.containsValue ? 86 : 37,
              width: widget.containsValue ? 100 : 37,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  !widget.containsValue
                      ? SizedBox()
                      : Container(
                      child: TextField(

                        controller: widget.controller,
                        maxLines: 1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: (text) {
                          if ((int.tryParse(widget.controller.text) ?? 0) <=
                              0) {
                            setState(() {
                              widget.containsValue = !widget.containsValue;
                            });
                          }
                          widget.changedValue(text);
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),

                            border: InputBorder.none),
                      )),
                  !widget.containsValue ? SizedBox() : lineViewWidget(
                      height: 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      !widget.containsValue
                          ? SizedBox()
                          : Expanded(
                          child: InkWell(
                            onTap: () {
                              if ((int.tryParse(widget.controller.text) ?? 0) <=
                                  1) {
                                setState(() {
                                  widget.containsValue = !widget.containsValue;
                                });
                              }
                              widget.actionRemove();
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              child: Icon(
                                Icons.remove,
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                                size: 18,
                              ),
                            ),
                          )),
                      /**/
                      Expanded(
                          child: Container(

                              decoration: _boxDecoration(
                                  color: !widget.containsValue
                                      ? Colors.transparent
                                      : Theme
                                      .of(context)
                                      .primaryColor,
                                  borderWidth: 0),
                              child: InkWell(
                                onTap: () {
                                  if (!widget.containsValue) {
                                    setState(() {
                                      widget.containsValue =
                                      !widget.containsValue;
                                    });
                                  }
                                  widget.actionAdd();
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  child: Icon(
                                    Icons.add,
                                    color: !widget.containsValue
                                        ? Theme
                                        .of(context)
                                        .primaryColor
                                        : AppThemeUtils.black,
                                    size: 18,
                                  ),
                                ),
                              ))),
                    ],
                  )
                ],
              ),
              decoration: _boxDecoration(),
            )));
  }
}

Widget plusLessSimpleComponent(BuildContext context,
    {TextEditingController controller,
      Function actionAdd,
      Function actionRemove,
      ValueChanged<String> changedValue}) {
  return Container(
      height: 45,
      width: 100,
      child: Center(
          child: Container(
            height: 37,
            width: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                    onTap: actionRemove,
                    child: Container(
                      width: 35,
                      height: 35,
                      child: Icon(
                        Icons.remove,
                        color: AppThemeUtils.black,
                        size: 18,
                      ),
                    )),
                Expanded(
                    child: Container(
                        child: TextField(

                          controller: controller,
                          maxLines: 1,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3),
                          ],
                          onChanged: changedValue,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),

                              border: InputBorder.none),
                        ))),
                Container(
                    child: InkWell(
                      onTap: actionAdd,
                      child: Container(
                        width: 35,
                        height: 35,
                        child: Icon(
                          Icons.add,
                          color: AppThemeUtils.black,
                          size: 18,
                        ),
                      ),
                    )),
              ],
            ),
            decoration: _boxDecoration(),
          )));
}

BoxDecoration _boxDecoration(
    {Color color = Colors.white, double borderWidth = 1}) {
  return new BoxDecoration(
    color: color,
    borderRadius: BorderRadius.all(Radius.circular(5)),
    border: Border.all(color: Color(0xffE6E6E6), width: borderWidth),
    shape: BoxShape.rectangle,
  );
}
