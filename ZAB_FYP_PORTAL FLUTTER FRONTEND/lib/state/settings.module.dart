import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/constants/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState extends ChangeNotifier {
  bool? isDarkTheme = null;
  SharedPreferences? prefs;

  initializeLocalStorage() async {
    prefs = await SharedPreferences.getInstance();
  }

  void load() async {
    if (prefs == null) await initializeLocalStorage();
    checkTheme();
  }

  Future<bool?> checkTheme() async {
    if (prefs == null) await initializeLocalStorage();

    if (prefs!.containsKey(IS_DARK_THEM_KEY)) {
      isDarkTheme = prefs!.getBool(IS_DARK_THEM_KEY);
      notifyListeners();
    }
    return isDarkTheme;
  }

  Future<bool?> switchToDarkTheme(bool isDarkTheme) async {
    if (prefs == null) await initializeLocalStorage();
    await prefs!.setBool(IS_DARK_THEM_KEY, isDarkTheme);
    checkTheme();
    return isDarkTheme;
  }
}
