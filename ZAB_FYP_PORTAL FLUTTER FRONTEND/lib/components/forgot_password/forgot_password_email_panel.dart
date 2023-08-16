import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/components/toaster.dart';
import 'package:lmsv4_flutter_app/constants/messages.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:provider/provider.dart';

class ForgotPasswordEmailPanel extends StatefulWidget {
  final ValueChanged<String>? onCodeSended;

  const ForgotPasswordEmailPanel({Key? key, required this.onCodeSended})
      : super(key: key);

  @override
  State<ForgotPasswordEmailPanel> createState() =>
      _ForgotPasswordEmailPanelState();
}

class _ForgotPasswordEmailPanelState extends State<ForgotPasswordEmailPanel> {
  TextEditingController _userEmailController = TextEditingController();

  AuthState? authState;

  String? sendedVerificationCode = null;

  @override
  initState() {
    super.initState();
    authState = context.read<AuthState>();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
        ),
        Container(
          height: 76,
          width: double.infinity,
          child: Hero(
            tag: "App_Logo",
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: Text(
            "Forgot Password",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        _EmailField(context),
        const SizedBox(
          height: 45,
        ),
        authState?.currentDataState != DataStates.FETCHING
            ? SubmitButton(SizedBox(), "Submit", () => submitButtonPressed())
            : CircularProgressIndicator(),
        const SizedBox(
          height: 20,
        ),
        authState?.currentDataState != DataStates.FETCHING
            ? BackButton()
            : SizedBox(),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  TextField _EmailField(BuildContext context) {
    return TextField(
      autocorrect: true,
      controller: _userEmailController,
      enabled: authState?.currentDataState != DataStates.FETCHING,
      decoration: InputDecoration(
        hintText: 'Enter Your Email',
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
    );
  }

  Future<void> submitButtonPressed() async {
    if (isValidate()) {
      var email = _userEmailController.text;
      String? verificationID =
          await authState?.sendForgotPasswordVerificationCode(email);

      if (verificationID != null) {
        if (widget.onCodeSended != null) {
          widget.onCodeSended!(verificationID);
        }
      }
    }
  }

  Widget SubmitButton(Widget icon, String content, VoidCallback onPressed) {
    return FractionallySizedBox(
      widthFactor: 1, // means 100%, you can change this to 0.8 (80%)
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 10,
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 17),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
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
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimary),
              )
            ],
          ),
          onPressed: onPressed),
    );
  }

  Widget BackButton() {
    return FractionallySizedBox(
      widthFactor: 1, // means 100%, you can change this to 0.8 (80%)
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            primary: Theme.of(context).colorScheme.background,
            onPrimary: Theme.of(context).colorScheme.onSurface,
            padding: const EdgeInsets.symmetric(vertical: 17),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.horizontal,
          children: [
            Text(
              "Back",
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
            )
          ],
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  bool isValidate() {
    var isValidate = true;
    if (_userEmailController.text.isEmpty) {
      CustomToast.ShowMessage(
          LOGIN_SCREEN_EMAIL_AND_PASSWORD_VALIDATION_MESSAGE,
          context: context);
      isValidate = false;
    }
    return isValidate;
  }
}
