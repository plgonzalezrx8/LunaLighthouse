import 'dart:io';

import 'package:luna_lighthouse/database/tables/luna_lighthouse.dart';
import 'package:luna_lighthouse/vendor.dart';

// ignore: always_use_package_imports
import '../network.dart';

bool isPlatformSupported() => true;
LunaNetwork getNetwork() => IO();

class IO extends HttpOverrides implements LunaNetwork {
  @override
  void initialize() {
    HttpOverrides.global = IO();
  }

  String generateUserAgent(PackageInfo info) {
    return '${info.appName}/${info.version} ${info.buildNumber}';
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = super.createHttpClient(context);

    // Disable TLS validation
    if (!LunaLighthouseDatabase.NETWORKING_TLS_VALIDATION.read())
      client.badCertificateCallback = (cert, host, port) => true;

    // Set User-Agent
    PackageInfo.fromPlatform()
        .then((info) => client.userAgent = generateUserAgent(info))
        .catchError((_) => client.userAgent = 'LunaLighthouse/Unknown');

    return client;
  }
}
