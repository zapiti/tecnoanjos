
import 'package:flutter/material.dart';

import 'package:tecnoanjosclient/app/utils/image/image_path.dart';


class WaitingChatTecnoSync extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(

                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Image.asset(ImagePath.chatconection),
//                    child: LoadingBouncingGrid.square(
//                      borderColor: Colors.cyan,
//                      borderSize: 1.0,
//                      size: 150.0,
//                      backgroundColor: Colors.cyanAccent,
//                      duration: Duration(milliseconds: 1000),
//                    ),
                  )),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    "Carregando chat.",
                    style: TextStyle(color: Colors.cyan, fontSize: 22),
                  )),
            ],

    );
  }
}
