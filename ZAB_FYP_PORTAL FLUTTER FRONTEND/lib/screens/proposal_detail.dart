import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';
import 'package:lmsv4_flutter_app/screens/supervisor_page.dart';
import 'package:lmsv4_flutter_app/services/proposal.service.dart';
import 'package:lmsv4_flutter_app/state/proposal.module.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/advisor_model.dart';
import '../models/proposal_model.dart';
import '../state/advisor.module.dart';
import '../state/auth.module.dart';
import '../state/group.module.dart';

class ProposalDetail extends StatefulWidget {
  final ProposalModel proposal;
  ProposalDetail({Key? key, required this.proposal}) : super(key: key);

  @override
  State<ProposalDetail> createState() => _ProposalDetailState();
}

class _ProposalDetailState extends State<ProposalDetail> {
  late AuthState authState;
  late GroupState groupState;
  late ProposalState proposalState;

  late AdvisorState advisorState;
  Map<String, AdvisorModel>? advisorsList;
  int currentSelectedIndex = 0;
  List<String> images = <String>[
    "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
    "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
    "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
    "https://images.unsplash.com/photo-1473700216830-7e08d47f858e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
  ];
  List<dynamic>? proposalComments;
  TextEditingController? _commentController;
  @override
  initState() {
    super.initState();
    authState = context.read<AuthState>();
    authState.addListener(() {
      if (authState.AuthStatus == AuthenticationStatus.FAILED) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/signinwithemail', (Route<dynamic> route) => false);
      }
      setState(() {});
    });
    groupState = context.read<GroupState>();
    groupState.addListener(() {
      setState(() {});
    });
    proposalState = context.read<ProposalState>();

    proposalState.addListener(() {
      setState(() {});
    });

