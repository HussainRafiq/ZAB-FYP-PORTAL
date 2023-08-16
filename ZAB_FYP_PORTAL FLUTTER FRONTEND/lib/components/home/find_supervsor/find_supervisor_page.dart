import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/components/ui_componenets.dart';
import 'package:lmsv4_flutter_app/components/home/user_profile/profile_list_item.dart';
import 'package:lmsv4_flutter_app/models/user_model.dart';
import 'package:lmsv4_flutter_app/screens/setting.dart';
import 'package:lmsv4_flutter_app/screens/supervisor_page.dart';
import 'package:lmsv4_flutter_app/state/advisor.module.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:provider/provider.dart';

class FindSupervisorPage extends StatefulWidget {
  @override
  State<FindSupervisorPage> createState() => _FindSupervisorPageState();
}

class _FindSupervisorPageState extends State<FindSupervisorPage> {
  late AuthState authState;
  late AdvisorState advisorState;
  UserModel user = UserModel();
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  initState() {
    authState = context.read<AuthState>();
    authState.addListener(() {
      if (authState.AuthStatus == AuthenticationStatus.FAILED) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/signinwithemail', (Route<dynamic> route) => false);
      }
      setState(() {
        if (authState.user != null) {
          user = authState.user!;
        }
      });
    });
    advisorState = context.read<AdvisorState>();
    advisorState.addListener(() {
      setState(() {});
    });
    authState.checkIsAuthenticated();
    advisorState.getAdvisosrs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.onBackground),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          title: Text("Find Supervisor"),
        ),
        body: advisorState.currentDataState == DataStates.FETCHED &&
                advisorState.advisors != null
            ? Container(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: List.generate(
                    advisorState.advisors?.length ?? 0,
                    (index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SupervisorPage(
                                    advisorModel: advisorState.advisors?[index],
                                  )),
                        );
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Hero(
                              tag: "pp-${advisorState.advisors?[index].iD}",
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "${advisorState.advisors?[index].pROFILEPIC}"),
                                backgroundColor: Colors.white,
                              )),
                          isThreeLine: true,
                          title: Text(
                            "${advisorState.advisors?[index].fIRSTNAME} ${advisorState.advisors?[index].lASTNAME}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${advisorState.advisors?[index].dESIGNATION}'),
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Flexible(
                                      child: Text(
                                          "Room ${advisorState.advisors?[index].roomNo}\t|\t${advisorState.advisors?[index].campus}"))
                                ],
                              )
                            ],
                          ),
                          dense: true,
                        ),
                      ),
                    ),
                  ),
                ))
            : Center(
                child: Loading(),
              ));
  }
}
