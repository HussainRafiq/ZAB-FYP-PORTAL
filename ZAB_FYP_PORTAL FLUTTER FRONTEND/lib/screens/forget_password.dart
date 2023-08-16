import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/components/forgot_password/forgot_password_email_panel.dart';
import 'package:lmsv4_flutter_app/components/forgot_password/reset_password_panel.dart';
import 'package:lmsv4_flutter_app/components/forgot_password/verify_otp_panel.dart';
import 'package:lmsv4_flutter_app/components/toaster.dart';
import 'package:lmsv4_flutter_app/constants/messages.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isEmailSended = false, isVerified = false;
  AuthState? authState;
  String? sendedVerificationCode = null;
  @override
  initState() {
    super.initState();
    authState = context.read<AuthState>();
    authState?.addListener(() {
      setState(() {});
      if (authState?.currentDataState == DataStates.FAILED) {
        CustomToast.ShowMessage(authState?.AuthMessage ?? SOME_ERROR_OCCURRED,
            context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
              maxWidth: 500, minHeight: MediaQuery.of(context).size.height),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: isEmailSended
                      ? isVerified
                          ? resetPassword(context)
                          : verifyOTP()
                      : forgotPassword(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ForgotPasswordEmailPanel forgotPassword() {
    return ForgotPasswordEmailPanel(
      onCodeSended: (verificationID) {
        setState(() {
          isEmailSended = true;
          sendedVerificationCode = verificationID;
        });
      },
    );
  }

  VerifyOTPPanel verifyOTP() {
    return VerifyOTPPanel(
      SendedVerificationCode: sendedVerificationCode!,
      onValidated: (value) {
        setState(() {
          sendedVerificationCode = value;
          isVerified = true;
        });
      },
    );
  }

  ResetPasswordPanel resetPassword(BuildContext context) {
    return ResetPasswordPanel(
      SendedVerificationCode: sendedVerificationCode!,
      onReseted: (isReseted) {
        if (isReseted) {
          CustomToast.ShowMessage("Password Reseted Succesfully",
              context: context);
          Navigator.pushNamedAndRemoveUntil(
              context, '/signinwithemail', (Route<dynamic> route) => false);
        }
      },
    );
  }
}
