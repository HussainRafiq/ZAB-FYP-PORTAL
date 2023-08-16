// import 'package:flutter/material.dart';
// import 'package:lmsv4_flutter_app/models/system_parameters_model.dart';

// class RegistrationExtraFieldGeneratorController {
//   List<RegistrationExtraField> registerFields;
//   List<String> errorMessages = [];
//   Map<String, dynamic> response = {};
//   RegistrationExtraFieldGeneratorController(this.registerFields);
//   bool validate() {
//     return true;
//   }

//   void addOrUpdateValue(key, value) {
//     if (response.containsKey(key)) {
//       response[key] = value;
//     } else {
//       response.putIfAbsent(key, () => value);
//     }
//   }
// }

// class RegistrationExtraFieldGenerator extends StatefulWidget {
//   RegistrationExtraFieldGeneratorController? controller;
//   RegistrationExtraFieldGenerator({Key? key, required this.controller})
//       : super(key: key);

//   @override
//   State<RegistrationExtraFieldGenerator> createState() =>
//       RegistrationExtraFieldGeneratorState();
// }

// class RegistrationExtraFieldGeneratorState
//     extends State<RegistrationExtraFieldGenerator> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Column(
//       children: List<Widget>.generate(
//           widget.controller?.registerFields.length ?? 0,
//           (i) => getPropWidget(widget.controller?.registerFields[i])),
//     );
//   }

//   Widget getPropWidget(RegistrationExtraField? registrationExtraField) {
//     // ignore: unnecessary_null_comparison
//     if (registrationExtraField == null) return const SizedBox();

//     switch (registrationExtraField.type.toLowerCase()) {
//       case "radio":
//         return RadioButtonWidget(registrationExtraField);
//       default:
//         return SizedBox();
//     }
//   }

//   Widget RadioButtonWidget(RegistrationExtraField registrationExtraField) {
//     var props = registrationExtraField.properties;

//     String radioStyle =
//         props.containsKey("radioStyle") ? props["radioStyle"] : null;
//     var items = props.containsKey("RadioButtonItems")
//         ? props["RadioButtonItems"] as List
//         : [];

//     if (radioStyle.toLowerCase() == "buttons") {
//       return LayoutBuilder(builder: (context, constraints) {
//         return ToggleButtons(
//           fillColor: Theme.of(context).colorScheme.primary,
//           color: Theme.of(context).colorScheme.primary,
//           constraints: BoxConstraints.expand(
//               width: (constraints.maxWidth - 5) /
//                   items.length), //number 2 is number of toggle buttons
//           selectedColor: Theme.of(context).colorScheme.onPrimary,
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           children: List<Widget>.generate(
//               items.length,
//               (i) => Padding(
//                   padding:
//                       EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15),
//                   child: Text(items[i]["DisplayName"]))),
//           isSelected: List<bool>.generate(items.length,
//               (i) => items[i]["checked"].toString().toLowerCase() == "true"),
//           onPressed: (int index) {
//             setState(() {
//               items.forEach((element) {
//                 element["checked"] = "false";
//               });
//               items[index]["checked"] = "true";
//               if (widget.controller != null) {
//                 widget.controller?.addOrUpdateValue(
//                     registrationExtraField.key, items[index]["value"]);
//               }
//             });
//           },
//         );
//       });
//     } else {
//       return Flex(
//         direction: Axis.horizontal,
//         children: List<Widget>.generate(
//             items.length,
//             (i) => Flexible(
//                   child: ListTile(
//                       leading: Radio<String>(
//                         value: items[i]["value"],
//                         groupValue: items.firstWhere(
//                                 (x) => x["checked"] == "true")?["value"] ??
//                             "",
//                         onChanged: (value) {
//                           setState(() {
//                             items.forEach((element) {
//                               element["checked"] = "false";
//                               if (element["value"] == value) {
//                                 element["checked"] = "true";
//                               }
//                             });
//                             if (widget.controller != null) {
//                               widget.controller?.addOrUpdateValue(
//                                   registrationExtraField.key, value);
//                             }
//                           });
//                         },
//                       ),
//                       title: Text(items[i]["DisplayName"])),
//                 )),
//       );
//     }
//   }
// }
