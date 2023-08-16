import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/models/advisor_model.dart';
import 'package:lmsv4_flutter_app/services/advisor.service.dart';
import 'package:lmsv4_flutter_app/utils/logger.dart';
import 'auth.module.dart';

class AdvisorState extends ChangeNotifier {
  String currentDataState = DataStates.NONE;

  List<AdvisorModel>? advisors = null;

  Future getAdvisosrs() async {
    try {
      currentDataState = DataStates.FETCHING;
      notifyListeners();
      advisors = await AdvisorService().getAdvisors();
      currentDataState = DataStates.FETCHED;
      notifyListeners();
    } catch (ex) {
      Logger.Log(LogType.ERROR, "AuthState.checkIsAuthenticated", ex);
      return false;
    }
  }
}
