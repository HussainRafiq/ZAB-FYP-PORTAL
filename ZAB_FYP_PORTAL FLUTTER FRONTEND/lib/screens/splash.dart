import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:provider/provider.dart';

import '../state/settings.module.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<double> _animation;
  late AuthState _authState;
  @override
  void initState() {
    super.initState();

    _authState = context.read<AuthState>();
    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 1000),
    //   vsync: this,
    // )..forward(from: 0);
    // _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    performAction();
  }

  Future<void> performAction() async {
    await Future.delayed(Duration(seconds: 5));
    _authState.checkIsAuthenticated().then((isAuthenticated) {
      Navigator.pushNamedAndRemoveUntil(
          context,
          isAuthenticated
              ? (_authState.user?.role?.toLowerCase() == "student"
                  ? '/home'
                  : (_authState.user?.role?.toLowerCase() == "advisor"
                      ? '/advisor'
                      : ''))
              : '/signinwithemail',
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: double.infinity,
          child: Hero(
            tag: "App_Logo",
            child: Image.asset(
              (Provider.of<SettingsState>(context).isDarkTheme ?? false)
                  ? 'assets/images/logo_invert.png'
                  : 'assets/images/logo.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }
}
