import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/service_prod.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';


Future<void> showBottomSheetServices(
    BuildContext context, List<ServiceProd> listServices,
    {Function(List<ServiceProd>) selected}) async {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) =>
        _ServicesBottomSheet(listServices: listServices, selected: selected),
  );
}

class _ServicesBottomSheet extends StatefulWidget {
  final List<ServiceProd> listServices;
  final Function(List<ServiceProd>) selected;

  _ServicesBottomSheet({this.listServices, this.selected});

  @override
  _ServicesBottomSheetState createState() => _ServicesBottomSheetState();
}

class _ServicesBottomSheetState extends State<_ServicesBottomSheet> {
  var walletBloc = Modular.get<WalletBloc>();
  final formKey = GlobalKey<FormState>();
  List<ServiceProd> formValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formValue = widget.listServices;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
            children: [
          Container(
            margin: EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Text(
              "",
              textAlign: TextAlign.center,
              style: AppThemeUtils.normalBoldSize(
                  fontSize: 18, color: AppThemeUtils.colorPrimary),
            ),
            padding: EdgeInsets.all(10),
          ),
          // Container(
          //   margin: EdgeInsets.all(10),
          //   child: Text(
          //     "Subtitulo",
          //     style: AppThemeUtils.normalSize(),
          //   ),
          //   padding: EdgeInsets.all(10),
          // ),
          lineViewWidget(),
          Container(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  FormField<List<ServiceProd>>(

                    initialValue: formValue,
                    onSaved: (val) => setState(() => formValue = val),
                    validator: (value) {
                      if (value?.isEmpty ?? value == null) {
                        return 'Selecione o serviço que mais encaixa na sua necessidade!';
                      }
                      // if (value.length > 5) {
                      //   return "Can't select more than 5 categories";
                      // }
                      return null;
                    },
                    builder: (state) {
                      formValue = state.value;
                      return Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: ChipsChoice<ServiceProd>.multiple(
                              value: state.value,
                              onChanged: (val) => state.didChange(val),
                              choiceItems:
                                  C2Choice.listFrom<ServiceProd, ServiceProd>(
                                source: [],
                                value: (i, v) => v,
                                label: (i, v) =>
                                    "${v.name} (${MoneyMaskedTextController(leftSymbol: "R\$", initialValue: v.price).text})",
                              ),
                              choiceStyle: C2ChoiceStyle(
                                color: AppThemeUtils.colorPrimary,
                                borderOpacity: .3,
                              ),
                              choiceActiveStyle: C2ChoiceStyle(
                                color: AppThemeUtils.colorPrimary,
                                brightness: Brightness.dark,
                              ),
                              wrapped: true,
                            ),
                          ),
                          lineViewWidget(),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 10, 15, 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        state.errorText ??
                                            state.value.length.toString() +
                                                ' selecionados',
                                        style: AppThemeUtils.normalSize(
                                            color: state.hasError
                                                ? AppThemeUtils.colorGrayLight
                                                : AppThemeUtils.darkGrey),
                                      ))),
                              state.errorText != null
                                  ? SizedBox()
                                  : Expanded(
                                      child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 10, 15, 10),
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "Total: ${MoneyMaskedTextController(leftSymbol: "R\$", initialValue: state.value?.fold(0, (previousValue, element) => element.price + previousValue) ?? 0).text}",
                                            style: AppThemeUtils.normalBoldSize(
                                                color:
                                                    AppThemeUtils.colorPrimary),
                                            textAlign: TextAlign.end,
                                          )))
                            ],
                          )
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),

          lineViewWidget(),
          Container(
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () {
                  widget.selected(formValue ?? []);
                },
                style: ElevatedButton.styleFrom(
                    primary: AppThemeUtils.colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        side: BorderSide(color: AppThemeUtils.colorError))),
                child: Container(
                    height: 45,
                    child: Center(
                        child: Text(
                      StringFile.confirmar,
                      style: AppThemeUtils.normalSize(
                          color: AppThemeUtils.whiteColor),
                    ))),
              ))
        ]));
  }
}

