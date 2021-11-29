import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../app_bloc.dart';


void showLoadingDialog(bool load) {
  final _appBloc = Modular.get<AppBloc>();
  _appBloc.loadElement.sink.add(load);
}

class _DialogGeneric extends StatelessWidget {
  String title;

  _DialogGeneric({this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width > 450
                  ? 400
                  : MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Material(
                color: Colors.white,
                child: ListBody(
                  children: <Widget>[
                    Container(
                      color: AppThemeUtils.colorPrimary,
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 0),
                          child: Icon(
                            Icons.cloud_download,
                            color: AppThemeUtils.whiteColor,
                            size: 40,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                top: 0, bottom: 10, right: 10, left: 10),
                            child: Text(
                              title ?? "Carregando...",
                              textAlign: TextAlign.center,
                              style: AppThemeUtils.normalBoldSize(
                                  color: AppThemeUtils.whiteColor,
                                  fontSize: 18),
                            )),
                      ],
                    )),
                    Container(
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: Colors.white, width: 1),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin:
                              EdgeInsets.symmetric(vertical: 10),
                              child: LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<
                                    Color>(
                                    AppThemeUtils.colorPrimary),
                                minHeight: 30,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {

      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText
     );
  }
}
