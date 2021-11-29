import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tecnoanjostec/app/modules/firebase/current_attendance/start_called/current_attendance_bloc.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/chat_tecno_client/chat_attendance/model/conversation.dart';
import 'package:tecnoanjostec/app/utils/firebase/firebase_client_tecnoanjo.dart';
import 'package:tecnoanjostec/app/utils/image/image_path.dart';
import 'package:tecnoanjostec/app/utils/preferences/cd_preferences.dart';

import '../../app_bloc.dart';

class AlertUtils {
  static const String SOUND_ATTENDANCE = 'SOUND_ATTENDANCE';
  static const String SOUND_ATTENDANCE_STATUS = 'SOUND_ATTENDANCE_STATUS';
  static const String SOUND_ATTENDANCE_SMS = 'SOUND_ATTENDANCE_SMS';

  static Future<bool> getAndUpdateAttendance(Attendance attendance) async {
    final tempContent = await codePreferences.getString(key: SOUND_ATTENDANCE);
    if (attendance.status == tempContent) {
      return false;
    } else {
      await codePreferences.set(
          key: SOUND_ATTENDANCE, value: attendance.status);
      return true;
    }
  }

  static msgRigtone(Attendance attendance) async {
    var appBloc = Modular.get<AppBloc>();
    var user = appBloc.getCurrentUserFutureValue().stream.value;
    if (attendance?.id != null) {
      Modular.get<AppBloc>()
          .firebaseReference()
          .collection('MESSAGE')
          .doc("CHAT_ATTENDANCE")
          .collection(attendance?.id.toString())
          .snapshots()
          ?.listen((resulted) async {
        var resume =
            resulted.docs.map((e) => Conversation.fromMap(e.data())).toList();
        var count = (resume
                    .where((element) => element.sender?.id != user?.id)
                    ?.toList()
                    ?.length ??
                0)
            .toString();
        var codeAttendanceSound =
            await codePreferences.getString(key: SOUND_ATTENDANCE_SMS);
        if (codeAttendanceSound != (count) && count != "0") {
          codePreferences.set(key: SOUND_ATTENDANCE_SMS, value: (count));
          try {
            if (user?.id != null) {
              if (attendance?.userTecno?.id == null) {
              } else if (attendance?.userTecno?.id == user.id) {
                final assetsAudioPlayer = AssetsAudioPlayer();

                assetsAudioPlayer.open(
                  Audio(ImagePath.smsNotification),
                );

                assetsAudioPlayer.playOrPause();
                HapticFeedback.mediumImpact();
              }
            }
          } catch (e) {
            print(e);
          }
        }
      });
    }
  }

  static playCalledOnCurrent() async {
    var appBloc = Modular.get<AppBloc>();
    var currentBloc = GetIt.I.get<MyCurrentAttendanceBloc>();
    var user = currentBloc.collectionDocUser();
    var lock = Lock();
    currentBloc.streamToCurrentService(user)?.listen((snapshotService) {
      currentBloc
          .streamToCurrent(currentBloc.myCurrentService(snapshotService))
          ?.listen((snapshotCurrent) async {
        lock.synchronized(() async {
          var attendance = snapshotCurrent;
          if (attendance?.id != null) {
            getAndUpdateAttendance(attendance).then((value) async {
              if (value) {
                var codeAttendanceSound = await codePreferences.getString(
                    key: SOUND_ATTENDANCE_STATUS);
                if (codeAttendanceSound !=
                    (attendance?.id.toString() + attendance.status)) {
                  codePreferences.set(
                      key: SOUND_ATTENDANCE_STATUS,
                      value: (attendance?.id.toString() + attendance.status));
                  try {
                    var user = appBloc.getCurrentUserFutureValue().stream.value;
                    if (user?.id != null) {
                      HapticFeedback.mediumImpact();

                      if (attendance?.userTecno?.id == null) {
                      } else if (attendance?.userTecno?.id == user.id) {
                        final assetsAudioPlayer = AssetsAudioPlayer();
                        assetsAudioPlayer.open(
                          Audio(ImagePath.soundSimple),
                        );
                        assetsAudioPlayer.playOrPause();
                      }
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              }
            });
          }
        });
      });
    });
  }

  static playCalledOnAttendance() async {
    var appBloc = Modular.get<AppBloc>();
    var lock = Lock();
    Modular.get<FirebaseClientTecnoanjo>()
        .getDataAcceptSnapshot()
        ?.listen((snapshot) async {
      lock.synchronized(() async {
        if (snapshot.docs.isNotEmpty) {
          var attend = snapshot.docs.first.data();
          var attendance = Attendance.fromMap(attend);
          if (attendance?.id != null) {
            var codeAttendanceSound =
                await codePreferences.getString(key: SOUND_ATTENDANCE);
            if (codeAttendanceSound != attendance?.id.toString()) {
              codePreferences.set(
                  key: SOUND_ATTENDANCE, value: attendance?.id.toString());
              try {
                var user = appBloc.getCurrentUserFutureValue().stream.value;
                if (user?.id != null) {
                  final assetsAudioPlayer = AssetsAudioPlayer();
                  assetsAudioPlayer.open(
                    Audio(ImagePath.sound),
                  );
                  HapticFeedback.mediumImpact();
                }
              } catch (e) {
                print(e);
              }
            }
          }
        }
      });
    });
  }
}
