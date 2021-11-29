import 'package:tecnoanjos_franquia/app/modules/default_page/models/menu.dart';
import 'package:tecnoanjos_franquia/app/modules/login/bloc/login_bloc.dart';
import 'package:tecnoanjos_franquia/app/utils/image/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app_bloc.dart';
import '../../components/divider/line_view_widget.dart';
import '../../modules/drawer/drawer_bloc.dart';
import '../../modules/drawer/widget/build_headerList_drawer.dart';
import '../../modules/drawer/widget/drawer_button_widget.dart';
import '../../routes/constants_routes.dart';
import 'models/home/home.dart';

class DrawerPage extends StatelessWidget {
  final bloc = Modular.get<DrawerBloc>();
  final _appBloc = Modular.get<AppBloc>();
  @override
  Widget build(BuildContext context) {
    return _buildListDrawer(context);
  }

  Widget _buildListDrawer(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        height: MediaQuery.of(context).size.height,
        width: 300,
        child: SafeArea(
            top: false,
            bottom: true,
            right: true,
            left: true,
            child:ListView.builder(
                itemCount: Menu.getListWithPermission().length + 1,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return index == Menu.getListWithPermission().length ?   DrawerButton(
                      active: false,
                      context: context,
                      title: "Sair",
                      iconData: Icons.exit_to_app,
                      onPressed: () {

                        Modular.get<LoginBloc>().getLogout();
                      }):


                    index == 0
                      ? Column(
                    children: [
                      buildHeaderListDrawer( context, 300,EdgeInsets.only(top: 0, bottom: 0,right: 40,left: 40),_appBloc),

                        DrawerButton(
                          active: ModalRoute.of(context)
                              .settings
                              .name
                              .contains(Menu.getListWithPermission()[index].route),
                          context: context,
                          title: Menu.getListWithPermission()[index].title,
                          iconData: Menu.getListWithPermission()[index].icon,
                          onPressed: () {
                            Navigator.pop(context);
                            Modular.to.pushReplacementNamed(
                                Menu.getListWithPermission()[index].route);
                          }),
                    ],
                  )
                      : Menu.getListWithPermission()[index].hide
                      ? SizedBox()
                      : DrawerButton(
                      active: ModalRoute.of(context)
                          .settings
                          .name
                          .contains(Menu.getListWithPermission()[index].route),
                      context: context,
                      title: Menu.getListWithPermission()[index].title,
                      iconData: Menu.getListWithPermission()[index].icon,
                      onPressed: () {
                        Navigator.pop(context);
                        Modular.to.pushReplacementNamed(
                            Menu.getListWithPermission()[index].route);
                      });
                })));
  }
}
