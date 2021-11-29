import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/model/profile.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/tecno_bloc.dart';
import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:tecnoanjos_franquia/app/utils/date_utils.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';

class TecnoTable extends StatefulWidget {
  @override
  _TecnoTableState createState() => _TecnoTableState();
}

class _TecnoTableState extends State<TecnoTable> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();
  final tecnoBloc = Modular.get<TecnoBloc>();
  static const int sortName = 0;
  static const int sortStatus = 1;
  final bool isAscending = true;
  final int sortType = sortName;

  @override
  void initState() {
    super.initState();
    tecnoBloc.getListMyFunctionary();
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
      child: StreamBuilder<List<Profile>>(
          stream: tecnoBloc.listMyFuncionarySubject,
          builder: (context, snapshot) => HorizontalDataTable(
                leftHandSideColumnWidth: 200,
                rightHandSideColumnWidth: 1900,
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
                  await tecnoBloc.getListMyFunctionary();
                  _hdtRefreshController.refreshCompleted();
                },
                htdRefreshController: _hdtRefreshController,
              )),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Nome', 200),
      _getTitleItemWidget('Bloqueado/Ativo', 180),
      _getTitleItemWidget('Em atendimento', 180),
      // _getTitleItemWidget('Horário de atendimento', 180),
      _getTitleItemWidget('Status', 130),
      _getTitleItemWidget('Telefone', 200),
      _getTitleItemWidget('E-mail', 300),
      _getTitleItemWidget('CPF', 200),
      _getTitleItemWidget('Local de atendimento', 300),
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
      BuildContext context, int index, List<Profile> listProfile) {
    return Container(
      child: Text(listProfile[index].name),
      width: 200,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(
      BuildContext context, int index, List<Profile> listProfile) {
    final bloc = Modular.get<TecnoBloc>();
    return Row(
      children: <Widget>[
        Container(
          child: Switch(
              value: listProfile[index].status != Profile.blocked,
              activeColor: AppThemeUtils.colorPrimary,
              onChanged: (value) {
                bloc.blockedFunctionary(context,
                    status: value ? Profile.active : Profile.blocked,
                    profile: listProfile[index]);
              }),
          width: 180,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Row(
            children: <Widget>[
              Icon(listProfile[index].onWorking ? Icons.work : Icons.work_off,
                  color: listProfile[index].onWorking
                      ? Colors.green
                      : Colors.grey),
              Text(listProfile[index].onWorking ? 'Sim' : 'Não')
            ],
          ),
          width: 180,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        // Container(
        //   child: listProfile[index].startShift == Profile.INITDEFAULT &&
        //           listProfile[index].endShift != Profile.ENDDEFAULT
        //       ? Text("Dia todo")
        //       : Text(
        //           "${MyDateUtils.serverHoursToHours(listProfile[index].startShift)}-${MyDateUtils.serverHoursToHours(listProfile[index].endShift)}"),
        //   width: 180,
        //   height: 52,
        //   padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        //   alignment: Alignment.centerLeft,
        // ),
        Container(
          child: Row(
            children: <Widget>[
              Icon(!listProfile[index].isOnline ? Icons.wifi_off : Icons.wifi,
                  color:
                      !listProfile[index].isOnline ? Colors.red : Colors.green),
              Text(!listProfile[index].isOnline ? 'Off-line' : 'Online')
            ],
          ),
          width: 130,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(listProfile[index].telephone),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(listProfile[index].email),
          width: 300,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(listProfile[index].cpf),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: listProfile[index].cityAttendance.length == 0
              ? Text("Apenas remoto")
              : Text(
              listProfile[index].cityAttendance.map((e) => "${e.name}/${e.state.name}").join(",")),
          width: 300,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: FlatButton(
              onPressed: () {
                Modular.to.pushNamed(ConstantsRoutes.CALL_NOVO_TECNICO,
                    arguments: listProfile[index]);
              },
              child: Text(
                "EDITAR",
                style: AppThemeUtils.normalSize(
                    color: Theme.of(context).primaryColor),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(7.0),
                  side: BorderSide(color: Theme.of(context).primaryColor))),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}
