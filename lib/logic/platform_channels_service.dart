import 'dart:async';

import 'package:flutter/services.dart';

class PlatformChannelService {
  static const _batteryChannel = MethodChannel('battery_level_app/battery');
  static const chargingChannel = EventChannel('battery_level_app/charging');

  static Future<String> getBatteryLevel() async {
    final testArguments = {'name': 'Current battery level is'};
    final batteryLevel =
        await _batteryChannel.invokeMethod('getBatteryLevel', testArguments);

    return batteryLevel;
  }

  
}
