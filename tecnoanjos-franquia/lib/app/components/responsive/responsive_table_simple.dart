import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:tecnoanjos_franquia/app/components/builder/builder_component.dart';

import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';



class ResponsiveTableSimple extends StatelessWidget {
  final String nameTable;
  final Stream stream;
  final Function initCallData;
  final Widget subWidgetHeader;
  final Function bodyContainer;

  ResponsiveTableSimple(
      {this.nameTable,
      this.stream,
      this.initCallData,
      this.subWidgetHeader,
      this.bodyContainer});

  @override
  Widget build(BuildContext context) {
    return builderComponentSimple(
        stream: stream,
        initCallData: () {
          initCallData();
        },
         buildBodyFunc: (context, result) => Scaffold(
              body: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(0),
//                      constraints: BoxConstraints(
//                        maxHeight:
//                            MediaQuery.of(context).size.height * 0.5 ,
//                      ),
                child: Card(
                  elevation: 1,
                  shadowColor: Colors.black,
                  clipBehavior: Clip.none,
                  child:  ListView.builder(
                      shrinkWrap: true,
                      itemCount: (result.content.length ?? 0),
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (index == 0
                                ? Container(
                                    margin: EdgeInsets.all(25),
                                    child: Text(
                                      nameTable,
                                      style: AppThemeUtils.normalSize(
                                          color: AppThemeUtils.colorPrimary,
                                          fontSize: 22),
                                    ),
                                  )
                                : SizedBox()),
                            (index == 0
                                ? (subWidgetHeader ?? SizedBox())
                                : SizedBox()),
                            bodyContainer(context,result != null ? result.content[index] : null)
                          ],
                        );
                      }),
                ),
              ),
            ));
  }
}
