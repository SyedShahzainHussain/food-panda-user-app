import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_app/firebase/firebase_storage/firebase_storage.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/view/my_splash_screen/my_splash_screen.dart';
import 'package:user_app/widget/alert_dialog.dart';
import 'package:user_app/widget/loading_dialog.dart';

class SignUpViewModel with ChangeNotifier {
  void signUpUsers(
    BuildContext context,
    XFile? imageXFile,
    String email,
    String password,
    String? name,
  ) async {
    showDialog(
      context: context,
      builder: (context) => const LoadingDialog(
        message: "Register Account",
      ),
    );

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    await FirebaseStorageFile.uploadFileToStorage(fileName, imageXFile!)
        .then((value) {
      signUpAuthentication(email, password, name, value.toString(), context)
          .then((value) {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false);
      });
    });
  }

  // ! sign up
  Future<void> signUpAuthentication(
    String email,
    String password,
    String? name,
    String? imageUrl,
    BuildContext context,
  ) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential? userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await saveDataToFirebase(
          userCredential.user,
          name: name,
          imageUrl: imageUrl,
        );
      }
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      String? errorMessage;
      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "Email already in use";
          break;
        case "invalid-email":
          errorMessage = "Invalid email";
          break;
        case "weak-password":
          errorMessage = "Weak password";
          break;
        case "operation-not-allowed":
          errorMessage = "Youe email is not allowed";
          break;
      }
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) => ErrorDialog(
                message: errorMessage,
              ));
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) => const ErrorDialog(
                message: "Error Occured",
              ));
    }
  }

  // ! save Data to firebase
  Future<void> saveDataToFirebase(
    User? currentUser, {
    String? name,
    String? imageUrl,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .set({
      "userId": currentUser.uid,
      "userEmail": currentUser.email,
      "userName": name!.trim(),
      "userAvatarUrl": imageUrl,
      "status": "approved",
      "userCart": ["garbageValue"]
    });
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", name.trim());
    await sharedPreferences!.setString("photoUrl", imageUrl.toString());
    await sharedPreferences!.setStringList("userCart", ["garbageValue"]);
  }
}
