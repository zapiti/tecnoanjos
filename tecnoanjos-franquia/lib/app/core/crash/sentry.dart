import 'dart:async';
import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry/sentry.dart';

const String _dsn =
    "https://2e0b8d8b04504612978edb2144b0caa5@o412035.ingest.sentry.io/5302639";

SentryClient _sentryClient;

Future<void> runSentry(Function func) async {
  _setCustomFlutterError();

  runZoned<Future<Null>>(
    () => func.call(),
    onError: (error, stackTrace) async {
      await _reportError(error, stackTrace);
    },
  );

  _sentryClient = await createClient();
}

/**
 * Catch and report Flutter errors
 */
void _setCustomFlutterError() {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/**
 * Catch and report Dart errors
 */
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
 debugPrint('Caught error: $error');

  if (isInDebugMode) {
   debugPrint(stackTrace);
   debugPrint('In dev mode. Not sending report to Sentry.io.');
    return;
  }

 debugPrint('Reporting to Sentry.io...');
  _sentryClient
      .captureException(
        exception: error,
        stackTrace: stackTrace,
      )
      .then((response) => loggingResponse(response));
}

/**
 * Custom Event
 */
Future<void> captureEvent({
  String eventId,
  String eventMessage,
}) async {
 debugPrint('captureEvent to Sentry.io...');

  final Event event = await createEnv(
    isError: false,
    eventMessage: eventMessage,
    tags: {'app_version': '1.0', 'eventId': eventId},
  );

  await _sentryClient
      .capture(event: event)
      .then((response) => loggingResponse(response));
}

void loggingResponse(SentryResponse response) {
  if (response.isSuccessful) {
   debugPrint('Success! Event ID: ${response.eventId}');
  } else {
   debugPrint('Failed to report to Sentry.io: ${response.error}');
  }
}

Future<SentryClient> createClient() async {
  final Event env = await createEnv(tags: {'app_version': '1.0'});
  return SentryClient(
    dsn: _dsn,
    environmentAttributes: env,
  );
}

Future<Event> createEnv({
  bool isError = true,
  String eventMessage,
  Map<String, String> tags,
}) async {
  final _contexts = await getContexts();

  return Event(
    level: isError ? SeverityLevel.error : SeverityLevel.info,
    tags: tags,
    message: isError ? null : eventMessage,
    contexts: _contexts,
  );
}

Future<Contexts> getContexts() async {
  if (kIsWeb) {
    return Contexts(
        device: Device(
          model: "Web",
          manufacturer: "Web",
        ),
        app: App(
            version: 'Web', buildType: isInDebugMode ? 'debug' : 'release'));
  } else {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
     debugPrint(
          'Android $release (SDK $sdkInt), $manufacturer $model'); // Android 9 (SDK 28), samsung SM-N976N

      return Contexts(
        device: Device(
          model: model,
          manufacturer: manufacturer,
        ),
        app: App(
            version: '$release (SDK $sdkInt)',
            buildType: isInDebugMode ? 'debug' : 'release'),
      );
    } else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;

     debugPrint(
          '$systemName $version, $name ,$model'); // iOS 13.1, iPhone 11 Pro Max, iPhone

      return Contexts(
        device: Device(
          model: name,
          manufacturer: 'apple',
        ),
        app: App(
          version: version,
          buildType: isInDebugMode ? 'debug' : 'release',
        ),
      );
    } else {
      throw 'Not Supported OS';
    }
  }
}
