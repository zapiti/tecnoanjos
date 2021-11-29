
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/new_attendance_button.dart';


class CallPage extends StatelessWidget {

  CallPage();
  @override
  Widget build(BuildContext context) {
    return  Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
            child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Container(
            //     margin: EdgeInsets.symmetric(horizontal: 30, vertical: 32),
            //     child: Text(
            //       StringFile.precisaDeajudaTecnoLogica,
            //       maxLines: 3,
            //    textAlign: TextAlign.center,
            //       style: AppThemeUtils.normalSize(
            //           fontSize: 18, color: Colors.white),
            //     )),SizedBox(height: 20,),
            //

            NewAttendanceButton(),
//                      decoration: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(75)),
//                          borderSide: BorderSide.none)),


          ],
        ))));
  }
}
