import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void ShowMessage(String message, {dynamic? context = null}) {
    if (kIsWeb || Platform.isIOS || Platform.isAndroid) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: context != null
              ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
              : Colors.grey[400],
          textColor: context != null
              ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
              : Colors.black,
          fontSize: 16.0);
    } else {
      var cancel = BotToast.showText(text: "$message"); //popup a text toast;
      // cancel(); //close
      print(message);
    }
  }
}
