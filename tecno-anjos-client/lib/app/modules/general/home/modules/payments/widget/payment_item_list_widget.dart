import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/calling_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/payments/core/payment_repository.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/payments/models/payment.dart';

import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'package:tecnoanjosclient/app/utils/attendance/attendance_utils.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import '../payments_bloc.dart';

Widget paymentItemListWidget(BuildContext context, Payment payment) {
  return Center(
      child: Slidable(
    actionPane: SlidableStrechActionPane(),
    closeOnScroll: true,
    enabled: true,
    actionExtentRatio: 0.25,
    child: Builder(builder: (contextNew) {
      return InkWell(
          onTap: () {
            Slidable.of(contextNew).open(actionType: SlideActionType.secondary);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Card(child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                     "TOTAL: "+ Utils.moneyFormat(
                                          payment.amount ?? 0.0),
                                      style: AppThemeUtils.normalBoldSize(
                                          color: AppThemeUtils.colorPrimary),textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(children: [Expanded(child:      Text(
                                      StringFile.atendimento +
                                          ': ${payment.attendanceId}',textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppThemeUtils.normalSize(fontSize: 13),
                                    ),),Expanded(child:      Text(
                                      "Horário: " +
                                          ' ${MyDateUtils.parseDateTimeFormat(payment.createdAt, null,format: "HH:mm")}',
                                      overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,
                                      style: AppThemeUtils.normalSize(fontSize: 13),
                                    ),)],)

                                  ],
                                ))),
                      ],
                    ),
                    lineViewWidget()
                  ],
                ))),
          ));
    }),
    secondaryActions:payment.status == PaymentRepository.REFUSED?<Widget>[
      Builder(builder: (contextNew) {
        return IconSlideAction(
          caption: "Pagar",
          color: AppThemeUtils.colorPrimary,
          icon: MaterialCommunityIcons.finance,
          onTap: () {
            var atendanceBloc = Modular.get<AttendanceBloc>();

  atendanceBloc.getDetailsAttendance(payment.attendanceId,(attendance){
    var callingBloc = Modular.get<CallingBloc>();
    callingBloc.callRePlayPayment(context, attendance, payment.amount, (){
      var _paymentBloc = Modular.get<PaymentsBloc>();
      _paymentBloc.getListPaymentPendetes();
    });
  });
          },
        );
      }),
      Builder(builder: (contextNew) {
        return IconSlideAction(
          caption: StringFile.detalhe,
          color: AppThemeUtils.whiteColor,
          icon: Icons.assessment,
          onTap: () {
            var atendanceBloc = Modular.get<AttendanceBloc>();
            atendanceBloc.getDetailsAttendance(payment.attendanceId,(attendance){
              AttendanceUtils.pushNamed(
                  context, ConstantsRoutes.CALL_DETAILS_ATTENDANCE,
                  arguments:attendance);
            });

          },
        );
      }),
    ]: <Widget>[

      Builder(builder: (contextNew) {
        return IconSlideAction(
          caption: StringFile.detalhe,
          color: AppThemeUtils.whiteColor,
          icon: Icons.assessment,
          onTap: () {
            var atendanceBloc = Modular.get<AttendanceBloc>();
            atendanceBloc.getDetailsAttendance(payment.attendanceId,(attendance){
              AttendanceUtils.pushNamed(
                  context, ConstantsRoutes.CALL_DETAILS_ATTENDANCE,
                  arguments:attendance);
            });

          },
        );
      }),
    ],
  ));
}
