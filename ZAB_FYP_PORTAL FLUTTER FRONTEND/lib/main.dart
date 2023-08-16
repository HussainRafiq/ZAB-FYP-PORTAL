import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/state/advisor.module.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:lmsv4_flutter_app/state/group.module.dart';
import 'package:lmsv4_flutter_app/state/proposal.module.dart';
import 'package:lmsv4_flutter_app/state/settings.module.dart';
import 'package:lmsv4_flutter_app/state/user.module.dart';
import 'package:lmsv4_flutter_app/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:lmsv4_flutter_app/utils/register_platform_Wise/register_web_webview_stub.dart'
    if (dart.library.html) 'package:lmsv4_flutter_app/utils/register_platform_Wise/register_web_webview.dart';

import '../router/route_generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerWebViewWebImplementation();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthState>.value(value: AuthState()),
      ChangeNotifierProvider<AdvisorState>.value(value: AdvisorState()),
      ChangeNotifierProvider(create: (context) => UserState()),
      ChangeNotifierProvider<SettingsState>.value(value: SettingsState()),
      ChangeNotifierProvider<GroupState>.value(value: GroupState()),
      ChangeNotifierProvider<ProposalState>.value(value: ProposalState()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SettingsState? settingsState;

  @override
  initState() {
    settingsState = context.read<SettingsState>();

    settingsState!.addListener(() {
      setState(() {});
    });
    settingsState!.checkTheme().then((value) {
      if (value == null) {
        settingsState!.switchToDarkTheme(
            MediaQuery.of(context).platformBrightness == Brightness.dark);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Globals.Title,
      darkTheme: ThemeData(
        colorScheme: darkTheme(),
        fontFamily: 'Circular Std',
      ),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        colorScheme: lightTheme(),
        fontFamily: 'Circular Std',
      ),
      themeMode: Provider.of<SettingsState>(context).isDarkTheme ?? false
          ? ThemeMode.dark
          : ThemeMode.light,
      initialRoute: '/splash',
      onGenerateRoute: RouteGenerator.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }

  ColorScheme lightTheme() {
    return ColorScheme.light(
      primary: Color(0xFF174578),
      background: Color(0xFFF3F6FF),
      onBackground: Color(0xFF174578),
      onSurface: Color.fromARGB(255, 62, 66, 70),
      onPrimary: Colors.white,
      secondary: Color.fromRGBO(255, 196, 0, 1),
      onSecondary: Colors.white,
    );
  }

  ColorScheme darkTheme() {
    return ColorScheme.dark(
        primary: Color(0xFF174578),
        onPrimary: Colors.white,
        secondary: Color.fromRGBO(255, 196, 0, 1),
        onSecondary: Colors.white,
        outline: Color.fromRGBO(221, 221, 221, 1),
        surface: Color(0xFF232323),
        secondaryContainer: Colors.black,
        onSecondaryContainer: Colors.grey[600],
        shadow: Colors.black,
        onSurface: Colors.white);
  }
}
