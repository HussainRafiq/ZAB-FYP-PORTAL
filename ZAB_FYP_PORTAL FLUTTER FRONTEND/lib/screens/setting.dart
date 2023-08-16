import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/state/settings.module.dart';
import 'package:lmsv4_flutter_app/utils/globals.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../utils/responsive.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isWindows = !kIsWeb && Platform.isWindows;

  PackageInfo? packageInfo;
  SettingsState? settingsState;
  @override
  initState() {
    settingsState = SettingsState();
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        packageInfo = value;
      });
    });
    settingsState!.addListener(() {
      setState(() {});
    });
    settingsState!.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    settingsState = Provider.of<SettingsState>(context);
    return Scaffold(
      appBar: appBar(context),
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  themeSettingPanel(context),
                  SizedBox(
                    height: 25,
                  ),
                  aboutAppPanel(context)
                ],
              )),
        ],
      ),
    );
  }

  Column themeSettingPanel(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(
          "Theme Settings",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(Icons.dark_mode),
          title: Text("Switch Dark Theme"),
          trailing: Switch(
            onChanged: ((value) {
              settingsState!.switchToDarkTheme(value);
            }),
            value: settingsState!.isDarkTheme ?? false,
            activeColor: Theme.of(context).colorScheme.primary,
            activeTrackColor: Colors.grey.withOpacity(0.3),
            inactiveThumbColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.7),
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
          ),
        ),
      )
    ]);
  }

  Widget aboutAppPanel(BuildContext context) {
    return packageInfo == null
        ? SizedBox()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: SizedBox(
                child: Text(
                  "About ${Globals.Title}",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.shadow.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                title: Text("App Version"),
                trailing: Text("v ${packageInfo!.version}",
                    style: TextStyle(fontWeight: FontWeight.w100)),
              ),
            )
          ]);
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      shape: RoundedRectangleBorder(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Settings",
        style: TextStyle(fontSize: 18, fontFamily: "Circular Std"),
      ),
    );
  }
}
