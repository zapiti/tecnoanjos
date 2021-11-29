
import 'package:flutter/material.dart';

import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class WaitingSync extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Image.asset(ImagePath.cloud),
                  )),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    StringFile.fila,
                    style: TextStyle(color: AppThemeUtils.colorPrimary, fontSize: 22),
                  )),
            ],

    );
  }
}
