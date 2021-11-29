// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationUtils {
//   static const CHANNEL_CREATE_ID_CODE = 150;
//   static const CHANNEL_CREATE_ID = "FAZENDO CHAMADO";
//   static const CHANNEL_CREATE_NAME = "PROCURANDO TECNOANJO";
//   static const CHANNEL_CREATE_DESCRIPTION = "PROCURANDO TECNOANJO PARA CHAMADO";
//
//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('app_icon');
//   static requestPermissions() async {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             MacOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//     /// Note: permissions aren't requested here just to demonstrate that can be
//     /// done later
//     final IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings(
//         requestAlertPermission: false,
//         requestBadgePermission: false,
//         requestSoundPermission: false,
//         onDidReceiveLocalNotification:
//             (int id, String title, String body, String payload) async {
//           // didReceiveLocalNotificationSubject.add(ReceivedNotification(
//           //     id: id, title: title, body: body, payload: payload));
//         });
//     const MacOSInitializationSettings initializationSettingsMacOS =
//     MacOSInitializationSettings(
//         requestAlertPermission: false,
//         requestBadgePermission: false,
//         requestSoundPermission: false);
//     // final InitializationSettings initializationSettings = InitializationSettings(
//     //     android: initializationSettingsAndroid,
//     //     iOS: initializationSettingsIOS,
//     //     macOS: initializationSettingsMacOS);
//     // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//     //     onSelectNotification: (String payload) async {
//     //
//     //     });
//
//     createNotificationChannel();
//   }
//
//   static createNotificationChannel() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//             CHANNEL_CREATE_ID, CHANNEL_CREATE_NAME, CHANNEL_CREATE_DESCRIPTION,
//             channelShowBadge: false,
//             importance: Importance.max,
//             priority: Priority.high,ongoing: true,
//             onlyAlertOnce: true,
//             showProgress: true,
//             indeterminate: true);
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails( androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         CHANNEL_CREATE_ID_CODE,
//         'indeterminate progress notification title',
//         'indeterminate progress notification body',
//         platformChannelSpecifics,
//         payload: 'item x');
//   }
// }
