import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:tecnoanjos_franquia/app/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjos_franquia/app/modules/attendance/model/attendance.dart';
import 'package:tecnoanjos_franquia/app/modules/payment/model/payment.dart';
import 'package:tecnoanjos_franquia/app/modules/payment/payment_bloc.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/model/profile.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/tecno_bloc.dart';
import 'package:tecnoanjos_franquia/app/utils/date_utils.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjos_franquia/app/utils/utils.dart';

class PaymentTable extends StatefulWidget {
  @override
  _PaymentTableState createState() => _PaymentTableState();
}

class _PaymentTableState extends State<PaymentTable> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;
  final paymentBloc = Modular.get<PaymentBloc>();

  @override
  void initState() {
    super.initState();
    paymentBloc.getListPayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      color: Colors.white,
      child: StreamBuilder<List<Payment>>(
          stream: paymentBloc.listPaymentSubject,
          builder: (context, snapshot) => HorizontalDataTable(
                leftHandSideColumnWidth: 200,
                rightHandSideColumnWidth: 1200,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: (context, index) =>
                    _generateFirstColumnRow(context, index, snapshot.data),
                rightSideItemBuilder: (context, index) =>
                    _generateRightHandSideColumnRow(
                        context, index, snapshot.data),
                itemCount: snapshot.data?.length ?? 0,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                ),
                leftHandSideColBackgroundColor: Colors.white,
                rightHandSideColBackgroundColor: Colors.white,
                enablePullToRefresh: true,
                refreshIndicator: const WaterDropHeader(),
                refreshIndicatorHeight: 60,
                onRefresh: () async {
                  //Do sth
                  await Future.delayed(const Duration(milliseconds: 500));
                  _hdtRefreshController.refreshCompleted();
                },
                htdRefreshController: _hdtRefreshController,
              )),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Tecnico', 200),
      _getTitleItemWidget('Cliente', 200),
      _getTitleItemWidget('Status', 130),
      _getTitleItemWidget('Valor á pagar', 200),
      _getTitleItemWidget('Início', 200),
      _getTitleItemWidget('Fim', 200),
      // _getTitleItemWidget('Pendencias', 200),
   _getTitleItemWidget('Ação', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(
      BuildContext context, int index, List<Payment> listAttendance) {
    return Container(
      child: Text(listAttendance[index].techName ?? ""),
      width: 200,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(
      BuildContext context, int index, List<Payment> listAttendance) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(listAttendance[index].clientName ?? ""),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Row(
            children: <Widget>[
              // Icon(
              //     !user[index].isOnline
              //         ? Icons.wifi_off
              //         : Icons.wifi,
              //     color:
              //     !user[index].isOnline ? Colors.red : Colors.green),
              Text(Utils.statusToPayment(listAttendance[index].status))
            ],
          ),
          width: 130,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(MoneyMaskedTextController( initialValue: listAttendance[index].totalToPay ?? 0.0,leftSymbol: "R\$").text),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(MyDateUtils.parseDateTimeFormat(
              listAttendance[index].dateInit,
              format: "dd/MM/yyyy  HH:mm")),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(MyDateUtils.parseDateTimeFormat(
              listAttendance[index].dateEnd,
              format: "dd/MM/yyyy HH:mm")),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),

        SizedBox(),
        // Container(
        //   child: FlatButton(
        //       onPressed: () {},
        //       child: Text(
        //         "Pagar",
        //         style: AppThemeUtils.normalSize(
        //             color: Theme.of(context).primaryColor),
        //       ),
        //       shape: RoundedRectangleBorder(
        //           borderRadius: new BorderRadius.circular(7.0),
        //           side: BorderSide(color: Theme.of(context).primaryColor))),
        //   width: 100,
        //   height: 52,
        //   padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        //   alignment: Alignment.centerLeft,
        // ),
      ],
    );
  }
}
