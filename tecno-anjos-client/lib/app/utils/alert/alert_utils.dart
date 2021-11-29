import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/my_current_attendance_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/chat_tecno_client/chat_attendance/model/conversation.dart';

import 'package:tecnoanjosclient/app/utils/attendance/activity_utils.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/preferences/cd_preferences.dart';
import '../../app_bloc.dart';

class AlertUtils {
  static const String SOUND_ATTENDANCE = 'SOUND_ATTENDANCE';
  static const String SOUND_ATTENDANCE_STATUS = 'SOUND_ATTENDANCE_STATUS';
  static const String SOUND_ATTENDANCE_SMS = 'SOUND_ATTENDANCE_SMS';

  static Future<bool> getAndUpdateAttendance(Attendance attendance) async {
    var lock = new Lock();
    return await lock.synchronized(() async {
      final tempContent =
          await codePreferences.getString(key: SOUND_ATTENDANCE);
      if (attendance.status == tempContent) {
        return false;
      } else {
        await codePreferences.set(
            key: SOUND_ATTENDANCE, value: attendance.status);
        return true;
      }
    });
  }

  static msgRigtone(Attendance attendance) async {
    final appBloc = Modular.get<AppBloc>();
    var user = appBloc.getCurrentUserFutureValue().stream.value;
    var lock = Lock();
    if (attendance?.id != null) {
      Modular.get<AppBloc>()
          .firebaseReference()
          .collection('MESSAGE')
          .doc("CHAT_ATTENDANCE")
          .collection(attendance?.id.toString())
          .snapshots()
          ?.listen((resulted) async {
        lock.synchronized(() async {
          var resume =
              resulted.docs.map((e) => Conversation.fromMap(e.data())).toList();
          var count = (resume
                      .where((element) => element?.sender?.id != user?.id)
                      ?.toList()
                      ?.length ??
                  0)
              .toString();
          var codeAttendanceSound =
              await codePreferences.getString(key: SOUND_ATTENDANCE_SMS);
          if (codeAttendanceSound != (count) && count != "0") {
            codePreferences.set(key: SOUND_ATTENDANCE_SMS, value: (count));
            try {
              var user = appBloc.getCurrentUserFutureValue().stream.value;
              if (user?.id != null) {
                final assetsAudioPlayer = AssetsAudioPlayer();

                assetsAudioPlayer.open(
                  Audio(ImagePath.smsNotification),
                );
                assetsAudioPlayer.playOrPause();
              }
              //...
              //     AudioPlayer audioPlugin = AudioPlayer();
// //...
//           AudioCache audioCache = AudioCache(
//             fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.RELEASE)..stop(),duckAudio: true,respectSilence: false
//           );
              HapticFeedback.mediumImpact();
              // await audioPlugin.play(ImagePath.);
            } catch (e) {
              print(e);
            }
          }
        });
      });
    }
  }

  static playCalledOnCurrent() async {
    final appBloc = Modular.get<AppBloc>();
    var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
    var user = await currentBloc.collectionDocUser();
    var lock = Lock();
    currentBloc.streamToCurrentService(user)?.listen((snapshotService) {
      currentBloc
          .streamToCurrent(currentBloc.myCurrentService(snapshotService))
          ?.listen((attendance) async {
        lock.synchronized(() async {
          if (attendance?.id != null) {
            var codeAttendanceSound =
                await codePreferences.getString(key: SOUND_ATTENDANCE_STATUS);
            if (codeAttendanceSound !=
                (attendance?.id.toString() + attendance.status)) {
              codePreferences.set(
                  key: SOUND_ATTENDANCE_STATUS,
                  value: (attendance?.id.toString() + attendance.status));
              try {
                var user = appBloc.getCurrentUserFutureValue().stream.value;
                if (user?.id != null) {
                  getAndUpdateAttendance(attendance).then((value) {
                    if (value) {
                      final assetsAudioPlayer = AssetsAudioPlayer();
                      if (attendance.status == ActivityUtils.REMOTAMENTE ||
                          attendance.status == ActivityUtils.PRESENCIAL) {
                        HapticFeedback.mediumImpact();

                        assetsAudioPlayer.open(
                          Audio(ImagePath.sound),
                        );
                        print("#rabanada sound ${attendance.status}");
                        assetsAudioPlayer.playOrPause();
                      } else {
                        HapticFeedback.mediumImpact();
                        assetsAudioPlayer.open(
                          Audio(ImagePath.soundSimple),
                        );
                        print("#rabanada soundSimple ${attendance.status}");
                        assetsAudioPlayer.playOrPause();
                      }
                    }
                  });
                }
                //...
                // AudioPlayer audioPlugin = AudioPlayer();
// //...
//           AudioCache audioCache = AudioCache(
//             fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.RELEASE)..stop(),duckAudio: true,respectSilence: false
//           );

                // await audioPlugin.play();
              } catch (e) {
                print(e);
              }
            }
          }
        });
      });
    });
  }
}
