import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjostec/app/components/builder/builder_component.dart';
import 'package:tecnoanjostec/app/components/image/user_image_widget.dart';
import 'package:tecnoanjostec/app/components/text_appearance/title_description_icon.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/profile_bloc.dart';

import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/attendance/attendance_utils.dart';
import 'package:tecnoanjostec/app/utils/object/object_utils.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';


Widget buildHeaderListDrawer(
    ProfileBloc profileBloc, BuildContext context, double width,
    {bool forceShowInfo = false}) {


  return builderComponentSimple<Profile>(
          stream: profileBloc.userInfos.stream,
          enableError: false,
          enableEmpty: false,
          initCallData: () {
            if (kIsWeb) {
              profileBloc.getUserInfo();
            }
          },
          enableLoad: false,
          buildBodyFunc: (context, response) {
            var profileData = response;

            return  Container(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(left: 0, top: 46, bottom: 0),
                    child: Column(children: <Widget>[
                      forceShowInfo
                          ? SizedBox()
                          : Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      width: width < 100 ? 40 : 60,
                                      height: width < 100 ? 40 : 60,
                                      margin: EdgeInsets.only(
                                          bottom: 10,
                                          top: 0,
                                          right: 0,
                                          left: 15),
                                      child: UserImageWidget()),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  width <= 100 ? SizedBox() :     Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 12,
                                              left: 0,
                                              right: 12,
                                              bottom: 10),
                                          child: Text(
                                            profileData?.name ?? "--",
                                            textAlign: TextAlign.center,
                                            style: AppThemeUtils.normalSize(
                                                fontSize: 20,
                                                color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )),
                                      // width < 100
                                      //     ? SizedBox()
                                      //     : InkWell(
                                      //         onTap: () {
                                      //           showGenericDialog(context: context,
                                      //               title: StringFile
                                      //                   .titlePopLevel,
                                      //               description: StringFile
                                      //                       .descriptionTag +
                                      //                   "${profileData?.level?.tag ?? "I"}",
                                      //               iconData:
                                      //                   Icons.videogame_asset,
                                      //               positiveCallback: () {},
                                      //               positiveText:
                                      //                   StringFile.OK);
                                      //         },
                                      //         child: Container(
                                      //             child: Chip(
                                      //           label: Text(
                                      //             profileData?.level?.tag ??
                                      //                 "--",
                                      //             style:
                                      //                 AppThemeUtils.normalSize(
                                      //                     color:
                                      //                         Theme.of(context)
                                      //                             .primaryColor,
                                      //                     fontSize: 14),
                                      //           ),
                                      //           backgroundColor: Colors.white,
                                      //           avatar: Icon(
                                      //             Icons.star,
                                      //             size: 18,
                                      //             color: Theme.of(context)
                                      //                 .primaryColor,
                                      //           ),
                                      //         ))),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                      width <= 100 ? SizedBox() :   forceShowInfo
                          ? geralinfo(width, context, profileData)
                          : geralinfo(width, context, profileData)
                    ]));
          });
      // : Container(
      //     color: Theme.of(context).primaryColor,
      //     width: MediaQuery.of(context).size.width,
      //     padding: EdgeInsets.only(left: 0, top: 46, bottom: 20),
      //     child: Column(children: <Widget>[
      //       Container(
      //         child: getLogoIcon(),
      //       ),
      //     ]));
}

Widget geralinfo(double width, context, profileData) {
  return profileData?.hoursWorked == null &&
          profileData?.schedule == null &&
          profileData?.avaliations == null
      ? SizedBox()
      : Column(
          children: [
            new Container(
              height: 100,
              margin: EdgeInsets.only(right: 15, left: 15, bottom: 10, top: 10),
              child: Flex(
                direction: width < 100 ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Container(
                  //     width: 65,
                  //     child: InkWell(
                  //         onTap: () {
                  //           AttendanceUtils.pushNamed(
                  //               context, ConstantsRoutes.MEUSATENDIMENTOS);
                  //         },
                  //         child: titleDescriptionIcon(
                  //             context,
                  //             MaterialCommunityIcons.clock_outline,
                  //             width < 100 ? "" : StringFile.horas,
                  //             colorIcon: Colors.white,
                  //             fontSize: 12,
                  //             title: profileData?.hoursWorked == "null"
                  //                 ? "--"
                  //                 : profileData?.hoursWorked ?? "--",
                  //             colorText: Colors.white))),
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            Modular.to.pushNamed(ConstantsRoutes.AVALIACOES);
                          },
                          child: titleDescriptionIcon(
                              context,
                              Icons.star,
                              width < 100
                                  ? ""
                                  : "Média\n Avaliações",
                              colorIcon: Colors.white,
                              fontSize: 12,maxline: 2,
                              title:(ObjectUtils.parseToDouble(  profileData?.avaliations ?? "0.0")).toStringAsFixed(1).toString().replaceAll(".", ","),
                              colorText: Colors.white))),
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            AttendanceUtils.pushNamed(
                                context, ConstantsRoutes.MEUSATENDIMENTOS);
                          },
                          child: titleDescriptionIcon(
                              context,
                              MaterialCommunityIcons.notebook_outline,
                              width < 100 ? "" : StringFile.agendamentos,
                              fontSize: 12,
                              title: profileData?.schedule ?? "--",
                              colorIcon: Colors.white,
                              colorText: Colors.white)))
                ],
              ),
            ),
          ],
        );
}
