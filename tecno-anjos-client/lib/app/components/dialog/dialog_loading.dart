

import 'package:flutter_modular/flutter_modular.dart';

import '../../app_bloc.dart';

// showLoading(bool) {
//   // final _appBloc = Modular.get<AppBloc>();
//   // if( _appBloc.loadElement.stream.value != true) {
//   //   Future.delayed(Duration(seconds: 3), () {
//   //     _appBloc.loadElement.sink.add(bool);
//   //   });
//   // }else{
//   //   _appBloc.loadElement.sink.add(bool);
//   // }
//   // Future.delayed(Duration(seconds: 35),(){
//   //   if( _appBloc.loadElement.stream.value == true){
//   //     _appBloc.loadElement.sink.add(false);
//   //   }
//   // });
// }
showLoading(bool) {
  final _appBloc = Modular.get<AppBloc>();
  if(bool == false) {
    Future.delayed(Duration(seconds: 3), () {
      _appBloc.loadElement.sink.add(bool);
    });
  }else{
    _appBloc.loadElement.sink.add(bool);
  }
  // Future.delayed(Duration(seconds: 50),(){
  //   if( _appBloc.loadElement.stream.value == true){
  //     _appBloc.loadElement.sink.add(false);
  //   }
  // });
}