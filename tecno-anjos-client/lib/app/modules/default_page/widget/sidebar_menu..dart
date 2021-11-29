import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';


import 'package:tecnoanjosclient/app/modules/default_page/models/menu.dart';
import 'package:tecnoanjosclient/app/modules/drawer/drawer_bloc.dart';
import 'package:tecnoanjosclient/app/modules/drawer/widget/build_headerList_drawer.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import '../../../app_bloc.dart';
import 'menu_item_tile.dart';

class SideBarMenu extends StatefulWidget {
  @override
  _SideBarMenuState createState() => _SideBarMenuState();
}

class _SideBarMenuState extends State<SideBarMenu>
    with SingleTickerProviderStateMixin {
  final bloc = Modular.get<DrawerBloc>();
  final personBloc = Modular.get<ProfileBloc>();
  final appBloc = Modular.get<AppBloc>();
  double maxWidth = 300;
  double minWidgth = 100;
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
    return  StreamBuilder<CurrentUser>(stream: appBloc.getCurrentUserFutureValue(),builder: (ctx,futureShot) =>  AnimatedBuilder(
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
                  buildHeaderListDrawer(personBloc,
                    context,
                    _animation.value,
                  ),


                  Expanded(
                    child: ListView.builder(
                        itemCount: Menu
                            .getListWithPermission(futureShot.data)
                            .length ,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return  MenuItemTile(
                            title: Menu.getListWithPermission(futureShot.data)[index].title,
                            icon: Menu.getListWithPermission(futureShot.data)[index].icon,
                            animationController: _animationController,
                            isSelected: ModalRoute
                                .of(context)
                                .settings
                                .name
                                .contains(Menu.getListWithPermission(futureShot.data)[index]
                                .route),
                            onTap: () {
                              Modular.to.pushReplacementNamed(
                                  Menu.getListWithPermission(futureShot.data)[index].route);
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
                  //     : ElevatedButton.icon(
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
                      color: AppThemeUtils.black,
                      size: 40,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )),
        );
      },
    ));
  }
}
