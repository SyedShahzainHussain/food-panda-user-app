import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:user_app/viewModel/auth_view_model/sign_up_view_model.dart';
import 'package:user_app/widget/alert_dialog.dart';
import 'package:user_app/widget/custom_text_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  XFile? imageXFile;

  final ImagePicker picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();

  final ValueNotifier<bool> password = ValueNotifier<bool>(true);
  final ValueNotifier<bool> confirmPassword = ValueNotifier<bool>(true);

  Position? position;
  List<Placemark>? placemark;
  String? imageUrl;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              getImage();
            },
            child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile == null
                    ? null
                    : FileImage(File(imageXFile!.path)),
                child: imageXFile == null
                    ? const Icon(
                        Icons.add_photo_alternate,
                        color: Colors.grey,
                      )
                    : null),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              CustomTextField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(emailFocus);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter a Name";
                  }
                  return null;
                },
                icon: Icons.person,
                controller: nameController,
                hintText: "Name",
                isObsecure: false,
              ),
              CustomTextField(
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(passwordFocus);
                },
                keyboardType: TextInputType.emailAddress,
                focusNode: emailFocus,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter a Email";
                  } else if (!value.contains("@")) {
                    return "Enter a Special Character @";
                  }
                  return null;
                },
                icon: Icons.email,
                controller: emailController,
                hintText: "Email",
                isObsecure: false,
              ),
              ValueListenableBuilder(
                valueListenable: password,
                builder: (context, value, _) => CustomTextField(
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(confirmPasswordFocus);
                  },
                  textInputAction: TextInputAction.next,
                  focusNode: passwordFocus,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        password.value = !password.value;
                      },
                      child: value
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.cyan,
                            )
                          : const Icon(Icons.visibility, color: Colors.cyan)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a Password";
                    }
                    return null;
                  },
                  icon: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObsecure: value,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: confirmPassword,
                builder: (context, value, _) => CustomTextField(
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(phoneFocus);
                  },
                  textInputAction: TextInputAction.next,
                  focusNode: confirmPasswordFocus,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        confirmPassword.value = !confirmPassword.value;
                      },
                      child: value
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.cyan,
                            )
                          : const Icon(Icons.visibility, color: Colors.cyan)),
                  validator: (value) {
                    if (value!.isEmpty ||
                        passwordController.text != confirmController.text) {
                      return "Enter a Correct Password";
                    }
                    return null;
                  },
                  icon: Icons.lock,
                  controller: confirmController,
                  hintText: "Confirm Password",
                  isObsecure: value,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    backgroundColor: Colors.cyan,
                  ),
                  onPressed: () {
                    saveData();
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
            ]),
          )
        ],
      ),
    );
  }

  // ! save Data
  void saveData() {
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }
    if (imageXFile == null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const ErrorDialog(
                message: "Pick An Image",
              ));
    }
    if (validate) {
      _formKey.currentState!.save();
      context.read<SignUpViewModel>().signUpUsers(
            context,
            imageXFile,
            emailController.text,
            passwordController.text,
            nameController.text,
          );
    }
  }

  // ! pick image
  Future<void> getImage() async {
    imageXFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }
}
