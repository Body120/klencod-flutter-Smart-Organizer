import 'package:flutter/services.dart';

import '../models/installed_app.dart';

class AppService {
  static const MethodChannel _channel =
      MethodChannel('smart_organizer/apps');

  Future<List<InstalledApp>> getInstalledApps() async {
    final List<dynamic>? result =
        await _channel.invokeMethod<List<dynamic>>('getInstalledApps');

    if (result == null) return <InstalledApp>[];

    return result
        .whereType<Map<dynamic, dynamic>>()
        .map(InstalledApp.fromMap)
        .toList(growable: false);
  }
}
