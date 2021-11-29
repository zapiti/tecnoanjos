import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/load/load_elements.dart';
import 'package:tecnoanjostec/app/components/page/default_tab_page.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/avaliation_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/models/total_avaliation.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/avaliation/widget/avaliation_item_list_widget.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';

import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class AvaliationBuilder {
  static Widget buildBodyEvaluation(AvaliationBloc avaliationBloc) {

    avaliationBloc.getTotalAvaliations();
    return DefaultTabPage(
      title: [StringFile.feitas, StringFile.recebidas, StringFile.pendentes],
      page: [
        buildContentPageEvaluation(

          avaliationBloc.listMakerEvaluationInfo.stream,
          (page) => avaliationBloc.getListAvaliationMaker(page: page),
          avaliationBloc,tipo:StringFile.feitas,
          emptyMsg: StringFile.semAvaliacoesFeitas,
        ),
        buildContentPageEvaluation(

            avaliationBloc.listReceiverEvaluationInfo.stream,
            (page) => avaliationBloc.getListAvaliationReceiver(page: page),
            avaliationBloc,tipo:StringFile.recebidas,
            emptyMsg: StringFile.semAvaliacoesRecebidas),
        buildContentPageEvaluation(

            avaliationBloc.listPendentEvaluationInfo.stream,
            (page) => avaliationBloc.getListAvaliationPendent(page: page),
            avaliationBloc,tipo:StringFile.pendentes,
            emptyMsg: StringFile.semAvaliacoesPendentes,
            status: ActivityUtils.PENDENTE)
      ],
    );
  }

  static Widget buildContentPageEvaluation(
      Stream streamData, Function actionReload, AvaliationBloc avaliationBloc,
      {String emptyMsg, String status,String tipo}) {
    return builderComponent<ResponsePaginated>(
        stream: streamData,
        emptyMessage: emptyMsg ?? StringFile.semAvaliacoes,
        initCallData: () {
          actionReload(1);

        },
        // tryAgain: () {
        //   actionReload(1);
        // },
        buildBodyFunc: (context, response) => Container(
            padding: EdgeInsets.all(5),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 80),
                itemCount: response.content.length,
                itemBuilder: (_, index) {
                  return index != 0
                      ? avaliationItemListWidget(
                          context, response.content[index])
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              status == ActivityUtils.PENDENTE
                                  ? SizedBox()
                                  : StreamBuilder<TotalAvaluation>(
                                      stream:   avaliationBloc.totalEvaluationMedia.stream,
                                      builder: (context, content) => content ==
                                              null
                                          ? loadElements(context)
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0,
                                                            vertical: 1),
                                                    child: Text(
                                                  tipo == StringFile.recebidas ? '${content?.data?.totalReceived ?? 0}' :     '${content?.data?.totalSended ?? 0}',
                                                      style: AppThemeUtils
                                                          .normalBoldSize(
                                                              color: AppThemeUtils
                                                                  .colorPrimary,
                                                              fontSize: 20),
                                                    )),
                                       Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 1),
                                                    child: Text(
                                                      content?.data?.totalReceived == 1
                                                          ? StringFile.avaliacao
                                                          : StringFile
                                                              .avaliacoesM,
                                                      style: AppThemeUtils
                                                          .normalSize(
                                                              color: AppThemeUtils
                                                                  .colorPrimary),
                                                    )),
                                              ],
                                            )),
                              status == ActivityUtils.PENDENTE
                                  ? SizedBox()
                                  :            tipo != StringFile.recebidas ?  SizedBox(): Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: AppThemeUtils.colorPrimary,
                                          size: 20,
                                        ),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 1),
                                            child: Text(
                                              StringFile.media,
                                              style:
                                                  AppThemeUtils.normalBoldSize(
                                                      color: AppThemeUtils
                                                          .colorPrimary,
                                                      fontSize: 18),
                                            )),
                                        StreamBuilder<TotalAvaluation>(
                                            stream: avaliationBloc
                                                .totalEvaluationMedia,
                                            builder: (context, content) =>
                                                content == null
                                                    ? loadElements(context)
                                                    : Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 1),
                                                        child: Text(
                                                          '${(content?.data?.average ?? 0.0).toStringAsFixed(1)}'.replaceAll(".", ","),
                                                          style: AppThemeUtils
                                                              .normalBoldSize(
                                                                  color: AppThemeUtils
                                                                      .colorPrimary,
                                                                  fontSize: 20),
                                                        ))),
                                      ],
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              avaliationItemListWidget(
                                  context, response.content[index])
                            ]);
                })));
  }
}
