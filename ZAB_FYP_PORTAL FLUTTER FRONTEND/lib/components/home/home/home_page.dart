import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:provider/provider.dart';

class Home_Page extends StatefulWidget {
  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  late AuthState authState;

  @override
  initState() {
    authState = context.read<AuthState>();

    super.initState();
    authState.checkIsAuthenticated().then((isAuthenticated) {
      if (!isAuthenticated) {
        authState.logout();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar? HomeAppbar(BuildContext context) {
      return AppBar(
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.onBackground),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background);
    }

    return Scaffold(
        appBar: HomeAppbar(context),
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: Drawer(),
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Text(
                    "Hello,",
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${authState.user?.firstName ?? ""}!",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onBackground),
                  )
                ],
              ),
              Text(
                "HAVE A NICE DAY",
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              notifyMessage(),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    stepBox(
                        Colors.blue[800],
                        "1",
                        Center(
                          child: Text(
                            "Firstly Make Your Group And Finalized Before Last Date.",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text.rich(TextSpan(
                          text: "Last Date Of Group Finalization :",
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Mon 25th OCT, 2023.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ))),
                    stepBox(
                        Colors.blue[700],
                        "2",
                        Center(
                          child: Text(
                            "Then , Make Your Project Proposals To Send Supervisors.",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )),
                    stepBox(
                        Colors.blue[600],
                        "3",
                        Center(
                          child: Text(
                            "Find Supervisors And Send Proposals.",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text.rich(TextSpan(
                          text: "Last Date Of Signed Supervisor :",
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Mon 25th DEC, 2023.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ))),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Container stepBox(
      Color? boxColor, String alpha, Widget title, Widget trailingWidget) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 140,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(
            child: Text(
              "$alpha",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            radius: 15,
            backgroundColor: Colors.white.withOpacity(0.5)),
        SizedBox(
          height: 5,
        ),
        Expanded(child: title),
        SizedBox(height: 5),
        trailingWidget,
      ]),
    );
  }

  Container notifyMessage() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          border: Border.all(
              color: Colors.blue, style: BorderStyle.solid, width: 1)),
      padding: EdgeInsets.all(10),
      child: Text.rich(
          TextSpan(
            text: "",
            children: <InlineSpan>[
              TextSpan(
                text: 'Note : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Please make your group and finalize your group before ',
              ),
              TextSpan(
                text: 'Mon 25th OCT, 2023.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' Last date of finalization of group is ',
              ),
              TextSpan(
                text: '25th OCT, 2023.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' After you are not able to finalize your group.',
              )
            ],
            style: TextStyle(
              color: Colors.blue[900],
              fontSize: 12,
            ),
          ),
          textAlign: TextAlign.justify),
    );
  }
}
