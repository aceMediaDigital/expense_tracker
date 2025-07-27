/* =======================================================
 *
 * Created by anele on 27/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceConfig {
  static final DeviceConfig _instance = DeviceConfig._internal();
  factory DeviceConfig() => _instance;
  DeviceConfig._internal();

  bool isIphoneSE = false;

  Future<void> init() async {
    if (!Platform.isIOS) return;

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    final String modelCode = iosInfo.utsname.machine;

    const List<String> seIdentifiers = <String>[
      'iPhone8,4', // SE 1st gen
      'iPhone12,8', // SE 2nd gen
      'iPhone14,6', // SE 3rd gen
    ];

    isIphoneSE = seIdentifiers.contains(modelCode);
  }
}
