import 'package:tecnoanjos_franquia/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjos_franquia/app/routes/constants_routes.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:rxdart/rxdart.dart';

class ScrollCardWeb extends StatefulWidget {
  Widget child;

  ScrollCardWeb(this.child);

  @override
  _ScrollCardWebState createState() => _ScrollCardWebState();
}

class _ScrollCardWebState extends State<ScrollCardWeb> {
  var _controller = ScrollController();

  var scrollSizeSubject = BehaviorSubject<double>.seeded(0.0);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollSizeSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  backgroundColor: Colors.white,
        body: StatefulWrapper(
            onInit: () {
              Future.delayed(Duration(seconds: 1), () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (_controller.hasClients)
                  if ((_controller.position.maxScrollExtent ?? 1) > 1) {
                    scrollSizeSubject.sink.add(
                        (MediaQuery.of(context).size.height > 1000
                                ? 800
                                : MediaQuery.of(context).size.height) *
                            40 /
                            (_controller.position.maxScrollExtent ?? 1));
                  }
                });
              });
            },
            child: Stack(children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      width: 12,
                      margin: EdgeInsets.only(),
                      color: Colors.grey[300],
                      height: MediaQuery.of(context).size.height)),
              Container(
                  child: Center(
                      child: DraggableScrollbar(
                          heightScrollThumb: 50,
                          backgroundColor: AppThemeUtils.colorGrayLight,
                          scrollThumbBuilder: (
                            Color backgroundColor,
                            Animation<double> thumbAnimation,
                            Animation<double> labelAnimation,
                            double height, {
                            Text labelText,
                            BoxConstraints labelConstraints,
                          }) {
                            return StreamBuilder(
                                stream: scrollSizeSubject,
                                initialData: 0.0,
                                builder: (context, snapshot) {
                                  return InkWell(
                                      onTap: () {},
                                      child: Container(
                                          height: snapshot.data,
                                          width: 12.0,
                                          color: backgroundColor));
                                });
                          },
                          // isAlwaysShown: true,
                          controller: _controller,
                          child: ListView(controller: _controller, children: [
                            Container(
                                padding: EdgeInsets.only(
                                    right: 30, left: 20, top: 20, bottom: 20),
                                child: Card(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.all( 30),
                                        child: Text(
                                          ConstantsRoutes.getNameByRoute(
                                              ModalRoute.of(context)
                                                  .settings
                                                  .name),
                                          style: AppThemeUtils.normalSize(
                                              fontSize: 24,
                                              color: AppThemeUtils.black),
                                        )),
                                    widget.child
                                  ],
                                )))
                          ]))))
            ])));
  }
}
