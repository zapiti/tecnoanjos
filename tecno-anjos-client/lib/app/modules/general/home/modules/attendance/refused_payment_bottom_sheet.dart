import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/wallet_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/widget/wallet_bottom_sheet.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

Future<void> showBottomSheetRefuzedPayment(
    {BuildContext context, Function(Wallet) onConfirm, Attendance attendance, double pendingAmount}) async {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    backgroundColor: Colors.white,
    context: context,
    builder: (context) => _PaymentRefuzedBottomSheet(
      onConfirm: onConfirm,
      attendance: attendance,pendingAmount:pendingAmount
    ),
  );
}

class _PaymentRefuzedBottomSheet extends StatefulWidget {
  final Function(Wallet) onConfirm;
  final Attendance attendance;

  final double pendingAmount;
  _PaymentRefuzedBottomSheet({this.onConfirm, this.attendance, this.pendingAmount});

  @override
  _PaymentRefuzedBottomSheetState createState() =>
      _PaymentRefuzedBottomSheetState();
}

class _PaymentRefuzedBottomSheetState
    extends State<_PaymentRefuzedBottomSheet> {
  var walletBloc = Modular.get<WalletBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletBloc.getOneWallet();
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
              "Ainda á um pagamento pendente",
              style: AppThemeUtils.normalBoldSize(
                  fontSize: 20, color: AppThemeUtils.colorPrimary),
            ),
            padding: EdgeInsets.all(10),
          ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                child: Text(
                  "Tecnoanjo: ${widget.attendance.userTecno.name}",
                  style: AppThemeUtils.normalBoldSize(fontSize: 20),
                ),
                padding: EdgeInsets.all(10),
              ),

              lineViewWidget(),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            child: Text(
              "#${widget.attendance.id}- Descrição:   ${widget.attendance.description ?? "Sem descrição"}",
              style: AppThemeUtils.normalSize(fontSize: 14),textAlign: TextAlign.start,
            ),
            padding: EdgeInsets.all(10),
          ),

          lineViewWidget(),
          StreamBuilder<Wallet>(
            stream: walletBloc.oneWalletSubject,
            builder: (context, snapshot) => titleDescriptionBigMobileWidget(
                context,
                iconData: Icons.credit_card,
                title: snapshot.data?.description ?? "Não possui cartão?",
                description: snapshot.data?.number ?? "Adicione um novo cartão",
                customIcon: ElevatedButton(
                  onPressed: () {

                    showBottomSheetWallet(context,
                                  (selected) {
                                    walletBloc.oneWalletSubject.sink.add(
                                    selected);
                              });

                  },
                  style: ElevatedButton.styleFrom(
                      primary: AppThemeUtils.colorPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          side: BorderSide(color: AppThemeUtils.whiteColor))),
                  child: Container(
                      height: 45,
                      child: Center(
                          child: Text(
                        snapshot.data?.id == null
                            ? StringFile.adicionar
                            : StringFile.trocar,
                        style: AppThemeUtils.normalSize(
                            color: AppThemeUtils.whiteColor),
                      ))),
                )),
          ),    lineViewWidget(bottom: 0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Data: ${MyDateUtils.parseDateTimeFormat(widget.attendance.createdAt, widget.attendance.createdAt)}",
                        style: AppThemeUtils.normalBoldSize(),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                  Expanded(
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Valor pendente",
                          style: AppThemeUtils.normalBoldSize(fontSize: 14),
                        ),
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${MoneyMaskedTextController(initialValue: widget.pendingAmount ?? 0.0, leftSymbol: "R\$").text}",
                          style: AppThemeUtils.normalBoldSize(color: AppThemeUtils.colorPrimary,fontSize: 18),
                        ),
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                  ],)
                  )
                ],
              ),
          lineViewWidget(bottom: 20),
          Container(
              height: 45,
              margin: EdgeInsets.only(right: 20, left: 20, bottom: 40),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        height: 45,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: AppThemeUtils.lightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                            child: Text(
                              "CANCELAR",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
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
                              primary: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              )),
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onConfirm(walletBloc.oneWalletSubject.stream.value);

                          },
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                          child: Text(
                            "Pagar",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )),
                  )
                ],
              ))
        ]));
  }
}
