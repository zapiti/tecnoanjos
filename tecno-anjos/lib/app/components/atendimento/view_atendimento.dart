import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'dart:math' as math show sin, pi;

import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

import 'center_view_attendance.dart';



class ViewAttendanceWidget extends StatefulWidget {
  final CenterViewAttendance  childCenter;
  final Widget  childTop;
  final Widget  childBottom;
  ViewAttendanceWidget( {this.childCenter,this.childBottom,this.childTop});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ViewAttendanceWidgetState();
  }
}

class _ViewAttendanceWidgetState extends State<ViewAttendanceWidget>
    with TickerProviderStateMixin {
  AnimationController _anicontroller, _scaleController;
  AnimationController _footerController;
  RefreshController _refreshController = RefreshController();
  int count = 20;

  @override
  void initState() {
    // TODO: implement initState
    _anicontroller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _scaleController =
        AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
    _footerController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _refreshController.headerMode.addListener(() {
      if (_refreshController.headerStatus == RefreshStatus?.idle) {
        _scaleController.value = 0.0;
        _anicontroller.reset();
      } else if (_refreshController.headerStatus == RefreshStatus.refreshing) {
        _anicontroller.repeat();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    _scaleController.dispose();
    _footerController.dispose();
    _anicontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child:Column(children: [
      Expanded(child: SmartRefresher(
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          count += 4;
          setState(() {});
          _refreshController.loadComplete();
        },
        child:   ListView(
            children: [
              widget.childTop == null ? SizedBox():     Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: 100,child: widget.childTop  ,

                margin: EdgeInsets.all(10),
              ),
              widget.childCenter == null ? SizedBox():   Container(


                margin: EdgeInsets.all(10),child: widget.childCenter,
              ),

            ],

          ),


        // footer: CustomFooter(
        //   onModeChange: (mode) {
        //     if (mode == LoadStatus.loading) {
        //       _scaleController.value = 0.0;
        //       _footerController.repeat();
        //     } else {
        //       _footerController.reset();
        //     }
        //   },
        //   builder: (context, mode) {
        //     Widget child;
        //     switch (mode) {
        //       case LoadStatus.failed:
        //         child = Text("failed,click retry");
        //         break;
        //       case LoadStatus.noMore:
        //         child = Text("no more data");
        //         break;
        //       default:
        //         child = SpinKitFadingCircle(
        //           size: 30.0,
        //           animationController: _footerController,
        //           itemBuilder: (_, int index) {
        //             return DecoratedBox(
        //               decoration: BoxDecoration(
        //                 color: index.isEven ? AppThemeUtils.colorPrimary: AppThemeUtils.colorError,
        //               ),
        //             );
        //           },
        //         );
        //         break;
        //     }
        //     return Container(
        //       height: 60,
        //       child: Center(
        //         child: child,
        //       ),
        //     );
        //   },
        // ),
        header: CustomHeader(
          refreshStyle: RefreshStyle.Behind,
          onOffsetChange: (offset) {
            if (_refreshController.headerMode.value != RefreshStatus.refreshing)
              _scaleController.value = offset / 80.0;
          },
          builder: (c, m) {
            return Container(
              child: FadeTransition(
                opacity: _scaleController,
                child: ScaleTransition(
                  child: SpinKitFadingCircle(
                    size: 30.0,
                    animationController: _anicontroller,
                    itemBuilder: (_, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? AppThemeUtils.colorPrimary: AppThemeUtils.colorError,
                        ),
                      );
                    },
                  ),
                  scale: _scaleController,
                ),
              ),
              alignment: Alignment.center,
            );
          },
        ),
      )), widget.childBottom == null ? SizedBox(): Container(
          height: 100,
          width: MediaQuery.of(context).size.width,child: widget.childBottom,
          color: Colors.white,
          padding: EdgeInsets.all(10),
        )]),
    );
  }
}

class SpinKitFadingCircle extends StatefulWidget {
  SpinKitFadingCircle({
    Key key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.animationController,
    this.duration = const Duration(milliseconds: 1200),
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        assert(size != null),
        super(key: key);

  final Color color;
  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final AnimationController animationController;
  final Duration duration;

  @override
  _SpinKitFadingCircleState createState() => _SpinKitFadingCircleState();
}

class _SpinKitFadingCircleState extends State<SpinKitFadingCircle>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

//    _controller = AnimationController(vsync: this, duration: widget.duration)
//      ..repeat();
  }

  @override
  void dispose() {
//    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Stack(
          children: [
            _circle(1, .0),
            _circle(2, -1.1),
            _circle(3, -1.0),
            _circle(4, -0.9),
            _circle(5, -0.8),
            _circle(6, -0.7),
            _circle(7, -0.6),
            _circle(8, -0.5),
            _circle(9, -0.4),
            _circle(10, -0.3),
            _circle(11, -0.2),
            _circle(12, -0.1),
          ],
        ),
      ),
    );
  }

  Widget _circle(int i, [double delay]) {
    final _size = widget.size * 0.15, _position = widget.size * .5;

    return Positioned.fill(
      left: _position,
      top: _position,
      child: Transform(
        transform: Matrix4.rotationZ(30.0 * (i - 1) * 0.0174533),
        child: Align(
          alignment: Alignment.center,
          child: FadeTransition(
            opacity: DelayTween(begin: 0.0, end: 1.0, delay: delay)
                .animate(widget.animationController),
            child: SizedBox.fromSize(
              size: Size.square(_size),
              child: _itemBuilder(i - 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
        ? widget.itemBuilder(context, index)
        : DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          );
  }
}

class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({
    double begin,
    double end,
    this.delay,
  }) : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class AngleDelayTween extends Tween<double> {
  final double delay;

  AngleDelayTween({
    double begin,
    double end,
    this.delay,
  }) : super(begin: begin, end: end);

  @override
  double lerp(double t) => super.lerp(math.sin((t - delay) * math.pi * 0.5));

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
