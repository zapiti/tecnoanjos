import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/widget/call/callpage.dart';




class AcceptAttendanceLogic extends StatefulWidget {


  AcceptAttendanceLogic();

  @override
  _AcceptAttendanceLogicState createState() => _AcceptAttendanceLogicState();
}

class _AcceptAttendanceLogicState extends State<AcceptAttendanceLogic> {
  var profileBloc = Modular.get<ProfileBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return  CallPage();

  }
}
