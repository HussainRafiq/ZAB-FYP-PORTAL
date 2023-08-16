import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/toaster.dart';
import '../models/advisor_model.dart';
import '../state/auth.module.dart';
import '../state/group.module.dart';
import '../state/proposal.module.dart';

class SupervisorPage extends StatefulWidget {
  final AdvisorModel? advisorModel;

  SupervisorPage({Key? key, required this.advisorModel}) : super(key: key);

  @override
  State<SupervisorPage> createState() => _SupervisorPageState();
}

class _SupervisorPageState extends State<SupervisorPage> {
  late AuthState authState;
  GroupState? groupState;
  ProposalState? proposalState;

  @override
  initState() {
    super.initState();
    authState = context.read<AuthState>();
    groupState = context.read<GroupState>();
    authState.addListener(() {
      if (authState.AuthStatus == AuthenticationStatus.FAILED) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/signinwithemail', (Route<dynamic> route) => false);
      }
      setState(() {});
    });
    authState.checkIsAuthenticated().then((isAuthenticated) {
      if (isAuthenticated && authState.user?.role?.toLowerCase() == "student") {
        groupState?.getGroup();
        groupState?.addListener(() {
          setState(() {});
        });

        proposalState = context.read<ProposalState>();
        proposalState?.getProposals();
        proposalState?.addListener(() {
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: SafeArea(
        child: Stack(alignment: Alignment.topLeft, children: [
          //Cover Picture
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: 130,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/coverphoto.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 130,
            child: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0, //to get the whole page height
              top: 55, //to do the upper side curved
              child: ListView(
                shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          //decoration: const BoxDecoration(color: Colors.blueGrey),
                          child: Hero(
                              tag: "pp-${widget.advisorModel?.iD}",
                              child: ClipOval(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  height:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(.5),
                                          blurRadius: 20.0, // soften the shadow
                                          spreadRadius: 0.0, //extend the shadow
                                          offset: Offset(
                                            5.0, // Move to right 10  horizontally
                                            5.0, // Move to bottom 10 Vertically
                                          ),
                                        )
                                      ],
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "${widget.advisorModel?.pROFILEPIC}"))),
                                ),
                              ))),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey,
                      //     offset: Offset(0.0, 1.0), //(x,y)
                      //     blurRadius: 10.0,
                      //   ),
                      // ],
                    ),
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    //decoration: const BoxDecoration(color: Colors.blueGrey),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.advisorModel?.fIRSTNAME} ${widget.advisorModel?.lASTNAME}",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${widget.advisorModel?.dESIGNATION}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                        authState.user != null &&
                                authState.user?.role?.toLowerCase() == "student"
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        child: Text("Send Proposal".toUpperCase(),
                                            style: TextStyle(fontSize: 14)),
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                EdgeInsets>(EdgeInsets.all(15)),
                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(
                                                        groupState?.group != null &&
                                                                groupState?.group?.isFinalized ==
                                                                    true
                                                            ? 1
                                                            : 0.4)),
                                            foregroundColor:
                                                MaterialStateProperty.all<Color>(Colors.white),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(color: Theme.of(context).colorScheme.primary)))),
                                        onPressed: groupState?.group != null && groupState?.group?.isFinalized == true
                                            ? () {
                                                sendProposal();
                                              }
                                            : null),
                                    SizedBox(width: 10),
                                    TextButton(
                                        child: Text(
                                            "Add To Favourite".toUpperCase(),
                                            style: TextStyle(fontSize: 14)),
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                EdgeInsets>(EdgeInsets.all(15)),
                                            foregroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onBackground),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12.0),
                                                    side: BorderSide(color: Theme.of(context).colorScheme.onBackground)))),
                                        onPressed: () => null),
                                  ],
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        child: Text("Logout".toUpperCase(),
                                            style: TextStyle(fontSize: 14)),
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                EdgeInsets>(EdgeInsets.all(15)),
                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(
                                                        groupState?.group != null &&
                                                                groupState?.group?.isFinalized ==
                                                                    true
                                                            ? 1
                                                            : 0.4)),
                                            foregroundColor:
                                                MaterialStateProperty.all<Color>(Colors.white),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(color: Theme.of(context).colorScheme.primary)))),
                                        onPressed: () {
                                          authState.logout();
                                        }),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 5,
                        ),
                        authState.user != null &&
                                authState.user?.role?.toLowerCase() ==
                                    "student" &&
                                groupState?.group?.isFinalized == false
                            ? Center(
                                child: Text(
                                  "Note: You are not able to send purposal before finalizing your group",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    //decoration: const BoxDecoration(color: Colors.blueGrey),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Details",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: 0,
                          leading: Icon(
                            Icons.email,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 18,
                          ),
                          title: Text(
                            "${widget.advisorModel?.eMAIL}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: 0,
                          leading: Icon(
                            Icons.location_history_rounded,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 18,
                          ),
                          title: Text.rich(TextSpan(
                            text: "Room No. ",
                            children: <InlineSpan>[
                              TextSpan(
                                text: '${widget.advisorModel?.roomNo}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 16,
                            ),
                          )),
                        ),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: 0,
                          leading: Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 18,
                          ),
                          title: Text.rich(TextSpan(
                            text: "",
                            children: <InlineSpan>[
                              TextSpan(
                                text: '${widget.advisorModel?.campus}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 16,
                            ),
                          )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    //decoration: const BoxDecoration(color: Colors.blueGrey),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Area Of Interests",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: List.generate(
                              widget.advisorModel?.areas?.length ?? 0,
                              (index) => Chip(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                        side: BorderSide(
                                            width: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground)),
                                    labelStyle: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                    label: Text(widget
                                            .advisorModel?.areas?[index].nAME ??
                                        ""),
                                  )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Positioned(
            left: 5,
            top: 5,
            right: 0,
            child: Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).colorScheme.background,
                ),
                onPressed: () => {Navigator.of(context).pop()},
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Container proposalsListItem(BuildContext context, int index) {
    return new Container(
        margin: EdgeInsets.only(bottom: 5),
        decoration: new BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: new ListTile(
          title: Text(
            (proposalState!.proposals?[index].title ?? "").toUpperCase(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              cutOverText((proposalState!.proposals?[index].description ?? "")),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 12),
            ),
          ),
        ));
  }

  cutOverText(text) {
    if (text.toString().length > 180) {
      return text.toString().substring(0, 180) + " ......";
    }
    return text;
  }

  sendProposal() {
    if (proposalState?.proposals != null &&
        (proposalState?.proposals?.length ?? 0) > 0) {
      showModalBottomSheet<void>(
          // context and builder are
          // required properties in this widget
          context: context,
          elevation: 10,
          isScrollControlled: true,
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.8),
          builder: (BuildContext context) {
            // we set up a container inside which
            // we create center column and display text

            // Returning SizedBox instead of a Container
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView(
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 16),
                      child: Text(
                        "Select Proposal",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: proposalState?.proposals != null &&
                              (proposalState?.proposals?.length ?? 0) > 0
                          ? Column(
                              children: List.generate(
                                  (proposalState?.proposals ?? []).length,
                                  (index) => GestureDetector(
                                      onTap: () {
                                        proposalState!.sendProposal(
                                            proposalState!.proposals![index].iD,
                                            widget.advisorModel!.iD);
                                        Navigator.of(context).pop();
                                        CustomToast.ShowMessage(
                                            "Proposal Sended");
                                      },
                                      child:
                                          proposalsListItem(context, index))),
                            )
                          : SizedBox(
                              child: Text("Not Any Proposal"),
                            )),
                ],
              ),
            );
          });
    }
  }
}
