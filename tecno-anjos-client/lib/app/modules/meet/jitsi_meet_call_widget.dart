import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:tecnoanjosclient/app/components/blick_button.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class JitsiMeetCallWidget extends StatefulWidget {
  final Attendance attendance;

  JitsiMeetCallWidget(this.attendance);

  @override
  _JitsiMeetCallWidgetState createState() => _JitsiMeetCallWidgetState();
}

class _JitsiMeetCallWidgetState extends State<JitsiMeetCallWidget> {
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "tecnoanjo-");
  final subjectText = TextEditingController(text: "Atendimento Tecnoanjo");
  final nameText = TextEditingController(text: "Tecnoanjo cliente");
  final emailText = TextEditingController(text: "tecnoanjocliente@email.com");
  var isAudioOnly = false;
  var isAudioMuted = true;
  var isVideoMuted = true;
  var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      roomText.text = "Tecnoanjo${widget.attendance?.id}";
      subjectText.text = "Atendimento Tecnoanjo";
      nameText.text =
          widget?.attendance?.userClient?.name ?? "Tecnoanjo cliente";
      emailText.text =
          widget?.attendance?.userClient?.email ?? "tecnoanjocliente@email.com";
    });
  }

  _joinMeeting() async {
    String serverUrl =
        serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {
      Map<FeatureFlagEnum, bool> featureFlags = {
        /// Flag indicating if add-people functionality should be enabled.
        /// Default: enabled (true).
        FeatureFlagEnum.ADD_PEOPLE_ENABLED: false,

        /// Flag indicating if calendar integration should be enabled.
        /// Default: enabled (true) on Android, auto-detected on iOS.
        FeatureFlagEnum.CALENDAR_ENABLED: false,

        /// Flag indicating if call integration (CallKit on iOS,
        /// ConnectionService on Android)
        /// should be enabled.
        /// Default: enabled (true).
        FeatureFlagEnum.CALL_INTEGRATION_ENABLED: false,

        /// Flag indicating if close captions should be enabled.
        /// Default: enabled (true).
        FeatureFlagEnum.CLOSE_CAPTIONS_ENABLED: false,

        /// Flag indicating if chat should be enabled.
        /// Default: enabled (true).
        FeatureFlagEnum.CHAT_ENABLED: false,

        /// Flag indicating if invite functionality should be enabled.
        /// Default: enabled (true).
        FeatureFlagEnum.INVITE_ENABLED: false,

        /// Flag indicating if recording should be enabled in iOS.
        /// Default: disabled (false).
        FeatureFlagEnum.IOS_RECORDING_ENABLED: false,

        /// Flag indicating if live-streaming should be enabled.
        /// Default: auto-detected.
        FeatureFlagEnum.LIVE_STREAMING_ENABLED: false,

        /// Flag indicating if displaying the meeting name should be enabled.
        /// Default: enabled (true).
        FeatureFlagEnum.MEETING_NAME_ENABLED: false,

        /// Flag indicating if the meeting password button should be enabled. Note
        /// that this flag just decides on the buttton, if a meeting has a password
        /// set, the password ddialog will still show up.
        /// Default: enabled (true).
        FeatureFlagEnum.MEETING_PASSWORD_ENABLED: false,

        /// Flag indicating if raise hand feature should be enabled.
        /// Default: enabled.
        FeatureFlagEnum.RAISE_HAND_ENABLED: false,

        /// Flag indicating if recording should be enabled.
        /// Default: auto-detected.
        FeatureFlagEnum.RECORDING_ENABLED: false,

        /// Flag indicating if tile view feature should be enabled.
        /// Default: enabled.
        FeatureFlagEnum.TILE_VIEW_ENABLED: true,

        /// Flag indicating if the toolbox should be always be visible
        /// Default: disabled (false).
        FeatureFlagEnum.TOOLBOX_ALWAYS_VISIBLE: true,

        /// Flag indicating if the welcome page should be enabled.
        /// Default: disabled (false).
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      };
      if (!kIsWeb) {
        // Here is an example, disabling features for each platform
        if (Platform.isAndroid) {
          // Disable ConnectionService usage on Android to avoid issues (see README)
          featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
        } else if (Platform.isIOS) {
          // Disable PIP on iOS as it looks weird
          featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
        }
      }
      //uncomment to modify video resolution
      //featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION;

      // Define meetings options here
      var options = JitsiMeetingOptions(room: roomText.text)
        ..serverURL = serverUrl
        ..userAvatarURL = widget.attendance.userClient?.pathImage
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags)
        ..webOptions = {
          "roomName": roomText.text,
          "width": "100%",
          "height": "100%",
          "enableWelcomePage": false,
          "chromeExtensionBanner": null,
          "userInfo": {"displayName": nameText.text}
        };

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(options);

      JitsiMeet.addListener(JitsiMeetingListener(
          onConferenceWillJoin: (tex) {
            AmplitudeUtil.createEvent(AmplitudeUtil.abriuvideo);
            currentBloc.atuaLizaToVideoChamada(widget.attendance, true);
          },
          onConferenceJoined: (tex) {},
          onConferenceTerminated: (tex) {},
          onPictureInPictureWillEnter: (tex) {},
          onPictureInPictureTerminated: (tex) {},
          onError: _onError));
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? SizedBox()
        : widget.attendance.status == ActivityUtils.ENCERRADO
            ? SizedBox()
            : Container(
                width: double.maxFinite,
                child: StreamBuilder<DocumentSnapshot>(
                    stream: currentBloc.listenToVideoChamada(widget.attendance),
                    builder: (context, snapshot) => ElevatedButton(
                          onPressed: () {
                            SchedulerBinding.instance
                                .addPostFrameCallback((_) async {
                              _joinMeeting();
                            });
                          },
                          child: Row(
                            children: [
                              inCall(snapshot.data)
                                  ? BlinkingButton(child: iconPlay(snapshot))
                                  : iconPlay(snapshot),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        inCall(snapshot.data)
                                            ? StringFile.toqueVideoChamada
                                            : StringFile.iniciarVideo,
                                        style: AppThemeUtils.normalSize(
                                            color: AppThemeUtils.black,
                                            fontSize: 18),
                                      ))),
                              inCall(snapshot.data)
                                  ? BlinkingButton(
                                      child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: AppThemeUtils.black))
                                  : Icon(Icons.arrow_forward_ios_rounded,
                                      color: AppThemeUtils.black),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: inCall(snapshot.data)
                                ? AppThemeUtils.colorPrimary
                                : AppThemeUtils.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                          ),
                        )),
              );
  }

  Container iconPlay(AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
      child: Center(
          child: Icon(
        Icons.play_circle_outline,
        color: inCall(snapshot.data)
            ? AppThemeUtils.colorPrimary
            : AppThemeUtils.whiteColor,
        size: 50,
      )),
      decoration: new BoxDecoration(
        color: inCall(snapshot.data)
            ? AppThemeUtils.whiteColor
            : AppThemeUtils.colorPrimary,
        shape: BoxShape.circle,
      ),
    );
  }

  bool inCall(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot?.data() == null) {
      return false;
    } else if (!(documentSnapshot.data()[MyCurrentAttendanceBloc.TECNO] ??
        false)) {
      // JitsiMeet.closeMeeting();
      return false;
    } else {
      return true;
    }
  }
}
