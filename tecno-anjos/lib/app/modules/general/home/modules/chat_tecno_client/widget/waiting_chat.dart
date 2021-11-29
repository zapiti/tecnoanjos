
import 'package:flutter/material.dart';

import 'package:tecnoanjostec/app/utils/image/image_path.dart';

class WaitingChatTecnoSync extends StatelessWidget {
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
                    child: Image.asset(ImagePath.chatconection),
                  )),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    "",
                    style: TextStyle(color: Colors.cyan, fontSize: 22),
                  )),
            ],

    );
  }
}
