import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:luna_lighthouse/core.dart';

class AboutOpenSourceRoute extends StatefulWidget {
  const AboutOpenSourceRoute({
    super.key,
  });

  @override
  State<AboutOpenSourceRoute> createState() => _State();
}

class _State extends State<AboutOpenSourceRoute>
    with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final Future<List<_OpenSourcePackage>> _packages =
      _loadOpenSourcePackages();

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return LunaAppBar(
      title: 'settings.OpenSource'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return FutureBuilder<List<_OpenSourcePackage>>(
      future: _packages,
      builder: (context, snapshot) {
        final packages = snapshot.data;

        if (packages == null) {
          return LunaListView(
            controller: scrollController,
            children: [
              LunaBlock(
                title: 'settings.LoadingOpenSource'.tr(),
                body: [
                  TextSpan(text: 'settings.LoadingOpenSourceDescription'.tr())
                ],
                trailing: const LunaIconButton(icon: Icons.hourglass_top),
              ),
            ],
          );
        }

        return LunaListView(
          controller: scrollController,
          children: [
            LunaBlock(
              title: 'settings.OpenSourcePackages'.tr(),
              body: [
                TextSpan(
                  text: 'settings.OpenSourcePackagesDescription'
                      .tr(args: [packages.length.toString()]),
                )
              ],
              customBodyMaxLines: 2,
              trailing: const LunaIconButton(icon: Icons.list_alt_rounded),
            ),
            LunaDivider(),
            ...packages.map((package) {
              return LunaBlock(
                title: package.name,
                body: [
                  TextSpan(
                    text: 'settings.OpenSourceLicenseCount'
                        .tr(args: [package.licenseCount.toString()]),
                  ),
                ],
                trailing: const LunaIconButton(icon: Icons.article_rounded),
              );
            }),
          ],
        );
      },
    );
  }

  Future<List<_OpenSourcePackage>> _loadOpenSourcePackages() async {
    final packageLicenseCounts = <String, int>{};

    await for (final entry in LicenseRegistry.licenses) {
      for (final package in entry.packages) {
        packageLicenseCounts.update(
          package,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
    }

    packageLicenseCounts.putIfAbsent('Dart', () => 1);
    packageLicenseCounts.putIfAbsent('Flutter', () => 1);

    final packages = packageLicenseCounts.entries
        .map((entry) => _OpenSourcePackage(entry.key, entry.value))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return packages;
  }
}

class _OpenSourcePackage {
  final String name;
  final int licenseCount;

  const _OpenSourcePackage(this.name, this.licenseCount);
}
