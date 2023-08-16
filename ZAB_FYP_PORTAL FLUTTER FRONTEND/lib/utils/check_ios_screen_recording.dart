import 'dart:io';

import 'package:flutter/services.dart';

class CheckScreenRecordingIOS {
  static const platform = MethodChannel("checkIsScreenRecordingOnIOS");

  Future<bool> isRecording() async {
    bool isRecording;

    try {
      if (Platform.isIOS) {
        isRecording = await platform.invokeMethod("isScreenRecording");
      } else {
        isRecording = false;
      }
    } catch (ex) {
      isRecording = false;
    }

    return isRecording;
  }
}
