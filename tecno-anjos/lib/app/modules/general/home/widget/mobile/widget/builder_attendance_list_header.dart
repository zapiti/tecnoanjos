import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tecnoanjostec/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/current_attendance_bloc.dart';

import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/widget/attendance_item_list_widget.dart';
import 'package:tecnoanjostec/app/utils/activity/activity_utils.dart';
import 'package:tecnoanjostec/app/utils/date/date_utils.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import '../../../../../../app_bloc.dart';


class BuilderAttendanceListHeader extends StatefulWidget {
  final List<Attendance> response;

  BuilderAttendanceListHeader(this.response);

  @override
  _BuilderAttendanceListHeaderState createState() =>
      _BuilderAttendanceListHeaderState();
}

class _BuilderAttendanceListHeaderState
    extends State<BuilderAttendanceListHeader> with TickerProviderStateMixin {
  var attendanceBloc = Modular.get<AttendanceBloc>();
  List _selectedEvents;
  String type;
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                    child: Column(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: type == null
                            ? ActivityUtils.getColorWithString(type)
                            : Colors.white,),
                    child: Container(
                      child: Text(
                        "Todos",
                        style: AppThemeUtils.normalSize(fontSize: 11,color:type == null
                            ? Colors.white : AppThemeUtils.colorPrimary ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        type = null;
                        attendanceBloc
                            .filterElement(widget.response, filter: type)
                            .then((value) {
                          _selectedEvents = value;
                        });
                      });
                    },
                  ),
                  lineViewWidget(height: 2)
                ])),
                Expanded(
                    child: Column(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: type == "H"
                            ? ActivityUtils.getColorWithString(type)
                            : Colors.white),
                    child: Container(
                      child: Text(
                        "Para Hoje",
                        style: AppThemeUtils.normalSize(fontSize: 11,color:type == "H"
                            ? Colors.white : AppThemeUtils.colorPrimary),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        type = "H";
                        attendanceBloc
                            .filterElement(widget.response, filter: type)
                            .then((value) {
                          _selectedEvents = value;
                        });
                      });
                    },
                  ),
                  lineViewWidget(height: 2, color: AppThemeUtils.colorPrimary)
                ])),
                Expanded(
                    child: Column(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: type == ActivityUtils.FINALIZADO
                            ? ActivityUtils.getColorWithString(type)
                            : Colors.white),
                    child: Container(
                      child: Text(
                        "Futuros",
                        style: AppThemeUtils.normalSize(fontSize: 11,color:type == ActivityUtils.FINALIZADO
                            ? Colors.white : AppThemeUtils.colorPrimary),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        type = ActivityUtils.FINALIZADO;
                        attendanceBloc
                            .filterElement(widget.response, filter: type)
                            .then((value) {
                          _selectedEvents = value;
                        });
                      });
                    },
                  ),
                  lineViewWidget(height: 2, color: AppThemeUtils.blueColor)
                ])),
                Expanded(
                    child: Column(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: type == ActivityUtils.EM_ATENDIMENTO
                            ? ActivityUtils.getColorWithString(type)
                            : Colors.white),
                    child: Container(
                      child: Text(
                        "Atrasado",
                        style: AppThemeUtils.normalSize(fontSize: 11,color:type == ActivityUtils.EM_ATENDIMENTO
                            ? Colors.white : AppThemeUtils.colorPrimary),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        type = ActivityUtils.EM_ATENDIMENTO;
                        attendanceBloc
                            .filterElement(widget.response, filter: type)
                            .then((value) {
                          _selectedEvents = value;
                        });
                      });
                    },
                  ),
                  lineViewWidget(height: 2, color: AppThemeUtils.orangeColor)
                ])),
              ],
            ),
            Expanded(child: _buildEventList(widget.response)),
          ],
        )));
  }

  Widget _buildGroupSeparator(dynamic groupByValue) {
    return Container(
        margin: EdgeInsets.all(15),
        child: Text(
          MyDateUtils.parseDateTimeFormat(groupByValue, null,
                  format: "EEEE, dd MMMM")
              .toUpperCase(),
          maxLines: 1,
          style: AppThemeUtils.normalBoldSize(fontSize: 14),
        ));
  }

  Widget _buildEventList(List<Attendance> listitems) {
    return GroupedListView(
      elements: ((_selectedEvents ?? (listitems)) ?? []),
      groupBy: (element) => MyDateUtils.convertStringToDateTime(
          MyDateUtils.parseDateTimeFormat(
              element.hourAttendance ??
                  Modular.get<AppBloc>().dateNowWithSocket.stream.value,
              Modular.get<AppBloc>().dateNowWithSocket.stream.value),
          format: "dd/MM/yyyy"),
      padding: EdgeInsets.only(bottom: 200),
      groupSeparatorBuilder: _buildGroupSeparator,
      itemBuilder: (context, element) => attendanceItemListWidget(
          context, element, element.status, currentBloc,
          showline: true),
      order: GroupedListOrder.DESC,
    );
  }
}
