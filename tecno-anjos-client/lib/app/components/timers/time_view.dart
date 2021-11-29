import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecnoanjosclient/app/components/state_view/stateful_wrapper.dart';
import 'package:tecnoanjosclient/app/components/timers/bloc/timer_bloc.dart';
import 'package:tecnoanjosclient/app/components/timers/ticker.dart' as ticker;

import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class TimerView extends StatefulWidget {
  final VoidCallback actionPlay;
  final VoidCallback actionPause;
  final VoidCallback actionStop;
  final ValueChanged<String> observableTime;
  final int dateInit;
  final double fontSize;
  final Function awaitWithSecond;
  final Color color;
  final bool reverse;
  final  int maxSize;
  final int maxSizeSeconds;
  TimerView(
      {this.actionPlay,
      this.actionPause,
      this.actionStop,
      this.observableTime,
      this.dateInit,
      this.fontSize = 42,
      this.awaitWithSecond,
      this.color,
      this.reverse,
      this.maxSize, this. maxSizeSeconds});

  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  final TimerBloc _timerBloc = TimerBloc(ticker: ticker.Ticker());

  var blocProvider;
  Timer _timer;
  int _start = 60;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _start = widget.maxSizeSeconds ?? ((widget.maxSize ?? 0) * _start);
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
         //   widget.actionStop();
            _start = 0;
            timer?.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    //_timerBloc.add(Reset());
    _timerBloc.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (blocProvider != null) {
        blocProvider.add(Start(duration: widget.dateInit ?? 1));
      }
    });
    return widget.reverse == true
        ? Container(

            child: Center(
                child: AutoSizeText(_printDuration(Duration(seconds: _start)),
                    maxLines: 1,
                    minFontSize: 12,
                    style: AppThemeUtils.normalBoldSize(
                        fontSize: 20, color: Colors.white))))
        : Container(
            height: 45,

            child: StatefulWrapper(
                onInit: () {},
                child: BlocProvider(
                    create: (context) => _timerBloc,
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: BlocBuilder<TimerBloc, TimerState>(
                              builder: (context, state) {
                                blocProvider =
                                    BlocProvider.of<TimerBloc>(context);
                                widget.observableTime(_printDuration(
                                    Duration(seconds: state?.duration ?? 1)));
                                return AutoSizeText(
                                    _printDuration(Duration(
                                        seconds: state?.duration ?? 1)),
                                    maxLines: 1,
                                    minFontSize: 10,
                                    style: AppThemeUtils.normalBoldSize(
                                        fontSize: widget.fontSize,
                                        color:
                                            widget.color ?? Colors.grey[700]));
                              },
                            ),
                          ),
                        )),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 0),
                            child: BlocBuilder<TimerBloc, TimerState>(
                              builder: (context, state) => Actions(
                                  widget.actionPlay,
                                  widget.actionPause,
                                  widget.actionStop,
                                  widget.observableTime,
                                  widget.dateInit,
                                  blocProvider),
                            )),
                      ],
                    )))));
  }
}

class Actions extends StatelessWidget {
  final VoidCallback actionPlay;
  final VoidCallback actionPause;
  final VoidCallback actionStop;
  final ValueChanged<String> observableTime;
  final int dateInit;
  final TimerBloc blocProvider;

  Actions(this.actionPlay, this.actionPause, this.actionStop,
      this.observableTime, this.dateInit, this.blocProvider);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: () {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            blocProvider.add(Start(duration: dateInit ?? 1));
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _mapStateToActionButtons(
            timerBloc: blocProvider,
          ),
        ));
  }

  List<Widget> _mapStateToActionButtons({
    TimerBloc timerBloc,
  }) {
    final TimerState currentState = timerBloc.state;
    if (currentState is Ready) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          heroTag: "15",
          onPressed: () =>
              timerBloc.add(Start(duration: currentState?.duration ?? 1)),
        ),
      ];
    }

    return [];
  }
}

String _printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return duration.inHours == 0
      ? "$twoDigitMinutes:$twoDigitSeconds"
      : "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
