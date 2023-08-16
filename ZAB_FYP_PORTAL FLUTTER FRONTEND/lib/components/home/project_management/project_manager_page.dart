import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/models/proposal_model.dart';
import 'package:lmsv4_flutter_app/models/student_model.dart';
import 'package:lmsv4_flutter_app/models/user_model.dart';
import 'package:lmsv4_flutter_app/screens/create_proposal_page.dart';
import 'package:lmsv4_flutter_app/screens/proposal_detail.dart';
import 'package:lmsv4_flutter_app/screens/proposal_list_page.dart';
import 'package:lmsv4_flutter_app/state/advisor.module.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:lmsv4_flutter_app/state/group.module.dart';
import 'package:lmsv4_flutter_app/state/proposal.module.dart';
import 'package:provider/provider.dart';
import 'package:image_stack/image_stack.dart';

class ProjectManagementPage extends StatefulWidget {
  @override
  State<ProjectManagementPage> createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage> {
  late AuthState authState;
  late GroupState groupState;
  late ProposalState proposalState;
  late AdvisorState advisorState;
  UserModel user = UserModel();
  List<ProposalModel>? proposals = null;
  List<String> images = <String>[
    "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
    "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
    "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
    "https://images.unsplash.com/photo-1473700216830-7e08d47f858e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
  ];
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
    groupState = context.read<GroupState>();
    groupState.addListener(() {
      setState(() {});
    });
    authState.checkIsAuthenticated();
    groupState.getGroup();
    proposalState = context.read<ProposalState>();
    proposalState.getProposals().then((value) {
      proposals = proposalState.proposals;
      setState(() {});
    });
    proposalState.addListener(() {
      setState(() {
        proposals = proposalState.proposals;
      });
    });
    advisorState = context.read<AdvisorState>();
    advisorState.getAdvisosrs().then((value) {
      setState(() {});
    });
    advisorState.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.onBackground),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("Project Management"),
          elevation: 0,
        ),
        body: Container(
          child: ListView(padding: EdgeInsets.zero, children: [
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Group",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        groupState.group == null ||
                                groupState.group?.students == null ||
                                (groupState.group?.students?.length ?? 0) <= 0
                            ? Text(
                                "Create Group By Adding Members",
                                style: TextStyle(color: Colors.white),
                              )
                            : GestureDetector(
                                onTap: () {
                                  showGroupUserBottomSheet();
                                },
                                child: ImageStack(
                                  imageList: images.sublist(
                                      0,
                                      (groupState.group?.students?.length ??
                                                  0) >
                                              2
                                          ? 2
                                          : (groupState
                                                  .group?.students?.length ??
                                              0)),
                                  imageRadius: 45,
                                  imageCount: 3,
                                  imageBorderWidth: 2,
                                  totalCount:
                                      groupState.group?.students?.length ?? 0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  imageBorderColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  extraCountTextStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                  extraCountBorderColor:
                                      Theme.of(context).colorScheme.primary,
                                )),
                        Expanded(child: Container()),
                        groupState.group != null &&
                                groupState.group?.isFinalized == true
                            ? SizedBox()
                            : Wrap(
                                children: [
                                  Ink(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                            width: 2),
                                        borderRadius: BorderRadius.circular(
                                            50.0)), //<-- SEE HERE
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      onTap: () {
                                        showInviteUserBottomSheet();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.add,
                                          size: 25.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  groupState.group != null &&
                                          (groupState.group?.students?.length ??
                                                  0) >
                                              0
                                      ? Ink(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      50.0)), //<-- SEE HERE
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            onTap: () {
                                              if (groupState
                                                      .group?.isFinalized !=
                                                  true)
                                                groupState
                                                    .finalizeGroup()
                                                    .then((value) {
                                                  setState(() {
                                                    if (value) {
                                                      groupState.getGroup();
                                                    }
                                                  });
                                                });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Icon(
                                                Icons.check,
                                                size: 25.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              )
                      ],
                    )
                  ]),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 190),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Your Proposals",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: SizedBox()),
                      proposals != null && proposals!.length > 3
                          ? new InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProposalListPage(),
                                    ));
                              },
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'See More',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Icon(
                                    Icons.arrow_right_alt,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                ],
                              ))
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  groupState.group == null ||
                          groupState.group?.isFinalized != true
                      ? Text(
                          "Please finalized your group before creating a proposal",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 12),
                        )
                      : groupState.group != null &&
                              proposals != null &&
                              proposals!.length > 0
                          ? Column(
                              children: List.generate(
                                  (proposals ?? [])
                                      .getRange(
                                          0,
                                          proposals!.length > 3
                                              ? 3
                                              : proposals!.length)
                                      .length,
                                  (index) => proposalsListItem(context, index)),
                            )
                          : SizedBox(
                              child: Text(
                                "Not Any Proposal",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 12),
                              ),
                            ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(child: SizedBox()),
                      groupState.group != null &&
                              groupState.group!.isFinalized == true
                          ? new InkWell(
                              onTap: (() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateProposalPage(),
                                    ));
                              }),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Text(
                                    'Create New Purposal',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ))
                          : SizedBox()
                    ],
                  ),
                ],
              ),
            )
          ]),
        ));
  }

  Widget proposalsListItem(BuildContext context, int index) {
    return new InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProposalDetail(proposal: proposals![index]),
            ));
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          new Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: new BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: new ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Text(
                  (proposals?[index].title ?? "").toUpperCase(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    "${cutOverText((proposals?[index].description ?? ""))}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 12),
                  ),
                ),
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageStack(
                  imageList: advisorState.advisors!
                      .where((e) => proposals![index].sendedProposals!.any(
                          (k) =>
                              k["AdvisorID"] != null && k["AdvisorID"] == e.iD))
                      .map((e) => e.pROFILEPIC ?? "")
                      .toList(),
                  imageRadius: 35,
                  imageCount: 5,
                  imageBorderWidth: 1,
                  totalCount: proposals![index]
                      .sendedProposals!
                      .where((e) =>
                          e["Status"] != null &&
                          e["Status"].toString().toLowerCase() == "intrested")
                      .length,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  imageBorderColor: Colors.white,
                  extraCountTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                  extraCountBorderColor:
                      Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  cutOverText(text) {
    if (text.toString().length > 180) {
      return text.toString().substring(0, 180) + " ......";
    }
    return text;
  }

  showInviteUserBottomSheet() async {
    var invitations = await groupState.getGroupInvitations();
    var fetchedInvitations = await groupState.fetchGroupInvitations();
    if (invitations == null) return;
    showModalBottomSheet<void>(
        // context and builder are
        // required properties in this widget
        context: context,
        elevation: 10,
        isScrollControlled: true,
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.8),
        builder: (BuildContext context) {
          // we set up a container inside which
          // we create center column and display text

          // Returning SizedBox instead of a Container
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(15),
            child: ListView(children: [
              Text(
                "Send Inivtation To Invite In Your Group",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                  children: List.generate(
                      invitations.length,
                      (index) => ListTile(
                            leading: Hero(
                                tag: "pp-${index}",
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage("${images[0]}"),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                )),
                            dense: true,
                            title: Text(
                                "${invitations[index].student?.fIRSTNAME} ${invitations[index].student?.lASTNAME}"),
                            subtitle: Text(
                                "${invitations[index].student?.program} ${invitations[index].student?.section}"),
                            trailing: Wrap(
                              children: [
                                Ink(
                                  decoration: BoxDecoration(
                                      color: invitations[index].isSended == true
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.transparent,
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(
                                          30.0)), //<-- SEE HERE
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100.0),
                                    onTap: () {
                                      if (invitations[index].isSended != true)
                                        groupState
                                            .sendGroupInvitations(
                                                (invitations[index]
                                                            .student
                                                            ?.iD ??
                                                        0)
                                                    .toString())
                                            .then((value) {
                                          setState(() {
                                            invitations = value;
                                            Navigator.of(context).pop();
                                            showInviteUserBottomSheet();
                                          });
                                        });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        invitations[index].isSended == true
                                            ? "Invitation Sended"
                                            : "Send Invitation",
                                        style: TextStyle(
                                            color:
                                                invitations[index].isSended ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .background
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              fetchedInvitations.length > 0
                  ? Text(
                      "Invitation Sended To You For Group",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              Column(
                  children: List.generate(
                fetchedInvitations.length,
                (index) => ListTile(
                  leading: Hero(
                      tag: "pp-${index}",
                      child: CircleAvatar(
                        backgroundImage: NetworkImage("${images[0]}"),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      )),
                  dense: true,
                  title: Text(
                      "${fetchedInvitations[index].student?.fIRSTNAME} ${fetchedInvitations[index].student?.lASTNAME}"),
                  subtitle: Text(
                      "${fetchedInvitations[index].student?.program} ${fetchedInvitations[index].student?.section}"),
                  trailing: Wrap(
                    children: [
                      Ink(
                        decoration: BoxDecoration(
                            color: fetchedInvitations[index].isAccepted == true
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
                            borderRadius:
                                BorderRadius.circular(30.0)), //<-- SEE HERE
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100.0),
                          onTap: () {
                            if (fetchedInvitations[index].isAccepted != true)
                              groupState
                                  .acceptGroupInvitations(
                                      (fetchedInvitations[index].iD ?? 0)
                                          .toString())
                                  .then((value) {
                                setState(() {
                                  if (value) {
                                    groupState.getGroup();
                                    Navigator.of(context).pop();
                                    showInviteUserBottomSheet();
                                  }
                                });
                              });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              fetchedInvitations[index].isAccepted == true
                                  ? "Invitation Accepted"
                                  : "Accept",
                              style: TextStyle(
                                  color: fetchedInvitations[index].isAccepted ==
                                          true
                                      ? Theme.of(context).colorScheme.background
                                      : Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ]),
          );
        });
  }

  showGroupUserBottomSheet() async {
    var students = groupState.group?.students
        ?.where((StudentModel x) => x.iD != authState.user?.id)
        .toList();
    showModalBottomSheet<void>(
        // context and builder are
        // required properties in this widget
        context: context,
        elevation: 10,
        isScrollControlled: true,
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.8),
        builder: (BuildContext context) {
          // we set up a container inside which
          // we create center column and display text

          // Returning SizedBox instead of a Container
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Your Group Student",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: List.generate(
                          students?.length ?? 0,
                          (index) => ListTile(
                                leading: Hero(
                                    tag: "pp-${index}",
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage("${images[0]}"),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                                dense: true,
                                title: Text(
                                    "${students?[index].fIRSTNAME} ${students?[index].lASTNAME}"),
                                subtitle: Text(
                                    "${students?[index].program} ${students?[index].section}"),
                              )),
                    ),
                  ),
                  groupState.group?.isFinalized != true
                      ? Container(
                          alignment: Alignment.centerRight,
                          child: MaterialButton(
                              color: Theme.of(context).colorScheme.primary,
                              textColor:
                                  Theme.of(context).colorScheme.background,
                              child: Text("Finalized The Group"),
                              onPressed: (() => {
                                    groupState.finalizeGroup().then((value) {
                                      if (value) {
                                        groupState.getGroup();
                                      }
                                    })
                                  })),
                        )
                      : SizedBox()
                ]),
          );
        });
  }
}
