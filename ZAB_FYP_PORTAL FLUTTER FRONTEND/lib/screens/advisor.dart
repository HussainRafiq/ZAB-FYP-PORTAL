import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/components/home/find_supervsor/find_supervisor_page.dart';
import 'package:lmsv4_flutter_app/components/home/home/home_page.dart';
import 'package:lmsv4_flutter_app/components/home/project_management/project_manager_page.dart';
import 'package:lmsv4_flutter_app/components/home/user_profile/profile_page.dart';
import 'package:lmsv4_flutter_app/models/advisor_model.dart';
import 'package:lmsv4_flutter_app/screens/proposal_list_page.dart';
import 'package:lmsv4_flutter_app/screens/supervisor_page.dart';
import 'package:lmsv4_flutter_app/state/advisor.module.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

class Advisor extends StatefulWidget {
  Advisor({Key? key}) : super(key: key);

  @override
  State<Advisor> createState() => _AdvisorState();
}

class _AdvisorState extends State<Advisor> with SingleTickerProviderStateMixin {
  AuthState authState = AuthState();
  AdvisorState advisorState = AdvisorState();
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late TabController _controller;
  var selectedBottomIndex = 0;
  AdvisorModel? currentAdvisor;
  @override
  initState() {
    super.initState();
    authState = context.read<AuthState>();
    authState.checkIsAuthenticated().then((isAuthenticated) {
      if (!isAuthenticated) {
        authState.logout();
      }
      setState(() {});

      advisorState = context.read<AdvisorState>();
      advisorState.getAdvisosrs().then((advisors) => {
            currentAdvisor = advisorState.advisors?.firstWhere(
                    (element) => element.iD == authState?.user?.id) ??
                null
          });
    });
    _controller = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: null,
          backgroundColor: Theme.of(context).colorScheme.background,
          bottomNavigationBar: BottomNavigationBar(context),
          body: authState.AuthStatus == AuthenticationStatus.AUTHENTICATED
              ? MainSection(context)
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }

  Widget MainSection(BuildContext context) {
    return TabBarView(
      controller: _controller,
      children: [
        ProposalListPage(),
        currentAdvisor != null
            ? SupervisorPage(advisorModel: currentAdvisor)
            : Container()
      ],
    );
  }

  CurvedNavigationBar BottomNavigationBar(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: selectedBottomIndex,
      height: 50.0,
      items: <Widget>[
        Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.task,
                size: 30, color: Theme.of(context).colorScheme.onSurface),
            selectedBottomIndex != 2
                ? Text(
                    "",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12),
                  )
                : SizedBox()
          ],
        ),
        // Wrap(
        //     direction: Axis.vertical,
        //     crossAxisAlignment: WrapCrossAlignment.center,
        //     children: [
        //       Icon(Icons.notifications,
        //           size: 30, color: Theme.of(context).colorScheme.onSurface),
        //       selectedBottomIndex != 3
        //           ? Text(
        //               "Notification",
        //               style: TextStyle(
        //                   color: Theme.of(context).colorScheme.onSurface,
        //                   fontSize: 12),
        //             )
        //           : SizedBox()
        //     ]),
        Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.person,
                  size: 30, color: Theme.of(context).colorScheme.onSurface),
              selectedBottomIndex != 4
                  ? Text(
                      "",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 12),
                    )
                  : SizedBox()
            ])
      ],
      color: Theme.of(context).colorScheme.surface,
      buttonBackgroundColor: Theme.of(context).colorScheme.surface,
      backgroundColor: Theme.of(context).colorScheme.primary,
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 600),
      onTap: (index) {
        setState(() {
          selectedBottomIndex = index;
          _controller.index = selectedBottomIndex;
        });
      },
      letIndexChange: (index) => true,
    );
  }
}
