import 'package:flutter/material.dart';
import 'package:luna_lighthouse/database/tables/luna_lighthouse.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/system/platform.dart';

class LunaScaffold extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final LunaModule? module;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  /// Called when [LunaLighthouseDatabase.ENABLED_PROFILE] has changed. Triggered within the build function.
  final void Function(BuildContext)? onProfileChange;

  // ignore: use_key_in_widget_constructors
  const LunaScaffold({
    required this.scaffoldKey,
    this.module,
    this.appBar,
    this.body,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.onProfileChange,
  });

  @override
  State<LunaScaffold> createState() => _LunaScaffoldState();
}

class _LunaScaffoldState extends State<LunaScaffold> {
  bool _isDrawerOpen = false;

  bool get _shouldOpenDrawerOnBack {
    if (!LunaLighthouseDatabase.ANDROID_BACK_OPENS_DRAWER.read()) return false;
    return widget.drawer != null && !_isDrawerOpen;
  }

  @override
  Widget build(BuildContext context) {
    if (LunaPlatform.isAndroid) return android;
    return scaffold;
  }

  Widget get android {
    return PopScope<void>(
      canPop: !_shouldOpenDrawerOnBack,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || !_shouldOpenDrawerOnBack) return;
        widget.scaffoldKey.currentState?.openDrawer();
      },
      child: scaffold,
    );
  }

  Widget get scaffold {
    return LunaLighthouseDatabase.ENABLED_PROFILE.listenableBuilder(
      builder: (context, _) {
        widget.onProfileChange?.call(context);
        return Scaffold(
          key: widget.scaffoldKey,
          appBar: widget.appBar,
          body: widget.body,
          drawer: widget.drawer,
          bottomNavigationBar: widget.bottomNavigationBar,
          floatingActionButton: widget.floatingActionButton,
          extendBody: widget.extendBody,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
          onDrawerChanged: (isOpen) {
            FocusManager.instance.primaryFocus?.unfocus();
            if (_isDrawerOpen == isOpen) return;
            setState(() => _isDrawerOpen = isOpen);
          },
        );
      },
    );
  }
}
