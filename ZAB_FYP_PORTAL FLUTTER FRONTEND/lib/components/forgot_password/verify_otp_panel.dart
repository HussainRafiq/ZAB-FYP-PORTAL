import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/components/toaster.dart';
import 'package:lmsv4_flutter_app/constants/messages.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VerifyOTPPanel extends StatefulWidget {
  final ValueChanged<String>? onValidated;
  final String SendedVerificationCode;

  const VerifyOTPPanel(
      {Key? key,
      required this.onValidated,
      required this.SendedVerificationCode})
      : super(key: key);

  @override
  State<VerifyOTPPanel> createState() => _VerifyOTPPanelState();
}

class _VerifyOTPPanelState extends State<VerifyOTPPanel> {
  AuthState? authState;

  final pinController = TextEditingController();

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
            "Verify OTP",
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
            "Enter the code sent to the email",
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
        _SMSOTPField(context),
        const SizedBox(
          height: 45,
        ),
        authState?.currentDataState != DataStates.FETCHING
            ? SubmitButton(
                SizedBox(),
                "Verify",
                () {
                  if (pinController.length == 6) {
                    validateOTP(pinController.text);
                  }
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

  Widget _SMSOTPField(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 2),
      ),
    );

    return Directionality(
      // Specify direction if desired
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: pinController,
        length: 6,
        androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
        keyboardType: TextInputType.number,
        listenForMultipleSmsOnAndroid: true,
        defaultPinTheme: defaultPinTheme,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        onCompleted: (pin) {
          validateOTP(pin);
        },
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 9),
              width: 22,
              height: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
            ),
          ],
        ),
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9)),
          ),
        ),
        submittedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9)),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyBorderWith(
          border: Border.all(color: Colors.redAccent),
        ),
      ),
    );
  }

  void validateOTP(String pin) {
    authState!
        .verifyVerificationCode(widget.SendedVerificationCode, pin)
        .then((value) {
      if (value != null && widget.onValidated != null) {
        widget.onValidated!(value);
      }
    });
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
