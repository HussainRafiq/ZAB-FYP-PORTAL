// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import '../components/extra_props_field_generator.dart';

// class Register extends StatefulWidget {
//   Register({Key? key}) : super(key: key);

//   @override
//   State<Register> createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   RegistrationExtraFieldGeneratorController? _controller;
//   SystemParameters? _systemParameters;
//   List<RegistrationExtraField>? _extraPropsFields;

//   @override
//   initState() {
//     super.initState();
//     fetchSystemParams();
//   }

//   fetchSystemParams() async {
//     _extraPropsFields = _systemParameters?.userRegisterExtraFields;

//     _controller =
//         RegistrationExtraFieldGeneratorController(_extraPropsFields ?? []);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         title: Text("Register Student",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14,
//               color: Theme.of(context).colorScheme.onPrimary,
//             )),
//       ),
//       backgroundColor: Theme.of(context).colorScheme.onPrimary,
//       body: ListView(
//         children: [
//           Center(
//             child: Container(
//               color: Colors.white,
//               constraints: BoxConstraints(
//                   maxWidth: 500, minHeight: MediaQuery.of(context).size.height),
//               padding: const EdgeInsets.only(left: 30, right: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                     width: 300,
//                     child: Text(
//                       "Register Your Account",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).colorScheme.onBackground,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   //First name
//                   TextField(
//                     autocorrect: true,
//                     decoration: InputDecoration(
//                       hintText: 'Enter Your First Name',
//                       prefixIcon: Icon(
//                         Icons.person_outline,
//                         color: Theme.of(context).colorScheme.onBackground,
//                       ),
//                       hintStyle: TextStyle(color: Colors.grey),
//                       filled: true,
//                       fillColor: Colors.white70,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(12.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   //Last name
//                   TextField(
//                     autocorrect: true,
//                     decoration: InputDecoration(
//                       hintText: 'Enter Your Last Name',
//                       prefixIcon: Icon(
//                         Icons.person_outline,
//                         color: Theme.of(context).colorScheme.onBackground,
//                       ),
//                       hintStyle: TextStyle(color: Colors.grey),
//                       filled: true,
//                       fillColor: Colors.white70,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(12.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   //Phone Number
//                   IntlPhoneField(
//                     decoration: InputDecoration(
//                       hintText: 'Enter Your Phone',
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       filled: true,
//                       fillColor: Colors.white70,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(12.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   //Email
//                   TextField(
//                     autocorrect: true,
//                     decoration: InputDecoration(
//                       hintText: 'Enter Your Email',
//                       prefixIcon: Icon(
//                         Icons.email_outlined,
//                         color: Theme.of(context).colorScheme.onBackground,
//                       ),
//                       hintStyle: TextStyle(color: Colors.grey),
//                       filled: true,
//                       fillColor: Colors.white70,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(12.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   //Password
//                   TextField(
//                     autocorrect: true,
//                     keyboardType: TextInputType.visiblePassword,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintText: 'Enter Password',
//                       prefixIcon: Icon(
//                         Icons.lock,
//                         color: Theme.of(context).colorScheme.onBackground,
//                       ),
//                       hintStyle: TextStyle(color: Colors.grey),
//                       filled: true,
//                       fillColor: Colors.white70,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(12.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   //Confirm Password
//                   TextField(
//                     autocorrect: true,
//                     keyboardType: TextInputType.visiblePassword,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintText: 'Enter Confirm Password',
//                       prefixIcon: Icon(
//                         Icons.lock,
//                         color: Theme.of(context).colorScheme.onBackground,
//                       ),
//                       hintStyle: TextStyle(color: Colors.grey),
//                       filled: true,
//                       fillColor: Colors.white70,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(12.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   //City
//                   TextField(
//                     autocorrect: true,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintText: 'Enter City',
//                       prefixIcon: Icon(
//                         Icons.location_on,
//                         color: Theme.of(context).colorScheme.onBackground,
//                       ),
//                       hintStyle: TextStyle(color: Colors.grey),
//                       filled: true,
//                       fillColor: Colors.white70,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(12.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderSide: BorderSide(
//                             color: Theme.of(context).colorScheme.primary,
//                             width: 2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   _extraPropsFields != null &&
//                           (_extraPropsFields?.length ?? 0) > 0
//                       ? RegistrationExtraFieldGenerator(controller: _controller)
//                       : Container(),

//                   Wrap(
//                     crossAxisAlignment: WrapCrossAlignment.center,
//                     direction: Axis.horizontal,
//                     children: [
//                       Checkbox(
//                           value: true,
//                           onChanged: (val) {},
//                           activeColor: Theme.of(context).colorScheme.primary),
//                       Text(
//                         "I agree to the Terms of use and Privacy Policy.",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Theme.of(context).colorScheme.onBackground,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 25,
//                   ),
//                   RegisterButton(
//                       SizedBox(), "Sign Up", () => signWithEmailOnPressed()),
//                   const SizedBox(
//                     height: 50,
//                   ),
//                   Text(
//                     "Already Have An Account?",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Theme.of(context).colorScheme.onBackground,
//                     ),
//                   ),
//                   Center(
//                       child: InkWell(
//                     child: Text(
//                       "Login Here",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         decoration: TextDecoration.underline,
//                         color: Theme.of(context).colorScheme.onBackground,
//                       ),
//                     ),
//                   )),
//                   const SizedBox(
//                     height: 40,
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget ExtraFieldsPropertiesGenerator() {
//     return Column(
//       children: List<Widget>.generate(
//           _extraPropsFields?.length ?? 0, (i) => Container()),
//     );
//   }

//   Widget RegisterButton(Widget icon, String content, void onPressed) {
//     return FractionallySizedBox(
//       widthFactor: 1, // means 100%, you can change this to 0.8 (80%)
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//             elevation: 10,
//             primary: Theme.of(context).colorScheme.primary,
//             onPrimary: Theme.of(context).colorScheme.onPrimary,
//             padding: const EdgeInsets.symmetric(vertical: 17),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//         child: Wrap(
//           crossAxisAlignment: WrapCrossAlignment.center,
//           direction: Axis.horizontal,
//           children: [
//             icon,
//             SizedBox(
//               width: 10,
//             ),
//             Text(
//               content,
//               style: TextStyle(
//                   fontSize: 16, color: Theme.of(context).colorScheme.onPrimary),
//             )
//           ],
//         ),
//         onPressed: () {},
//       ),
//     );
//   }

//   void signWithEmailOnPressed() {}
// }
