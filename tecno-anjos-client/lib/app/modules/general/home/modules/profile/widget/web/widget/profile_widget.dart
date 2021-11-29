import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:tecnoanjosclient/app/components/image/user_image_widget.dart';
import 'package:tecnoanjosclient/app/components/text_appearance/title_description_icon.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class ProfileWidget extends StatelessWidget {
  final Profile profile;

  ProfileWidget(this.profile);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return  Material(
      elevation: 10,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(4),
      color: Colors.white,
      child: Container(
        width: width > 1400 ? width / 3.2 - 25 : width,
        height: 600,
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 200,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
//                            image: DecorationImage(
//
//                              image: AssetImage(
//                                'assets/images/profile-bg.jpg',
//                              ),
//                            ),
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 130,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 120,
                            width: 120,
                            child: UserImageWidget(),
                          ),
                          width < 100
                              ? SizedBox()
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  margin: EdgeInsets.only(top: 12, left: 6),
                                  child: Text(
                                    profile?.name ?? "--:--",
                                    textAlign: TextAlign.center,
                                    style: AppThemeUtils.normalSize(
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                          // width < 100
                          //     ? SizedBox()
                          //     : Container(
                          //         child: Chip(
                          //         label: Text(
                          //           profile?.level ?? "--:--",
                          //           style: AppThemeUtils.normalSize(
                          //               color: Colors.white, fontSize: 14),
                          //         ),
                          //         backgroundColor:
                          //             Theme.of(context).primaryColor,
                          //         avatar: Icon(
                          //           Icons.star,
                          //           size: 18,
                          //           color: Colors.white,
                          //         ),
                          //       )),
                          SizedBox(
                            height: 30,
                          ),
                          // Container(
                          //     width:
                          //         width > 1400 ? width / 3.2 - 50 : width / 1.8,
                          //     child: RichText(
                          //         text: TextSpan(
                          //       text: "Seu anjo:",
                          //       style: AppThemeUtils.normalSize(
                          //           color: Theme.of(context)
                          //               .textTheme
                          //               .bodyText2
                          //               .color,
                          //           fontSize: 18),
                          //       children: <TextSpan>[
                          //         TextSpan(
                          //             text: "${profile?.levelInfo ?? "--:--"}",
                          //             style: AppThemeUtils.normalSize(
                          //                 color: Theme.of(context).primaryColor,
                          //                 fontSize: 18)),
                          //       ],
                          //     ))),
                          SizedBox(
                            height: 30,
                          ),
                          new Container(
                            width:
                                width > 1400 ? width / 3.2 - 50 : width / 1.8,
                            margin: EdgeInsets.only(
                                right: 15, left: 15, bottom: 10, top: 10),
                            child: Flex(
                              direction:
                                  width < 100 ? Axis.vertical : Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(

                                    onTap: () {},
                                    child: titleDescriptionIcon(
                                        context,
                                        MaterialCommunityIcons.clock_outline,
                                        width < 100 ? "" : StringFile.horasTrabalhadas,
                                        colorIcon:
                                            Theme.of(context).primaryColor,
                                        title: '10.2',
                                        colorText:
                                            Theme.of(context).primaryColor)),
                                InkWell(
                                    onTap: () {},
                                    child: titleDescriptionIcon(
                                        context,
                                        Icons.star,
                                        width < 100
                                            ? ""
                                            : width < 300
                                                ? StringFile.avaliacoes
                                                : StringFile.avaliacoesPostivas,
                                        colorIcon:
                                            Theme.of(context).primaryColor,
                                        title: '30',
                                        colorText:
                                            Theme.of(context).primaryColor)),
                                InkWell(
                                    onTap: () {},
                                    child: titleDescriptionIcon(
                                        context,
                                        MaterialCommunityIcons.notebook_outline,
                                        width < 100 ? "" : StringFile.novosAgendamentos,
                                        title: '20',
                                        colorIcon:
                                            Theme.of(context).primaryColor,
                                        colorText:
                                            Theme.of(context).primaryColor))

                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
