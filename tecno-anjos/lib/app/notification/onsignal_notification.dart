import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tecnoanjostec/app/app_bloc.dart';
import 'package:tecnoanjostec/app/configuration/aws_configuration.dart';


class OnsignalNotification {
  var appBloc = Modular.get<AppBloc>();
  void closeAllNotifications() {

  }

  Future<void> initPlatformState() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      OneSignal.shared.setSubscription(true);

      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
      OneSignal.shared.init(AwsConfiguration.pushApi, iOSSettings: {
        OSiOSSettings.autoPrompt: true,
        OSiOSSettings.inAppLaunchUrl: false
      });
      OneSignal.shared.setRequiresUserPrivacyConsent(false);

      var settings = {
        OSiOSSettings.autoPrompt: true,
        OSiOSSettings.promptBeforeOpeningPushUrl: true
      };

      OneSignal.shared
          .setNotificationReceivedHandler((OSNotification notification) {
        try {
          closeAllNotifications();
        } catch (e) {
          print(e);
        }

      });

      OneSignal.shared
          .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
        try {
          closeAllNotifications();
        } catch (e) {
          print(e);
        }

      });


      OneSignal.shared
          .setInAppMessageClickedHandler((OSInAppMessageAction action) {
        print(
            "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}");
      });

      OneSignal.shared
          .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
        print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
      });

      OneSignal.shared
          .setPermissionObserver((OSPermissionStateChanges changes) {
        print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
      });

      OneSignal.shared.setEmailSubscriptionObserver(
              (OSEmailSubscriptionStateChanges changes) {
            print(
                "EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
          });

      // NOTE: Replace with your own app ID from https://www.onesignal.com
      await OneSignal.shared
          .init(AwsConfiguration.pushApi, iOSSettings: settings);

      OneSignal.shared
          .setInFocusDisplayType(OSNotificationDisplayType.notification);

    });
  }



  void handleSetExternalUserId() {
    var appBloc = Modular.get<AppBloc>();
    appBloc.getCurrentUserFutureValue().listen((currentUser) {
      String _externalUserId = currentUser?.id.toString();

      OneSignal.shared.setExternalUserId(_externalUserId).then((results) {
        if (results == null) return;
        print("External user id set: $results $_externalUserId");
      });
    });
  }

  void handleRemoveExternalUserId() {
    if (!kIsWeb) {
      OneSignal.shared.setSubscription(false);
      OneSignal.shared.removeExternalUserId().then((results) {
        if (results == null) return;
        print("External user id removed: $results");
      });
    }
  }
}
