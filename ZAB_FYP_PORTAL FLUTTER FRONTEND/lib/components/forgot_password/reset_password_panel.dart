import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:provider/provider.dart';

class ResetPasswordPanel extends StatefulWidget {
  final ValueChanged<bool>? onReseted;
  final String SendedVerificationCode;

  const ResetPasswordPanel(
      {Key? key, required this.onReseted, required this.SendedVerificationCode})
      : super(key: key);

  @override
  State<ResetPasswordPanel> createState() => _ResetPasswordPanelState();
}

class _ResetPasswordPanelState extends State<ResetPasswordPanel> {
  AuthState? authState;

  TextEditingController _userPasswordController = TextEditingController();

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
            "Reset Password",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 300,
          child: Text(
            "Enter the password to reset",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        _PasswordField(context),
        const SizedBox(
          height: 45,
        ),
        authState?.currentDataState != DataStates.FETCHING
            ? SubmitButton(
                SizedBox(),
                "Reset Password",
                () async {
                  await submit(context);
                },
              )
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

  Future<void> submit(BuildContext context) async {
    if (_userPasswordController.text.isNotEmpty) {
      bool? isReseted = await authState?.resetPassword(
          widget.SendedVerificationCode, _userPasswordController.text);
      setState(() {});
      if (isReseted == true && widget.onReseted != null) {
        widget.onReseted!(isReseted!);
      }
    }
  }

  TextField _PasswordField(BuildContext context) {
    return TextField(
      autocorrect: true,
      obscureText: true,
      controller: _userPasswordController,
      enabled: authState?.currentDataState != DataStates.FETCHING,
      decoration: InputDecoration(
        hintText: 'Enter Your Password',
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
}
