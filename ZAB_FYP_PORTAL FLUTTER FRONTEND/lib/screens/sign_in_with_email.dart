import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/components/toaster.dart';
import 'package:lmsv4_flutter_app/constants/messages.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:provider/provider.dart';

import '../state/group.module.dart';

class SignInWithEmail extends StatefulWidget {
  SignInWithEmail({Key? key}) : super(key: key);

  @override
  State<SignInWithEmail> createState() => _SignInWithEmailState();
}

class _SignInWithEmailState extends State<SignInWithEmail> {
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late FocusNode _passwordFocusNode;
  late AuthState authState;

  @override
  initState() {
    super.initState();
    authState = AuthState();
    _passwordFocusNode = FocusNode();

    authState.addListener(() {
      // if (authState.AuthStatus == AuthenticationStatus.FAILED) {
      //   onAuthenticationFailed(authState.AuthMessage);
      // }
      if (authState.AuthStatus == AuthenticationStatus.AUTHENTICATED) {
        onAuthenticated();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   title: Text("SignIn With Email",
      //       textAlign: TextAlign.center,
      //       style: TextStyle(
      //         fontSize: 14,
      //         color: Theme.of(context).colorScheme.onPrimary,
      //       )),
      // ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            constraints: BoxConstraints(
                maxWidth: 500, minHeight: MediaQuery.of(context).size.height),
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Welcome!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    "assets/images/login_right.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.125,
                          ),
                          SizedBox(
                            width: 300,
                            child: Text(
                              "Proceed with your",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w100,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 300,
                            child: Text(
                              "Login",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            _SignInEmailField(context),
                            const SizedBox(
                              height: 20,
                            ),
                            _SignInPasswordField(context),
                            const SizedBox(
                              height: 5,
                            ),
                            _ForgotPasswordLink(context),
                            const SizedBox(
                              height: 45,
                            ),
                            authState.AuthStatus !=
                                    AuthenticationStatus.AUTHENTICATING
                                ? LoginButton(SizedBox(), "Login",
                                    () => signWithEmailOnPressed())
                                : CircularProgressIndicator(),
                            const SizedBox(
                              height: 20,
                            ),
                            // TextButton(
                            //   child: const Text(
                            //     "Privacy Policy",
                            //     style: TextStyle(fontSize: 15),
                            //   ),
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => const PrivacyPolicy()),
                            //     );
                            //   },
                            // ),
                            // authState.AuthStatus !=
                            //         AuthenticationStatus.AUTHENTICATING
                            //     ? Text(
                            //         "Don't Have An Account?",
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //           fontSize: 15,
                            //           color:
                            //               Theme.of(context).colorScheme.onBackground,
                            //         ),
                            //       )
                            //     : SizedBox(),
                            // authState.AuthStatus !=
                            //         AuthenticationStatus.AUTHENTICATING
                            //     ? Center(
                            //         child: InkWell(
                            //         child: Text(
                            //           "Create An Accpunt",
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //             fontSize: 15,
                            //             fontWeight: FontWeight.bold,
                            //             decoration: TextDecoration.underline,
                            //             color: Theme.of(context)
                            //                 .colorScheme
                            //                 .onBackground,
                            //           ),
                            //         ),
                            //       ))
                            //     : SizedBox(),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  Row _ForgotPasswordLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/forgetpassword");
          },
          child: Text(
            "Forgot Password ?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        )
      ],
    );
  }

  TextField _SignInPasswordField(BuildContext context) {
    return TextField(
      autocorrect: true,
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      enabled: authState.AuthStatus != AuthenticationStatus.AUTHENTICATING,
      decoration: InputDecoration(
        hintText: 'Enter Password',
        prefixIcon: Icon(
          Icons.lock,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
    );
  }

  TextField _SignInEmailField(BuildContext context) {
    return TextField(
      autocorrect: true,
      controller: _userEmailController,
      enabled: authState.AuthStatus != AuthenticationStatus.AUTHENTICATING,
      decoration: InputDecoration(
        hintText: 'Enter Your Email / Username / Phone',
        prefixIcon: Icon(
          Icons.person_outline,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
      onSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
    );
  }

  Widget LoginButton(Widget icon, String content, void onPressed) {
    return FractionallySizedBox(
      widthFactor: 1, // means 100%, you can change this to 0.8 (80%)
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            primary: Theme.of(context).colorScheme.primary,
            onPrimary: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 17),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.horizontal,
          children: [
            icon,
            SizedBox(
              width: 10,
            ),
            Text(
              content,
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).colorScheme.onPrimary),
            )
          ],
        ),
        onPressed: () {
          signWithEmailOnPressed();
        },
      ),
    );
  }

  Future<void> signWithEmailOnPressed() async {
    if (isValidate()) {
      var email = _userEmailController.text;
      var password = _passwordController.text;
      await authState.login(email, password);
    }
  }

  void onAuthenticationFailed(String? Message) {
    CustomToast.ShowMessage(Message!, context: context);
  }

  void onAuthenticated() {
    if (authState.user != null) {
      if (authState.user?.role?.toLowerCase() == "student") {
        context.read<GroupState>().getGroup();
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', (Route<dynamic> route) => false);
      } else if (authState.user?.role?.toLowerCase() == "advisor") {
        context.read<GroupState>().getGroup();
        Navigator.pushNamedAndRemoveUntil(
            context, '/advisor', (Route<dynamic> route) => false);
      }
    }
  }

  bool isValidate() {
    var isValidate = true;
    if (_userEmailController.text.isEmpty || _passwordController.text.isEmpty) {
      CustomToast.ShowMessage(
          LOGIN_SCREEN_EMAIL_AND_PASSWORD_VALIDATION_MESSAGE,
          context: context);
      isValidate = false;
    }
    return isValidate;
  }
}
