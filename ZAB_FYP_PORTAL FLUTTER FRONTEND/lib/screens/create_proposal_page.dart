import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lmsv4_flutter_app/components/toaster.dart';
import 'package:lmsv4_flutter_app/constants/messages.dart';
import 'package:lmsv4_flutter_app/models/advisor_model.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:lmsv4_flutter_app/state/group.module.dart';
import 'package:lmsv4_flutter_app/state/proposal.module.dart';
import 'package:provider/provider.dart';

class CreateProposalPage extends StatefulWidget {
  CreateProposalPage({Key? key}) : super(key: key);

  @override
  State<CreateProposalPage> createState() => _CreateProposalPageState();
}

class _CreateProposalPageState extends State<CreateProposalPage> {
  late AuthState authState;
  GroupState? groupState;
  ProposalState? proposalState;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late String? _title;
  late String? _description;
  bool isLoading = false;
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    authState = context.read<AuthState>();
    groupState = context.read<GroupState>();
    proposalState = context.read<ProposalState>();

    authState.addListener(() {
      if (authState.AuthStatus == AuthenticationStatus.FAILED) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/signinwithemail', (Route<dynamic> route) => false);
      }
      setState(() {});
    });

    groupState?.getGroup();
    groupState?.addListener(() {
      setState(() {});
    });

    proposalState?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Create Proposal")),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Title',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter title here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _title = value;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 10,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter description here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value;
                    },
                    maxLines: 15,
                  ),
                  SizedBox(height: 16.0),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _submitForm();
                            }
                          },
                          color: Theme.of(context).colorScheme.primary,
                          textColor: Colors.white,
                          child: Text('Submit'),
                        ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _submitForm() async {
    setState(() {
      isLoading = true;
    });
    var purposal = await proposalState!.addProposal(
        _titleController.value.text, _descriptionController.value.text);
    if (purposal != null) {
      _titleController.clear();
      _descriptionController.clear();
      proposalState!.getProposals();
      Navigator.of(context).pop();
    }
  }
}
