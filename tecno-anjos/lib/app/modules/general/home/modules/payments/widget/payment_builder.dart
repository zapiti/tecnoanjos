import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/load/load_elements.dart';
import 'package:tecnoanjostec/app/components/ntp_time/ntp_time_component.dart';
import 'package:tecnoanjostec/app/components/page/default_tab_page.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/models/payment.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/payments_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/payments/widget/payment_item_list_widget.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';

import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';

import '../../../../../../app_bloc.dart';



class PaymentBuilder {
  var _paymentBloc = Modular.get<PaymentsBloc>();


  Widget buildBodyPayment(PaymentsBloc paymentBloc) {
    return DefaultTabPage(
      title: [StringFile.realizados, "Recusados"],
      page: [
        ///    buildContentPagePayment(context, responsePaginated,true),
        builderComponent<ResponsePaginated>(
            stream: paymentBloc.listPaymentInfoSubject,
            emptyMessage: "Sem pagamentos realizados",
            initCallData: () => paymentBloc.getListPayment(),
            // tryAgain: () {
            //   paymentBloc.getListPayment();
            // },
            buildBodyFunc: (context, responsePaginated) =>
                buildContentPagePayment(context, responsePaginated, true)),
        builderComponent<ResponsePaginated>(
            stream: paymentBloc.listPaymentPendetesStream,
            emptyMessage: "Sem pagamentos ${StringFile.pendentesEdisputa}",
            initCallData: () => paymentBloc.getListPaymentPendetes(),
            // tryAgain: () {
            //   paymentBloc.getListPayment();
            // },
            buildBodyFunc: (context, responsePaginated) =>
                buildContentPagePayment(context, responsePaginated, false))
      ],
    );
  }

  Widget buildContentPagePayment(BuildContext context,
      ResponsePaginated responsePaginated, bool isReceiver) {
    var myList = responsePaginated.content.toList();
    return Column(children: [
      !isReceiver ? SizedBox()  :    StreamBuilder<double>(
          stream: _paymentBloc.totalPagamento.stream,
          builder: (context, content) => Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
              child: Text(
                Utils.moneyFormat(content?.data ?? 0.0),
                style: AppThemeUtils.normalBoldSize(
                    color: AppThemeUtils.colorPrimary, fontSize: 40),
              ))),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
          child: Text(
            isReceiver ? "Recebidos" : "Recusados",
            style: AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary),
          )),

      Expanded(child: _buildEventList(myList))

//      Expanded(
//          child: builderInfinityListViewComponent(responsePaginated,
//              callMoreElements: (page) =>
//                  _paymentBloc.getListPayment(page: page),
//              buildBody: (content) => paymentItemListWidget(context, content)))
    ]);
  }
}

Widget _buildGroupSeparator(dynamic groupByValue) {
  return Container(
      padding: EdgeInsets.all(15),
      color: AppThemeUtils.colorPrimary,
      child: Text(
        MyDateUtils.parseDateTimeFormat(groupByValue,null, format: "EEEE, dd MMMM")
            .toUpperCase(),
        maxLines: 1,
        style: AppThemeUtils.normalBoldSize(
            fontSize: 14, color: AppThemeUtils.whiteColor),
      ));
}

Widget _buildEventList(List listitems) {
  return NtpTimeComponent(
      buildTime: (context,_dateTime) {
        if (_dateTime == null) {
          return loadElements(context);
        } else {
          return GroupedListView(
            elements: (((listitems)) ?? []),
            groupBy: (element) =>
                MyDateUtils.convertStringToDateTime(MyDateUtils.parseDateTimeFormat(
                    (element as Payment).createdAt ?? Modular.get<AppBloc>().dateNowWithSocket.stream.value, Modular.get<AppBloc>().dateNowWithSocket.stream.value),format: "dd/MM/yyyy") ??
                MyDateUtils.convertDateToDate(_dateTime,_dateTime),
            padding: EdgeInsets.only(bottom: 200),
            groupSeparatorBuilder: _buildGroupSeparator,
            itemBuilder: (context, element) =>
                paymentItemListWidget(context, element),
            order: GroupedListOrder.DESC,
          );
        }
      });
}
