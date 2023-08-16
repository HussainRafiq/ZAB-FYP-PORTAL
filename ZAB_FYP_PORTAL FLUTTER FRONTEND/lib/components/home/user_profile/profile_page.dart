import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/components/ui_componenets.dart';
import 'package:lmsv4_flutter_app/components/home/user_profile/profile_list_item.dart';
import 'package:lmsv4_flutter_app/models/user_model.dart';
import 'package:lmsv4_flutter_app/screens/setting.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthState authState;
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
    authState.checkIsAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    var profileInfo = user == null
        ? SizedBox()
        : Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  height: 150,
                  width: 150,
                  margin: EdgeInsets.only(top: 30),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(75),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                          strokeAlign: StrokeAlign.center,
                          width: 5,
                          color: Theme.of(context).colorScheme.primary)),
                  child: Stack(
                    children: <Widget>[
                      Hero(
                        tag: "user_profile_pic",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Center(
                                child:
                                    //  (user.profilePicture ?? "").isEmpty
                                    //     ?
                                    Image.asset(
                                        'assets/images/profile-picture.png')
                                // : Image.network('${user.profilePicture!}'),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10 * 2),
                Text(
                  '${user.firstName ?? ""} ${user.lastName ?? ""}',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                SizedBox(height: 5),
                Text(
                  '${user.email ?? ""} | ${user.phoneNumber ?? ""}',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w100,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                SizedBox(height: 20),
              ],
            ),
          );

    // var themeSwitcher = ThemeSwitcher(
    //   builder: (context) {
    //     return AnimatedCrossFade(
    //       duration: Duration(milliseconds: 200),
    //       crossFadeState:
    //           ThemeProvider.of(context).brightness == Brightness.dark
    //               ? CrossFadeState.showFirst
    //               : CrossFadeState.showSecond,
    //       firstChild: GestureDetector(
    //         onTap: () =>
    //             ThemeSwitcher.of(context).changeTheme(theme: kLightTheme),
    //         child: Icon(
    //           LineAwesomeIcons.sun,
    //           size: ScreenUtil().setSp(10 * 3),
    //         ),
    //       ),
    //       secondChild: GestureDetector(
    //         onTap: () =>
    //             ThemeSwitcher.of(context).changeTheme(theme: kDarkTheme),
    //         child: Icon(
    //           LineAwesomeIcons.moon,
    //           size: ScreenUtil().setSp(10 * 3),
    //         ),
    //       ),
    //     );
    //   },
    // );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 30),
        // Icon(
        //   LineAwesomeIcons.arrow_left,
        //   size: ScreenUtil().setSp(10 * 3),
        // ),
        profileInfo,
        // themeSwitcher,
        SizedBox(width: 30),
      ],
    );

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.onBackground),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          title: Text("Profile"),
        ),
        body: authState.AuthStatus == AuthenticationStatus.AUTHENTICATED &&
                user != null
            ? Stack(children: [
                Container(
                    height: 180,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://timelinecovers.pro/facebook-cover/download/web-developer-coding-on-screen-hex2rgb-facebook-cover.jpg")),
                    )),
                Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Builder(
                      builder: (context) {
                        return Scaffold(
                          backgroundColor: Colors.transparent,
                          body: ListView(
                            children: <Widget>[
                              SizedBox(height: 50),
                              header,
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, "/editprofile");
                                      },
                                      child:
                                          Icon(Icons.edit, color: Colors.white),
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(20),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Setting()),
                                        );
                                      },
                                      child: Icon(Icons.settings,
                                          color: Colors.white),
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(20),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        authState.logout();
                                        authState.notifyListeners();
                                      },
                                      child: Icon(Icons.logout,
                                          color: Colors.white),
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(20),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Divider()
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ])
            : Center(
                child: Loading(),
              ));
  }
}
