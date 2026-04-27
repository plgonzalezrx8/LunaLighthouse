import 'package:flutter/material.dart';
import 'package:luna_lighthouse/database/tables/bios.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/router/routes.dart';
import 'package:luna_lighthouse/router/routes/dashboard.dart';
import 'package:luna_lighthouse/system/bios.dart';
import 'package:luna_lighthouse/vendor.dart';

enum BIOSRoutes with LunaRoutesMixin {
  HOME('/');

  @override
  final String path;

  const BIOSRoutes(this.path);

  @override
  LunaModule? get module => null;

  @override
  bool isModuleEnabled(BuildContext context) => true;

  @override
  GoRoute get routes {
    switch (this) {
      case BIOSRoutes.HOME:
        return redirect(redirect: (context, _) {
          LunaOS().boot(context);

          final fallback = DashboardRoutes.HOME.path;
          return BIOSDatabase.BOOT_MODULE.read().homeRoute ?? fallback;
        });
    }
  }
}
