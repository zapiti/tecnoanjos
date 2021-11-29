
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';

import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/string/string_extension.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

Future<void> showDateBottomSheet(BuildContext context,
    {Function(DateTime) onDate, DateTime initialDate}) async {
  return   showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0), topRight: Radius.circular(0))),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) =>
        _PaymentBottomSheet(
          onDate: onDate,initialDate:initialDate
        ),
  );
}

class _PaymentBottomSheet extends StatefulWidget {

  final Function(DateTime) onDate;
  final DateTime initialDate;
  _PaymentBottomSheet({
    this.onDate, this.initialDate});

  @override
  __PaymentBottomSheetState createState() => __PaymentBottomSheetState();
}

class __PaymentBottomSheetState extends State<_PaymentBottomSheet> {
  var walletBloc = Modular.get<WalletBloc>();
  DateTime date;
  DateTime initDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletBloc.getOneWallet();
    MyDateUtils.getTrueTime().then((value) {
      setState(() {
        date = widget.initialDate ?? (value ?? DateTime.now()).add(Duration(minutes: 30));
        initDate = widget.initialDate  ?? (value ?? DateTime.now()).add(Duration(minutes: 30));
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, right: 10, left: 10,bottom: 20),
                child: Text(
                  "Agendar um horário",
                  style: AppThemeUtils.normalSize(
                      fontSize: 26, ),textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(10),
              ),
              lineViewWidget(),
              InkWell(onTap: () {
                showDatePicker(
                    context: context,
                    initialDate: date,
                    locale: Locale('pt', 'BR'),
                    firstDate: initDate,
                    lastDate: DateTime(2101)).then((myDate) {
                  if (myDate != null) {
                    final pickedTime = DateTime(myDate.year, myDate.month, myDate.day, date.hour, date.minute).toLocal();
                    setState(() {
                      date = pickedTime;
                    });
                  }
                });
              }, child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20, right: 10, left: 10,bottom: 20),
                child: Text(
    MyDateUtils.converStringServer(date,date,format:"EE, dd <> MMM")?.replaceAll("<>", "de")?.capitalize()  ?? "",
                  style: AppThemeUtils.normalSize(
                    fontSize: 20, ),textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(10),
              ),),
              lineViewWidget(width: 300),
              InkWell(onTap: () {
                showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: date.hour,minute: date.minute),
                    cancelText: StringFile.cancelar,
                    helpText: "Selecione o horário")
                    .then((time) {
                  if (time != null) {
                    if(time.hour == date.hour && time.minute < date.minute + 30){
                      Flushbar(
                        flushbarStyle: FlushbarStyle.GROUNDED,
                        flushbarPosition: FlushbarPosition.TOP,
                        backgroundColor: AppThemeUtils.colorPrimary,
                        message: StringFile.agendamentoAtencedencia,
                        icon: Icon(
                          Icons.info_outline,
                          size: 28.0,
                          color: AppThemeUtils.whiteColor,
                        ),
                        duration: Duration(seconds: 5),
                      )..show(context);
                    }else if (time.hour < initDate.hour && date.day == initDate.day){
                      Flushbar(
                        flushbarStyle: FlushbarStyle.GROUNDED,
                        flushbarPosition: FlushbarPosition.TOP,
                        backgroundColor: AppThemeUtils.colorPrimary,
                        message: StringFile.agendamentoAtencedencia,
                        icon: Icon(
                          Icons.info_outline,
                          size: 28.0,
                          color: AppThemeUtils.whiteColor,
                        ),
                        duration: Duration(seconds: 5),
                      )..show(context);
                    }else{
                      final pickedTime = DateTime(date.year, date.month, date.day, time.hour, time.minute).toLocal();

                      setState(() {
                        date = pickedTime;
                      });
                    }

                  }
                });
              }, child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20, right: 10, left: 10,bottom: 20),
                child: Text(
                  MyDateUtils.converStringServer(date,date,format:"HH:mm") ?? "",
                  style: AppThemeUtils.normalSize(
                    fontSize: 20, ),textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(10),
              ),),

              lineViewWidget(bottom: 30),
              Container(
                  height: 45,
                  margin: EdgeInsets.only(
                      right: 20, left: 20, bottom: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: 45,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: AppThemeUtils.lightGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)))),
                                onPressed: () {
                                  widget.onDate(null);
                                },
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                child: Text(
                                  "CANCELAR",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16),
                                ))),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary:
                                  Theme
                                      .of(context)
                                      .primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4)),
                                  )),
                              onPressed: () {
                                widget.onDate(date);
                              },
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                              child: Text(
                                "AGENDAR",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            )),
                      )
                    ],
                  ))
            ]));
  }
}