    authState.checkIsAuthenticated().then((isAuth) {
      if (isAuth && authState.user?.role?.toLowerCase() == "student") {
        groupState.getGroup();
      }
      if (isAuth) {
        proposalState
            .getProposalComments("${widget.proposal.iD}")
            .then((value) {
          print(value);
          proposalComments = value
              ?.where((element) =>
                  (authState?.user != null &&
                      authState.user?.role?.toLowerCase() == "student") ||
                  (authState?.user != null &&
                      authState.user?.role?.toLowerCase() == "advisor" &&
                      element["ADVISORID"].toString() ==
                          authState.user?.id?.toString()))
              .toList();
        });
      }
    });
    advisorState = context.read<AdvisorState>();
    advisorState.addListener(() {
      setState(() {
        if (advisorsList == null &&
            advisorState.advisors != null &&
            advisorState.advisors!.length > 0) {
          advisorsList = Map<String, AdvisorModel>();
          advisorState.advisors?.forEach((element) {
            advisorsList!.putIfAbsent("${(element.iD ?? 0)}", () => element);
          });
        }
      });
    });
    advisorState.getAdvisosrs();
    _commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: drawUI(),
    );
  }

  DefaultTabController drawUI() {
    return DefaultTabController(
        length: authState?.user != null &&
                authState?.user?.role?.toLowerCase() == "student"
            ? 4
            : 2,
        initialIndex: 0,
        child: Container(
            color: Theme.of(context).colorScheme.onInverseSurface,
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    getSliverAppbar(),
                    getPresistentHeaderTabs(context),
                  ];
                },
                body: Container(
                    color: Theme.of(context).colorScheme.background,
                    alignment: Alignment.topCenter,
                    child: Container(
                        child: authState?.user != null &&
                                authState?.user?.role?.toLowerCase() ==
                                    "student"
                            ? (currentSelectedIndex == 0
                                ? proposalDescriptionPanel()
                                : currentSelectedIndex == 1
                                    ? sendedProposalPanel()
                                    : currentSelectedIndex == 2
                                        ? sendedProposalCommentsPanel()
                                        : currentSelectedIndex == 3
                                            ? intrestedSupervisorProposalPanel()
                                            : Container())
                            : (currentSelectedIndex == 0
                                ? proposalDescriptionPanel()
                                : currentSelectedIndex == 1
                                    ? sendedProposalCommentsPanel()
                                    : Container()))))));
  }

  Widget proposalDescriptionPanel() {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          child: Text("${widget.proposal.description!}"),
        ),
      ],
    );
  }

  Widget sendedProposalPanel() {
    if (advisorState.advisors != null &&
        advisorState.advisors!.length > 0 &&
        widget.proposal.sendedProposals != null &&
        widget.proposal.sendedProposals != null &&
        widget.proposal.sendedProposals!.length > 0) {
      var advisors = advisorState.advisors!
          .where((e) => widget.proposal.sendedProposals!
              .any((k) => k["AdvisorID"] != null && k["AdvisorID"] == e.iD))
          .toList();
      return Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Column(
              children: List.generate(
                advisors.length,
                (index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SupervisorPage(
                                advisorModel: advisors[index],
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
                          tag: "pp-${advisors[index].iD}",
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "${advisorState.advisors?[index].pROFILEPIC}"),
                            backgroundColor: Colors.white,
                          )),
                      isThreeLine: true,
                      title: Text(
                        "${advisors[index].fIRSTNAME} ${advisors[index].lASTNAME}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${advisors[index].dESIGNATION}'),
                          Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                  child: Text(
                                      "Sended At : ${DateFormat.yMMMEd().format(DateTime.parse(widget.proposal.sendedProposals?.firstWhere((x) => x["AdvisorID"] == advisors[index].iD)?["SendedAt"]))}"))
                            ],
                          )
                        ],
                      ),
                      dense: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(15),
      child: Text('Proposal sended to no one.'),
    );
  }

  Widget sendedProposalCommentsPanel() {
    if (proposalComments != null &&
        proposalComments!.length > 0 &&
        proposalComments!
                .where((x) => x["ISINTERESTED"].toString() != "1")
                .length >
            0) {
      var pitems = proposalComments!
          .where((x) => x["ISINTERESTED"].toString() != "1")
          .toList();
      return Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            authState.user != null &&
                    authState.user?.role?.toLowerCase() == "advisor"
                ? Container(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          controller: _commentController,
                          minLines: 4,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Comments here',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a comment';
                            }
                            return null;
                          },
                          onSaved: (value) {},
                          maxLines: 15,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MaterialButton(
                          onPressed: () async {
                            var comment = _commentController?.value.text;
                            if (comment != null && comment != '') {
                              var proposals = await ProposalService()
                                  .addProposalComment(
                                      widget.proposal.iD, comment, "0");
                              proposalState
                                  .getProposalComments("${widget.proposal.iD}")
                                  .then((value) {
                                proposalComments = value
                                    ?.where((element) =>
                                        (authState?.user != null &&
                                            authState.user?.role
                                                    ?.toLowerCase() ==
                                                "student") ||
                                        (authState?.user != null &&
                                            authState.user?.role
                                                    ?.toLowerCase() ==
                                                "advisor" &&
                                            element["ADVISORID"].toString() ==
                                                authState?.user?.id
                                                    ?.toString()))
                                    .toList();
                                setState(() {
                                  _commentController!.clear();
                                });
                              });
                            }
                          },
                          color: Theme.of(context).colorScheme.primary,
                          textColor: Color(0xFFFFFFFF),
                          child: Text('Send comment and show your interest'),
                        ),
                      )
                    ]),
                  )
                : Container(),
            Column(
              children: List.generate(
                pitems.length,
                (index) => GestureDetector(
                  onTap: () {},
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "${advisorsList!["${pitems[index]["ADVISORID"]}"]?.pROFILEPIC ?? ""}"),
                        backgroundColor: Colors.white,
                      ),
                      isThreeLine: true,
                      title: Text(
                        "${advisorsList!["${pitems[index]["ADVISORID"]}"]?.fIRSTNAME} ${advisorsList?["${pitems![index]["ADVISORID"]}"]?.lASTNAME}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pitems[index]["COMMENT"]),
                          Flex(
                            mainAxisAlignment: MainAxisAlignment.end,
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                  child: Text(
                                "${DateFormat.yMMMEd().format(DateTime.parse(pitems[index]["SENDEDAT"]))}",
                                style: TextStyle(color: Colors.white),
                              ))
                            ],
                          )
                        ],
                      ),
                      dense: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return authState.user != null &&
            authState.user?.role?.toLowerCase() == "advisor"
        ? Container(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TextFormField(
                  controller: _commentController,
                  minLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Comments here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a comment';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                  maxLines: 15,
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: MaterialButton(
                  onPressed: () async {
                    var comment = _commentController?.value.text;
                    if (comment != null && comment != '') {
                      var proposals = await ProposalService()
                          .addProposalComment(widget.proposal.iD, comment, "0");
                      proposalState
                          .getProposalComments("${widget.proposal.iD}")
                          .then((value) {
                        proposalComments = value
                            ?.where((element) =>
                                (authState?.user != null &&
                                    authState.user?.role?.toLowerCase() ==
                                        "student") ||
                                (authState?.user != null &&
                                    authState.user?.role?.toLowerCase() ==
                                        "advisor" &&
                                    element["ADVISORID"].toString() ==
                                        authState?.user?.id?.toString()))
                            .toList();
                        setState(() {
                          _commentController!.clear();
                        });
                      });
                    }
                  },
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Color(0xFFFFFFFF),
                  child: Text('Send comment and show your interest'),
                ),
              )
            ]),
          )
        : Container(
            padding: EdgeInsets.all(15),
            child: Text('No one commented on proposals.'),
          );
  }

  Widget intrestedSupervisorProposalPanel() {
    if (widget.proposal.sendedProposals != null &&
        (widget.proposal.sendedProposals?.length ?? 0) > 0 &&
        widget.proposal.sendedProposals!
            .any((x) => x["Status"].toString().toLowerCase() == "interested")) {
      var pitems = widget.proposal.sendedProposals!
          .where((x) => x["Status"].toString().toLowerCase() == "interested")
          .toList();
      print(pitems);
      return Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Column(
              children: List.generate(
                pitems.length,
                (index) => GestureDetector(
                  onTap: () {},
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "${advisorsList?[pitems[index]["AdvisorID"].toString()]?.pROFILEPIC}"),
                        backgroundColor: Colors.white,
                      ),
                      isThreeLine: true,
                      title: Text(
                        "${advisorsList?[pitems[index]["AdvisorID"].toString()]?.fIRSTNAME} ${advisorsList?[pitems[index]["AdvisorID"].toString()]?.lASTNAME}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (proposalComments?.any((x) =>
                                  x["ISINTERESTED"].toString() == "1" &&
                                  x["ADVISORID"].toString() ==
                                      pitems[index]["AdvisorID"].toString()) ??
                              false)
                            Text(proposalComments?.firstWhere((x) =>
                                x["ISINTERESTED"].toString() == "1" &&
                                x["ADVISORID"].toString() ==
                                    pitems[index]["AdvisorID"]
                                        .toString())?["COMMENT"]),
                          Flex(
                            mainAxisAlignment: MainAxisAlignment.end,
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                  child: Text(
                                "",
                                style: TextStyle(color: Colors.white),
                              )),
                            ],
                          )
                        ],
                      ),
                      dense: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(15),
      child: Text('No one interested in proposals.'),
    );
  }

  SliverPersistentHeader getPresistentHeaderTabs(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _SliverAppBarDelegate(
        TabBar(
            isScrollable: true,
            unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.only(left: 0, right: 0),
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.black87),
            labelColor: Colors.white,
            onTap: ((value) {
              setState(() {
                currentSelectedIndex = value;
              });
            }),
            tabs: authState?.user != null &&
                    authState?.user?.role?.toLowerCase() == "student"
                ? [
                    Tab(
                        child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Project Detail",
                        ),
                      ),
                    )),
                    Tab(
                        child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Proposal Invitations",
                        ),
                      ),
                    )),
                    Tab(
                        child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Comments",
                        ),
                      ),
                    )),
                    Tab(
                        child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Interested Supervisors",
                        ),
                      ),
                    )),
                  ]
                : (authState?.user != null &&
                        authState?.user?.role?.toLowerCase() == "advisor"
                    ? [
                        Tab(
                            child: Container(
                          padding: EdgeInsets.only(left: 24, right: 24),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Project Detail",
                            ),
                          ),
                        )),
                        Tab(
                            child: Container(
                          padding: EdgeInsets.only(left: 24, right: 24),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Comments",
                            ),
                          ),
                        )),
                      ]
                    : [])),
      ),
      pinned: true,
    );
  }

  SliverAppBar getSliverAppbar() {
    return SliverAppBar(
      shape: const RoundedRectangleBorder(
        side: BorderSide(width: 0),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(17), bottomRight: Radius.circular(17)),
      ),
      expandedHeight: 170.0,
      floating: false,
      stretch: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          centerTitle: false,
          title: LayoutBuilder(
            builder: (contextt, constraints) => Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: constraints.maxWidth - 20,
                  child: Text("${widget.proposal.title ?? ""}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Circular Std",
                        fontSize: 14.0,
                      )),
                ),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                        ((widget.proposal?.sendedProposals ?? []).length > 0
                                ? (widget.proposal?.sendedProposals?[0]
                                        ?["Status"] ??
                                    "pending")
                                : "pending")
                            .toString()
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Circular Std",
                          fontSize: 8.0,
                        )),
                  ),
                ),
                constraints.maxHeight > 95
                    ? Wrap(
                        direction: Axis.vertical,
                        children: [
                          SizedBox(
                            height: constraints.maxHeight > 220
                                ? constraints.maxHeight - 210
                                : 10,
                          ),
                          groupState.group != null &&
                                  groupState.group!.students != null &&
                                  (groupState.group!.students!.length ?? 0) > 0
                              ? trainersList()
                              : const SizedBox(height: 20),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      )
                    : const SizedBox()
              ],
            ),
          ),
          background: productThumbnail()),
    );
  }

  Widget trainersList() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 200,
      child: Row(
        children: [
          ImageStack(
            backgroundColor: Colors.white,
            imageList: images.sublist(
                0,
                (groupState.group?.students?.length ?? 0) > 2
                    ? 2
                    : (groupState.group?.students?.length ?? 0)),
            totalCount: groupState.group?.students?.length ?? 0,
            imageRadius: 25.0, // Radius of each images
            imageCount: 2,
            imageBorderColor: Colors.white,
            imageBorderWidth: 1, // Border width around the images
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  Widget productThumbnail() {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: [
            "https://d2slcw3kip6qmk.cloudfront.net/marketing/blog/2019Q1/product-manager/what-does-a-project-manager-do-header@2x.png",
            "https://www.shutterstock.com/image-vector/doodle-vector-illustration-planning-forecasting-260nw-612308510.jpg",
            "https://media.licdn.com/dms/image/C4D12AQHkpQfSMOKY0g/article-cover_image-shrink_720_1280/0/1520082855752?e=2147483647&v=beta&t=NCpkrORrhhopFx_IWHWwJYy-eCxZLMYAA1644JJyj5w",
            "https://manoskyriakakis.com/wp-content/uploads/2022/02/breaking-into-product-management-1.jpg",
            "https://generalassemb.ly/sites/default/files/styles/program_header_desktop_xxl_1x/public/2019-12/1_PDM_HeaderImage_121019.jpg?itok=ftl5eGhL"
          ][Random().nextInt(4)],
          fit: BoxFit.cover,
        ),
        Opacity(
            opacity: 0.5,
            child: Container(
              color: Colors.black,
            ))
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => 65;
  @override
  double get maxExtent => 65;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 14, bottom: 14, left: 24, right: 24),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
          borderRadius: BorderRadius.only()),
      child: Container(width: double.infinity, child: _tabBar),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
