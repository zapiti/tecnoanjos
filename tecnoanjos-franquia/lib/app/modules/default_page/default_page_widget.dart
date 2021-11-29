import 'package:tecnoanjos_franquia/app/components/load/load_view_element.dart';
import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../modules/default_page/widget/sidebar_menu..dart';

class DefaultPageWidget extends StatefulWidget {
  final Widget childWeb;
  final Widget childMobile;
  final bool desableBackHome;

  const DefaultPageWidget(
      {@required this.childWeb, @required this.childMobile,this.desableBackHome = false});

  @override
  _DefaultPageWidgetState createState() => _DefaultPageWidgetState();
}

class _DefaultPageWidgetState extends State<DefaultPageWidget> {
  @override
  Widget build(BuildContext context) {

    //
    // return LoadViewElement(
    //     child: Scaffold(  backgroundColor: Colors.white,body:  LayoutBuilder(
    //     builder: (BuildContext context, BoxConstraints constraints) {
    //   if (constraints.maxWidth <= 800) {
    //     return WillPopScope(
    //         onWillPop: () async {
    //           if(!widget.desableBackHome){
    //             Modular.to.pushReplacementNamed(ConstantsRoutes.HOME);
    //           }
    //
    //       return true;
    //     },
    //       child: widget.childMobile);
    //   } else {
        return Material(
          color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Modular.get<SideBarMenu>(),SizedBox(width: 0,),
              Flexible(fit: FlexFit.loose,flex: 1 ,child: widget.childWeb ?? SizedBox())
            ]));
      }
    // }))
// );
//   }
}
