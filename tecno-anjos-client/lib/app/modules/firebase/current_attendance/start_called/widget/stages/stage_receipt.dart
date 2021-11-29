import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:tecnoanjosclient/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjosclient/app/components/atendimento/view_atendimento.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import '../../start_called_bloc.dart';

class StageReceipt extends StatefulWidget {
  final Attendance attendance;

  StageReceipt(this.attendance);

  @override
  _StageReceiptState createState() => _StageReceiptState();
}

class _StageReceiptState extends State<StageReceipt> {
  Timer _timer;
  int _start = 180;

  var startCalledBloc = Modular.get<StartCalledBloc>();
  var controllerPendency = TextEditingController();
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  void startTimer() {
    if (!ActivityUtils.isCancellTecno(widget.attendance)) {
      const oneSec = const Duration(seconds: 1);
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
              currentBloc.patchConclude(context, widget.attendance);
              timer?.cancel();
            } else {
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: AppThemeUtils.colorPrimary,
        child: ViewAttendanceWidget(
          childTop: null,
          childCenter: CenterViewAttendance(
              subtitle: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                ReceptCard(widget.attendance, false, null),
                ActivityUtils.isCancellTecno(widget.attendance)
                    ? SizedBox()
                    : lineViewWidget(),
                ActivityUtils.isCancellTecno(widget.attendance)
                    ? SizedBox()
                    : Container(
                        height: 30,
                        margin: EdgeInsets.only(
                            right: 20, left: 20, bottom: 10, top: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppThemeUtils.colorError,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  side: BorderSide(
                                      color: AppThemeUtils.darkGrey, width: 1)),
                            ),
                            onPressed: () {
                              currentBloc.patchRefused(
                                  context, widget.attendance);
                            },
                            child: Text(
                              StringFile.recusarAtendimento,
                              style: AppThemeUtils.normalBoldSize(
                                  color: AppThemeUtils.whiteColor,
                                  fontSize: 10),
                            )),
                      )
              ])),
          childBottom: Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                onPressed: () async {
                  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
                  currentBloc.patchConclude(context, widget.attendance);
                },
                //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                child: Text(
                  ActivityUtils.isCancellTecno(widget.attendance)
                      ? StringFile.concluir
                      : StringFile.concluirAtendimento + "($_start)",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )),
        ));
  }
}

class ReceptCard extends StatelessWidget {
  final Attendance attendance;
  final bool showMoreDetail;
  final DateTime _dateTime;

  ReceptCard(this.attendance, this.showMoreDetail, this._dateTime);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppThemeUtils.colorPrimary,
        width: MediaQuery.of(context).size.width,
        child: Container(
            margin: EdgeInsets.all(20),
            child: Center(
              child: SingleChildScrollView(
                child: _contentCard(attendance, context, _dateTime),
              ),
            )));
  }
}

