import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/components/home/find_supervsor/find_supervisor_page.dart';
import 'package:lmsv4_flutter_app/components/home/home/home_page.dart';
import 'package:lmsv4_flutter_app/components/home/project_management/project_manager_page.dart';
import 'package:lmsv4_flutter_app/components/home/user_profile/profile_page.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AuthState authState = AuthState();
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late TabController _controller;
  var selectedBottomIndex = 0;
  @override
  initState() {
    super.initState();
    authState.checkIsAuthenticated().then((isAuthenticated) {
      if (!isAuthenticated) {
        authState.logout();
      }
      setState(() {});
    });
    _controller = new TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 5,
        child: Scaffold(
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
        Home_Page(),
        FindSupervisorPage(),
        ProjectManagementPage(),
        Container(),
        ProfilePage()
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
            Icon(Icons.home,
                size: 30, color: Theme.of(context).colorScheme.onSurface),
            selectedBottomIndex != 0
                ? Text(
                    "Home",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12),
                  )
                : SizedBox()
          ],
        ),
        Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.search_sharp,
                size: 30, color: Theme.of(context).colorScheme.onSurface),
            selectedBottomIndex != 1
                ? Text(
                    "Supervisor",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12),
                  )
                : SizedBox()
          ],
        ),
        Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.pages_outlined,
                size: 30, color: Theme.of(context).colorScheme.onSurface),
            selectedBottomIndex != 2
                ? Text(
                    "Project",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12),
                  )
                : SizedBox()
          ],
        ),
        Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.notifications,
                  size: 30, color: Theme.of(context).colorScheme.onSurface),
              selectedBottomIndex != 3
                  ? Text(
                      "Notification",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 12),
                    )
                  : SizedBox()
            ]),
        Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.person,
                  size: 30, color: Theme.of(context).colorScheme.onSurface),
              selectedBottomIndex != 4
                  ? Text(
                      "Profile",
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
