import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/components/toaster.dart';
import 'package:lmsv4_flutter_app/constants/messages.dart';
import 'package:lmsv4_flutter_app/models/advisor_model.dart';
import 'package:lmsv4_flutter_app/screens/proposal_detail.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:lmsv4_flutter_app/state/group.module.dart';
import 'package:lmsv4_flutter_app/state/proposal.module.dart';
import 'package:provider/provider.dart';

class ProposalListPage extends StatefulWidget {
  ProposalListPage({Key? key}) : super(key: key);

  @override
  State<ProposalListPage> createState() => _ProposalListPageState();
}

class _ProposalListPageState extends State<ProposalListPage> {
  late AuthState authState;
  ProposalState? proposalState;

  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    authState = context.read<AuthState>();
    proposalState = ProposalState();

    authState.addListener(() {
      if (authState.AuthStatus == AuthenticationStatus.FAILED) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/signinwithemail', (Route<dynamic> route) => false);
      }
      setState(() {});
    });
    proposalState?.addListener(() {
      setState(() {});
    });

    proposalState!.getProposals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Proposals List")),
        body: Container(
          child: ListView(
            children: [
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: proposalState?.proposals != null &&
                          (proposalState?.proposals?.length ?? 0) > 0
                      ? Column(
                          children: List.generate(
                              (proposalState?.proposals ?? []).length,
                              (index) => proposalsListItem(context, index)),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Center(
                                child: Wrap(
                                  direction: Axis.vertical,
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.line_style_rounded,
                                      size: 128,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "No Students proposals",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
            ],
          ),
        ));
  }

  Widget proposalsListItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProposalDetail(proposal: proposalState!.proposals![index]),
            ));
      },
      child: Stack(
        children: [
          new Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: new BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: new ListTile(
                contentPadding: EdgeInsets.all(10),
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
                    cutOverText(
                        (proposalState!.proposals?[index].description ?? "")),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 12),
                  ),
                ),
              )),
          (proposalState!.proposals?[index]?.sendedProposals?[0]["Status"] ??
                          "")
                      .toString()
                      .toLowerCase() ==
                  "interested"
              ? Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(15)),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Text(
                      "Interested",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ))
              : SizedBox(),
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
}
