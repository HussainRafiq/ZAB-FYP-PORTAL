import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lmsv4_flutter_app/components/edt_user_profile/profile_edit_textbox.dart';
import 'package:lmsv4_flutter_app/components/toaster.dart';
import 'package:lmsv4_flutter_app/components/ui_componenets.dart';
import 'package:lmsv4_flutter_app/constants/messages.dart';
import 'package:lmsv4_flutter_app/exceptions/generic_message_exception.dart';
import 'package:lmsv4_flutter_app/models/user_model.dart';
import 'package:lmsv4_flutter_app/state/auth.module.dart';
import 'package:lmsv4_flutter_app/state/user.module.dart';
import 'package:lmsv4_flutter_app/utils/responsive.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late AuthState authState;
  late UserState userState;
  UserModel? user;

  TextEditingController firstName_field = TextEditingController();
  TextEditingController lastName_field = TextEditingController();
  TextEditingController username_field = TextEditingController();
  TextEditingController email_field = TextEditingController();
  TextEditingController phone_field = TextEditingController();
  TextEditingController city_field = TextEditingController();
  TextEditingController country_field = TextEditingController();
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  initState() {
    authState = context.read<AuthState>();
    userState = context.read<UserState>();
    userState.addListener(() {
      setState(() {});
    });
    authState.checkIsAuthenticated();
    authState.addListener(() {
      if (authState.AuthStatus == AuthenticationStatus.AUTHENTICATED &&
          authState.user != null) {
        user = authState.user!;
        setState(() {
          firstName_field.text = user?.firstName ?? "";
          lastName_field.text = user?.lastName ?? "";
          username_field.text = user?.username ?? "";
          email_field.text = user?.email ?? "";
          phone_field.text = PhoneNumber.parse(
            user!.phoneNumber!,
          ).nsn;
          // city_field.text = user?.city ?? "";
          // country_field.text = user?.countryCode ?? "";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var profileInfo = Column(
      children: <Widget>[
        Container(
          height: 150,
          width: 150,
          margin: EdgeInsets.only(top: 30),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(75),
            boxShadow: [
              new BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10.0,
              ),
            ],
          ),
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
                            // (authState.user?.profilePicture ?? "").isEmpty
                            // ?
                            Image.asset('assets/images/profile-picture.png')
                        // : Image.network('${authState.user?.profilePicture!}'),
                        ),
                  ),
                ),
              ),
              userState.currentDataState != DataStates.UPLOADING
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          onPressed:
                              userState.currentDataState != DataStates.UPLOADING
                                  ? () {
                                      uploadProfilePicture();
                                    }
                                  : null,
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              heightFactor: 25,
                              widthFactor: 25,
                              child: userState.currentDataState !=
                                      DataStates.UPLOADING
                                  ? Icon(
                                      Icons.upload,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 25,
                                    )
                                  : CircularProgressIndicator(),
                            ),
                          )))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Container(
                        color: Theme.of(context).colorScheme.primary,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ))
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 30),
        profileInfo,
        SizedBox(width: 30),
      ],
    );

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: CustomAppBar(
          context,
          "Edit Profile",
        ),
        body: user != null
            ? Center(
                child: Container(
                  constraints:
                      BoxConstraints(maxWidth: Responsive.maxDesktopWidth),
                  child: Builder(
                    builder: (context) {
                      return ListView(
                        children: <Widget>[
                          SizedBox(height: 50),
                          header,
                          Container(
                            padding: EdgeInsets.all(15),
                            child: GridView.count(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(17),
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2 / 0.25,
                              crossAxisCount:
                                  Responsive.isMobile(context) ? 1 : 2,
                              children: <Widget>[
                                ProfileEditTextbox(
                                    icon: Icons.person,
                                    label: 'First Name',
                                    placeholder: "Enter First Name",
                                    value: authState.user?.firstName ?? "",
                                    controller: firstName_field,
                                    onChanged: ((value) {
                                      user?.firstName = value;
                                    })),
                                ProfileEditTextbox(
                                    icon: Icons.person,
                                    label: 'Last Name',
                                    placeholder: "Enter Last Name",
                                    controller: lastName_field,
                                    value: authState.user?.lastName ?? "",
                                    onChanged: ((value) {
                                      user?.lastName = value;
                                    })),
                                ProfileEditTextbox(
                                    icon: Icons.person_outline_sharp,
                                    label: 'Username',
                                    placeholder: "Enter Username",
                                    controller: username_field,
                                    value: authState.user?.email ?? "",
                                    onChanged: ((value) {
                                      user?.username = value;
                                    })),
                                ProfileEditTextbox(
                                    icon: Icons.email,
                                    label: 'Email',
                                    disabled: true,
                                    controller: email_field,
                                    placeholder: "Enter Email",
                                    value: ""),
                                // ProfileEditTextbox(
                                //     icon: Icons.phone,
                                //     isPhoneField: true,
                                //     label: 'Phone Number',
                                //     controller: phone_field,
                                //     placeholder: "Enter Phone Number",
                                //     value: "",
                                //     countryCode: PhoneNumber.parse(
                                //       user!.phone!,
                                //     ).isoCode.name,
                                //     onChanged: ((value) {
                                //       user?.phone = value;
                                //     })),
                                // ProfileEditTextbox(
                                //     icon: Icons.location_city,
                                //     label: 'City',
                                //     controller: city_field,
                                //     placeholder: "Enter City",
                                //     value: "",
                                //     onChanged: ((value) {
                                //       user?.city = value;
                                //     })),
                                // ProfileEditTextbox(
                                //     icon: Icons.location_on,
                                //     label: 'Country',
                                //     controller: country_field,
                                //     isCountry: true,
                                //     placeholder: "Enter Country",
                                //     value: "",
                                //     onChanged: ((value) {
                                //       user?.countryCode = value;
                                //     })),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          userState.currentDataState == DataStates.FETCHING ||
                                  userState.currentDataState ==
                                      DataStates.UPLOADING
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : buttons(context),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      );
                    },
                  ),
                ),
              )
            : const Center(
                child: Loading(),
              ));
  }

  Row buttons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: const Text(
          'Update',
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          submit();
        },
      ),
      SizedBox(
        width: 20,
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Text(
          'Cancel',
          style: TextStyle(
              fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ]);
  }

  Future<void> uploadProfilePicture() async {
    if (kIsWeb) {
      takePictureFromGallery();
      return;
    }
    openImagePickingBottomSheet(context);
  }

  void openImagePickingBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(27), topRight: Radius.circular(27)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Wrap(
            children: <Widget>[
              const Text("Action",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.camera_alt),
                  title: Text(
                    "Take picture from camera",
                  ),
                  onTap: () {
                    takePictureFromCamera();
                    Navigator.pop(context);
                  },
                ),
              ),
              Divider(),
              SizedBox(
                height: 40,
                child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    isThreeLine: false,
                    leading: Icon(Icons.image_rounded),
                    title: Text(
                      "Pick from gallery",
                    ),
                    onTap: () {
                      takePictureFromGallery();
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  takePictureFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Capture a photo
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    uploadImageAndSave(photo);
  }

  takePictureFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    uploadImageAndSave(image);
  }

  void uploadImageAndSave(XFile? image) {
    userState.uploadProfilePicture(image, user!).then((value) {
      if (value != "") {
        // setState(() {
        //   user?.profilePicture = value;
        // });
        authState.checkIsAuthenticated();
      }
    });
  }

  Future<void> submit() async {
    if (isValidate()) {
      try {
        var userprofile = await userState.updateUserProfile(user!);
        authState.checkIsAuthenticated();
      } catch (ex) {
        if (ex is GenericMessageException) {
          CustomToast.ShowMessage((ex as GenericMessageException).Message,
              context: context);
        }
      }
    }
  }

  bool isValidate() {
    bool isvalidate = true;
    if ((user?.firstName ?? "").isEmpty) {
      CustomToast.ShowMessage(INPUT_VALIDATION_MESSAGE, context: context);
      isvalidate = false;
    }

    if ((user?.lastName ?? "").isEmpty) {
      CustomToast.ShowMessage(INPUT_VALIDATION_MESSAGE, context: context);
      isvalidate = false;
    }

    if ((user?.username ?? "").isEmpty) {
      CustomToast.ShowMessage(INPUT_VALIDATION_MESSAGE, context: context);
      isvalidate = false;
    }

    // if ((user?.city ?? "").isEmpty) {
    //   CustomToast.ShowMessage(context, INPUT_VALIDATION_MESSAGE);
    //   isvalidate = false;
    // }

    return isvalidate;
  }
}
