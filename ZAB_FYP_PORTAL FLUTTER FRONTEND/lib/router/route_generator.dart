import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/screens/advisor.dart';
import 'package:lmsv4_flutter_app/screens/edit_profile.dart';
import 'package:lmsv4_flutter_app/screens/forget_password.dart';
import 'package:lmsv4_flutter_app/screens/home.dart';
import 'package:lmsv4_flutter_app/screens/register.dart';
import 'package:lmsv4_flutter_app/screens/sign_in_with_email.dart';
import '../screens/splash.dart';

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      // case '/':
      //   return MaterialPageRoute(
      //     builder: (_) => MyHomePage(),
      //   );
      case '/splash':
        return MaterialPageRoute(
          builder: (_) => const Splash(),
        );
      // case '/register':
      //   return MaterialPageRoute(
      //     builder: (_) => Register(),
      //   );
      case '/signinwithemail':
        return MaterialPageRoute(
          builder: (_) => SignInWithEmail(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
      case '/editprofile':
        return MaterialPageRoute(
          builder: (_) => EditProfilePage(),
        );
      case '/forgetpassword':
        return MaterialPageRoute(
          builder: (_) => ForgetPassword(),
        );
      case '/advisor':
        return MaterialPageRoute(
          builder: (_) => Advisor(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => errorPage,
        );
    }
  }

  static Widget errorPage = Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFF174578),
      title: const Text('Error'),
    ),
    body: const Center(
      child: Text("Error"),
    ),
  );
}
