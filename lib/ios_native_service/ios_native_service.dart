import 'package:flutter/services.dart';

class IosNativeService {
  static const _batteryChannel = MethodChannel('battery_level_app/battery');

  static Future<int> getBatteryLevel() async {
    final testArguments = {'name': 'Example String'};
    final int batteryLevel =
        await _batteryChannel.invokeMethod('getBatteryLevel', testArguments);
    return batteryLevel;
  }
}
