import 'package:flavor/flavor.dart';
import 'package:tecnoanjos_franquia/app/app_bloc.dart';
import 'package:tecnoanjos_franquia/app/modules/login/bloc/login_bloc.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjos_franquia/app/modules/default_page/models/menu.dart';
import 'package:tecnoanjos_franquia/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjos_franquia/app/modules/drawer/widget/build_headerList_drawer.dart';
import 'package:tecnoanjos_franquia/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../main.dart';
import 'menu_item_tile.dart';

class SideBarMenu extends StatefulWidget {
  @override
  _SideBarMenuState createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu>
    with SingleTickerProviderStateMixin {
  final bloc = Modular.get<DrawerBloc>();

  final appBloc = Modular.get<AppBloc>();
  double maxWidth = 250;
  double minWidgth = 70;
  bool collapsed = true;

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));

    _animation = Tween<double>(begin: maxWidth, end: minWidgth)
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          decoration: BoxDecoration(
            boxShadow: [
              // BoxShadow(blurRadius: 10, color: Colors.black26, spreadRadius: 2)
            ],
          ),
          width: Utils.isSmall(context) ? minWidgth : _animation.value,
          child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  buildHeaderListDrawer(
                      context,
                      Utils.isSmall(context) ? minWidgth : _animation.value,
                      _animation.value == 70 || Utils.isSmall(context)
                          ? EdgeInsets.zero
                          : EdgeInsets.only(
                          top: 0, bottom: 0, right: 40, left: 40),appBloc),


                  Expanded(
                    child: ListView.builder(
                        itemCount: Menu
                            .getListWithPermission()
                            .length + 1,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return index == Menu
                              .getListWithPermission()
                              .length
                              ? MenuItemTile(
                            title: "Sair",
                            icon: Icons.exit_to_app,
                            animationController: _animationController,
                            isSelected: false,
                            onTap: () {
                              Modular.get<LoginBloc>().getLogout();
                            },
                          )
                              : MenuItemTile(
                            title: Menu.getListWithPermission()[index].title,
                            icon: Menu.getListWithPermission()[index].icon,
                            animationController: _animationController,
                            isSelected: ModalRoute
                                .of(context)
                                .settings
                                .name
                                .contains(Menu.getListWithPermission()[index]
                                .route),
                            onTap: () {
                              Modular.to.pushReplacementNamed(
                                  Menu.getListWithPermission()[index].route);
                            },
                          );
                        }),
                  ),
                  // _animation.value == 70 || Utils.isSmall(context)
                  //     ? IconButton(
                  //         icon: Icon(MaterialCommunityIcons.chat_outline),
                  //         onPressed: () {
                  //           Modular.to.pushReplacementNamed(
                  //               ConstantsRoutes.ALL_ATTENDENCE);
                  //         },
                  //         color: AppThemeUtils.colorPrimary,
                  //       )
                  //     : RaisedButton.icon(
                  //         padding:
                  //             EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20.0),
                  //             side: BorderSide(color: AppThemeUtils.colorPrimary)),
                  //         icon: Icon(
                  //           MaterialCommunityIcons.chat_outline,
                  //           color: AppThemeUtils.colorPrimary,
                  //         ),
                  //         color: Colors.white,
                  //         onPressed: () {
                  //           Modular.to.pushReplacementNamed(
                  //               ConstantsRoutes.ALL_ATTENDENCE);
                  //         },
                  //         label: Text(
                  //           'Atendimento Online',
                  //           maxLines: 1,
                  //           style: TextStyle(
                  //               color: AppThemeUtils.colorPrimary, fontSize: 16),
                  //         )),
                  SizedBox(
                    height: 10,
                  ),
                  Utils.isSmall(context)
                      ? SizedBox()
                      : InkWell(
                    onTap: () {
                      setState(() {
                        collapsed = !collapsed;
                        collapsed
                            ? _animationController.reverse()
                            : _animationController.forward();
                      });
                    },
                    child: AnimatedIcon(
                      icon: AnimatedIcons.close_menu,
                      progress: _animationController,
                      color: AppThemeUtils.colorText,
                      size: 40,
                    ),
                  ),
                  SizedBox(
                    height: 20,child: Text( "${Flavor.I.getString(firebaseKey)}-${Flavor.I.getString(actualVersion)}",style: AppThemeUtils.normalSize(fontSize: 8),),
                  )
                ],
              )),
        );
      },
    );
  }
}
