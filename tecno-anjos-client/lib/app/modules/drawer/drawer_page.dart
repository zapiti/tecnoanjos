import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/modules/default_page/models/menu.dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjosclient/app/modules/drawer/widget/build_headerList_drawer.dart';
import 'package:tecnoanjosclient/app/modules/drawer/widget/drawer_button_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';

import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/attendance/attendance_utils.dart';

import '../../app_bloc.dart';


class DrawerPage extends StatelessWidget {
  final bloc = Modular.get<DrawerBloc>();
  final appBloc = Modular.get<AppBloc>();
  final profileBloc = Modular.get<ProfileBloc>();

  @override
  Widget build(BuildContext context) {
    return _buildListDrawer(context);
  }

  Widget _buildListDrawer(BuildContext context) {
    return StreamBuilder<CurrentUser>(
        stream: appBloc.getCurrentUserFutureValue(),
        builder: (ctx, futureShot) => Container(
            color: Theme.of(context).backgroundColor,
            height: MediaQuery.of(context).size.height,
            width: 300,
            child: SafeArea(
                top: false,
                bottom: true,
                right: true,
                left: true,
                child: ListView.builder(
                    itemCount:
                    Menu.getListWithPermission(futureShot.data).length,
                    padding: EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      return index == 0
                          ? Column(
                        children: [
                          buildHeaderListDrawer(
                              profileBloc, context, 300),
                          lineViewWidget(),
                          SizedBox(height: 15),
                          DrawerButton(
                              active: ModalRoute.of(context)
                                  .settings
                                  .name
                                  .contains(Menu.getListWithPermission(
                                  futureShot.data)[index]
                                  .route),
                              context: context,
                              title: Menu.getListWithPermission(
                                  futureShot.data)[index]
                                  .title,
                              iconData: Menu.getListWithPermission(
                                  futureShot.data)[index]
                                  .icon,
                              menutitle: Menu.getListWithPermission(
                                  futureShot.data)[index]
                                  .menuTitle,
                              onPressed: () {
                                AmplitudeUtil.createEvent(
                                    AmplitudeUtil.eventoEntrouNaTela(
                                        Menu.getListWithPermission(
                                            futureShot.data)[index]
                                            .title
                                            .toUpperCase()));

                                if (Menu.getListWithPermission(
                                    futureShot.data)[index]
                                    .route ==
                                    ConstantsRoutes.FAQ) {
                                  AttendanceUtils.pushNamed(
                                      context,
                                      Menu.getListWithPermission(
                                          futureShot.data)[index]
                                          .route);
                                } else {
                                  AttendanceUtils.pushReplacementNamed(
                                      context,
                                      Menu.getListWithPermission(
                                          futureShot.data)[index]
                                          .route);
                                }
                              }),
                        ],
                      )
                          : DrawerButton(
                          active: ModalRoute.of(context)
                              .settings
                              .name
                              .contains(Menu.getListWithPermission(
                              futureShot.data)[index]
                              .route),
                          context: context,
                          title: Menu.getListWithPermission(
                              futureShot.data)[index]
                              .title,
                          iconData: Menu.getListWithPermission(
                              futureShot.data)[index]
                              .icon,
                          menutitle: Menu.getListWithPermission(
                              futureShot.data)[index]
                              .menuTitle,
                          onPressed: () {
                            AmplitudeUtil.createEvent(
                                AmplitudeUtil.eventoEntrouNaTela(
                                    Menu.getListWithPermission(
                                        futureShot.data)[index]
                                        .title
                                        .toUpperCase()));

                            AttendanceUtils.pushReplacementNamed(
                                context,
                                Menu.getListWithPermission(
                                    futureShot.data)[index]
                                    .route);
                          });
                    }))));
  }
}