Card _contentCard(
    Attendance attendance, BuildContext context, DateTime _dateTime) {
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
  return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    (StringFile.resumo),
                    style: AppThemeUtils.normalBoldSize(
                        fontSize: 18, color: AppThemeUtils.colorPrimary),
                  )),
              lineViewWidget(top: 10),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(
                            top: 5, left: 5, right: 5, bottom: 5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Container(
                              width: 50,
                              height: 45,
                              color: Colors.grey[200],
                              child: Image.network(
                                (attendance.userTecno?.pathImage ?? ""),
                                fit: BoxFit.fill,
                                // imageUrl:
                                //     ,
                                // placeholder: (context, url) =>
                                //     new CircularProgressIndicator(),
                                // errorWidget: (context, url, error) =>
                                //     new Icon(Icons.error_outline),
                              ),
                            ))),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  attendance?.userTecno?.name ?? "",
                                  style: AppThemeUtils.normalBoldSize(),
                                ),
                              ],
                            )))
                  ],
                ),
              ),
              lineViewWidget(top: 10),
              Row(
                children: [
                  Expanded(
                      child: titleDescriptionWebWidget(context,
                          title: StringFile.numeroChamado,
                          description: "#${attendance?.id ?? "--"}")),
                  Container(
                    margin: EdgeInsets.only(top: 9),
                    child: Transform(
                        transform: new Matrix4.identity()..scale(0.6),
                        child: Chip(
                          backgroundColor: attendance?.address == null
                              ? AppThemeUtils.colorError
                              : AppThemeUtils.colorPrimary,
                          label: Text(
                            attendance?.address == null
                                ? StringFile.remoto
                                : StringFile.presencial,
                            style: AppThemeUtils.normalSize(
                                color: AppThemeUtils.whiteColor),
                          ),
                        )),
                  ),
                ],
              ),
              lineViewWidget(top: 10),
              itensOnDetailsOnly(context, attendance, _dateTime),
              titleDescriptionWebWidget(context,
                  title: StringFile.status,
                  description: ActivityUtils.getStatusName(attendance?.status)),
              lineViewWidget(top: 10),
              attendance?.address == null
                  ? SizedBox()
                  : titleDescriptionWebWidget(context,
                      title: StringFile.endereco,
                      description:
                          Utils?.addressFormatMyData(attendance?.address)),
              attendance?.address == null
                  ? SizedBox()
                  : lineViewWidget(top: 10),
              attendance?.attendanceItems == null
                  ? SizedBox()
                  : titleDescriptionWebListWidget(context,
                  title: "Serviços",
                  description:
                  attendance?.attendanceItems?.map<String>((e) => e.name)?.toList()),
              attendance?.attendanceItems == null ? SizedBox() : lineViewWidget(top: 10),
              attendance?.description == null
                  ? SizedBox()
                  : titleDescriptionWebWidget(context,
                      title: StringFile.resumo,
                      description: attendance?.description ?? "--"),
              attendance?.description == null
                  ? SizedBox()
                  : lineViewWidget(top: 10, bottom: 10),
              attendance.status == ActivityUtils.CANCELADO ? SizedBox():    Text(
                StringFile.total,
                style:
                    AppThemeUtils.normalSize(color: AppThemeUtils.colorPrimary),
              ),
              attendance.status == ActivityUtils.CANCELADO ? SizedBox():      StreamBuilder<int>(
                  stream: currentBloc.qtdSubject,
                  initialData: 1,
                  builder: (context, snapshot) => Container(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: Text(
                        (" ${ActivityUtils.getTotalWithListMoney(attendance, qtd: snapshot.data)}"),
                        style: AppThemeUtils.normalBoldSize(
                            fontSize: 24, color: AppThemeUtils.colorPrimary),
                      ))),
            ],
          )));
}

class ReceiptCard2 extends StatelessWidget {
  final Attendance attendance;
  final bool showMoreDetail;
  final DateTime _dateTime;
  final bool showImage;

