import 'package:flutter/material.dart';

import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class ItensPlansWidget extends StatelessWidget {
  final String pathImage;
  final String title;
  final String description;

  ItensPlansWidget({
    this.title,
    this.description,
    this.pathImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Image.asset(
                      pathImage,
                      width: 80,
                      height: 80,
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            title,
                            style: AppThemeUtils.normalBoldSize(fontSize: 18),
                          ),
                        ),
                        Container(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              description,
                              style: AppThemeUtils.normalSize(fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
