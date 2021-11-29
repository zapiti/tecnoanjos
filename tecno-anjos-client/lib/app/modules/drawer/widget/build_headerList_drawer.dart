import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/builder/builder_component.dart';

import 'package:tecnoanjosclient/app/components/image/user_image_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';


import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

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
            padding: EdgeInsets.only(left: 0, top: 46, bottom: 20),
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
                            //     onTap: () {
                            //       showGenericDialog(context: context,
                            //           title: StringFile
                            //               .titlePopLevel,
                            //           description: StringFile
                            //               .descriptionTag +
                            //               "${profileData?.level?.tag ?? "I"}",
                            //           iconData:
                            //           Icons.videogame_asset,
                            //           positiveCallback: () {},
                            //           positiveText:
                            //           StringFile.OK);
                            //     },
                            //     child: Container(
                            //         child: Chip(
                            //           label: Text(
                            //             profileData?.level?.tag ??
                            //                 "--",
                            //             style:
                            //             AppThemeUtils.normalSize(
                            //                 color:
                            //                 Theme.of(context)
                            //                     .primaryColor,
                            //                 fontSize: 14),
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