  ReceiptCard2(this.attendance, this.showMoreDetail, this._dateTime,
      {this.showImage = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            !showImage
                ? SizedBox()
                : Container(
                    child: Flex(
                      direction: (attendance?.isFavorite ?? false)
                          ? Axis.vertical
                          : Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            !(attendance?.isFavorite ?? false)
                                ? SizedBox()
                                : Icon(
                                    MaterialCommunityIcons.crown,
                                    color: AppThemeUtils.colorPrimary,
                                  ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: 5, left: 5, right: 5, bottom: 5),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[200],
                                      child: attendance.userTecno?.pathImage ==
                                              null
                                          ? SizedBox()
                                          : Image.network(
                                              (attendance.userTecno.pathImage),
                                              fit: BoxFit.fill,
                                              // placeholder: (context, url) =>
                                              //     new CircularProgressIndicator(),
                                              // errorWidget: (context, url,
                                              //         error) =>
                                              //     new Icon(Icons.error_outline),
                                            ),
                                    )))
                          ],
                        ),
                        (attendance?.isFavorite ?? false)
                            ? Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      attendance?.userTecno?.name ?? "",
                                      style: AppThemeUtils.normalBoldSize(
                                          fontSize: 20),
                                    ),
                                    SizedBox(height: 5,),
                                    _infoTecno(attendance)
                                  ],
                                ))
                            : Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          attendance?.userTecno?.name ?? "",
                                          style: AppThemeUtils.normalBoldSize(
                                              fontSize: 20),
                                        ),
                                        SizedBox(height: 5,),
                                        _infoTecno(attendance)
                                      ],
                                    )))
                      ],
                    ),
                  ),
            !showImage ? SizedBox() : lineViewWidget(top: 10),

            attendance?.attendanceCode == null
                ? SizedBox()
                : titleDescriptionWebWidget(context,
                title: StringFile.attendanceCode,
                description: attendance?.attendanceCode ?? "--"),
            attendance?.attendanceCode == null
                ? SizedBox()
                : lineViewWidget(top: 10, bottom: 10),
            Row(
              children: [
                Expanded(
                    child: titleDescriptionWebWidget(context,
                        title: StringFile.numeroChamado,
                        description: "#${attendance?.id ?? "--"}")),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Transform(
                      transform: new Matrix4.identity()..scale(0.6),
                      child: Chip(
                        backgroundColor: attendance?.address == null
                            ? AppThemeUtils.darkGrey
                            : AppThemeUtils.colorPrimary,
                        label: Text(
                          attendance?.address == null ? "REMOTO" : "PRESENCIAL",
                          style: AppThemeUtils.normalSize(
                              color: AppThemeUtils.whiteColor),
                        ),
                      )),
                ),
              ],
            ),
            lineViewWidget(top: 10),
            itensOnDetailsOnly(context, attendance, _dateTime),
            attendance?.address == null
                ? SizedBox()
                : titleDescriptionWebWidget(context,
                    title: StringFile.endereco,
                    description:
                        Utils?.addressFormatMyData(attendance?.address)),
            attendance?.address == null ? SizedBox() : lineViewWidget(top: 10),


            attendance?.attendanceItems == null
                ? SizedBox()
                : titleDescriptionWebListWidget(context,
                title: "Serviços",
                description:
                attendance?.attendanceItems?.map<String>((e) => e.name)?.toList()),
            attendance?.attendanceItems == null ? SizedBox() : lineViewWidget(top: 10),
   // lineViewWidget(top: 50,color: Colors.pink),


            attendance?.description == null
                ? SizedBox()
                : titleDescriptionWebWidget(context,
                    title: StringFile.resumo,
                    description: attendance?.description ?? "--"),
            attendance?.description == null
                ? SizedBox()
                : lineViewWidget(top: 10, bottom: 10),
            !(showMoreDetail ?? true)
                ? SizedBox()
                : titleDescriptionWebWidget(context,
                    title: StringFile.status,
                    description:
                        ActivityUtils.getStatusName(attendance?.status)),


          ],
        ));
  }
}

_infoTecno(Attendance attendance) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Expanded(child:  Container(
        height: 24,
        padding:
        EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[200],
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(20))),
        child: Text(
          "${attendance?.userTecno?.totalAttendances ?? "0"}\n atendimentos",
          maxLines: 2,textAlign: TextAlign.center,
          style: AppThemeUtils.normalSize(
              fontSize: 10),
        ))),SizedBox(width: 5,),
    Expanded(child:  Container(
        height: 24,
        padding:
        EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[200],
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(20))),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
          Text(
            "${attendance?.userTecno?.avaliations ?? "0"}",
            maxLines: 2,
            style: AppThemeUtils.normalSize(
                fontSize: 10),
          ),Icon(Icons.star,color: AppThemeUtils.colorPrimary,size: 18,)

  ],)


     ))
  ],);
}

Widget itensOnDetailsOnly(
    BuildContext context, Attendance attendance, DateTime _dateTime) {
  return Column(
    children: [
      attendance?.dateInit == null
          ? Container()
          : titleDescriptionWebWidget(context,
              title: StringFile.inicio,
              description: MyDateUtils.parseDateTimeFormat(
                  attendance?.dateInit, _dateTime,
                  format: "dd/MM/yyyy HH:mm")),
      attendance?.dateInit == null ? Container() : lineViewWidget(top: 10),
      attendance.dateEnd == null
          ? Container()
          : titleDescriptionWebWidget(context,
              title: StringFile.fim,
              description: MyDateUtils.parseDateTimeFormat(
                  attendance.dateEnd, _dateTime,
                  format: "dd/MM/yyyy HH:mm")),
      attendance.dateEnd == null ? Container() : lineViewWidget(top: 10),
      attendance.hourAttendance == null
          ? Container()
          : titleDescriptionWebWidget(context,
              title: StringFile.agendamento,
              description: (MyDateUtils.parseDateTimeFormat(
                  attendance.hourAttendance, _dateTime,
                  format: "dd/MM/yyyy HH:mm",
                  defaultValue: StringFile.maisbreve))),
      attendance.hourAttendance == null ? Container() : lineViewWidget(top: 15),
    ],
  );
}
