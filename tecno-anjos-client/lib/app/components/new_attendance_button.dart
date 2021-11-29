import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/modules/default_page/default_page_widget.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/calling_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class NewAttendanceButton extends StatefulWidget {
  @override
  _NewAttendanceButtonState createState() => _NewAttendanceButtonState();
}

class _NewAttendanceButtonState extends State<NewAttendanceButton> {

  BuildContext myContext;
  var profileBloc = Modular.get<ProfileBloc>();
  final appBloc = Modular.get<AppBloc>();
  var callingBloc = Modular.get<CallingBloc>();
  var _start = 0.0;
  var cancel = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    // appBloc.getFirstOnboard().then((value) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     if (value) {
    //       Future.delayed(Duration(milliseconds: 200),
    //           () => ShowCaseWidget.of(myContext).startShowCase([_one]));
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -156,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Center(child:  CircularPercentIndicator(key: keyButton3,
            radius: 260.0,
            lineWidth: 12.0,
            percent: _start / 10,
            center: new Container(
//                      onPressed: () {
//                        //iniciar chamad
//
//                        AttendanceUtils.pushNamed(context,ConstantsRoutes.CALLING);
//                      },
              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
              child: GestureDetector(
                  onTap: () {
                    AmplitudeUtil.createEvent(AmplitudeUtil.tocouNoBotaoIniciarAtendimento);
                    cancelPercent(true);

                  } ,
                  onTapDown: (TapDownDetails details) => actionAddPercent(),
                  onTapUp: (TapUpDetails details) => cancelPercent(true),
                  child:Container(
                      width: 210,height: 210,
                      decoration:  BoxDecoration(
                          color: Colors.transparent,   borderRadius:
                      BorderRadius.all(Radius.circular(1000.0)), boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],),
                      child:  Image.asset(
                        ImagePath.imageCallSky,
                        width: 260,
                        height: 260,
                      ),),),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(180),
              ),
            ),
            progressColor: AppThemeUtils.colorPrimary,
            backgroundColor: Colors.white60,
          ),),
   Container(
     margin: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
       child:  Text(
    "Aperte e segure para chamar seu Tecnoanjo",textAlign: TextAlign.center,style: AppThemeUtils.normalBoldSize(color: AppThemeUtils.whiteColor,fontSize: 22))),

      ],)
   ) ;

  }

  void startTimer() {
    if (cancel) {
      setState(() {
        cancel = false;
      });
    }
    const oneSec = const Duration(milliseconds: 80);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      try {
        if (cancel) {
          print("canceled");
          timer?.cancel();
          setState(() {
            _start = 0;
            cancel = false;
          });
        } else {
          if (_start >= 10) {
            timer?.cancel();

            _start = 0;
            cancel = false;
            _timer?.cancel();
            Modular.to.pushNamed(ConstantsRoutes.CALLING).then((value) {});
            setState(() {
              _start = 0;
              cancel = false;
            });
          } else {
            setState(() {
              _start += 1;
            });
          }
        }
      } catch (ex) {
        _timer?.cancel();
      }
    });
  }

  cancelPercent(bool canceled) {
    setState(() {
      cancel = canceled;
    });
  }

  actionAddPercent() {
    callingBloc.clearAttendance();
    startTimer();
  }
}
