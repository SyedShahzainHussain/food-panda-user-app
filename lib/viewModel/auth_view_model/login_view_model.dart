import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/view/authentication/auth_screen.dart';
import 'package:user_app/view/my_splash_screen/my_splash_screen.dart';
import 'package:user_app/widget/alert_dialog.dart';
import 'package:user_app/widget/loading_dialog.dart';

class LoginViewModel with ChangeNotifier {
  loginData(BuildContext context, String email, String password) async {
    showDialog(
      context: context,
      builder: (context) => const LoadingDialog(
        message: "Checking Credentials",
      ),
    );
    try {
      UserCredential? usercredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // ignore: use_build_context_synchronously
      await readDataFromFirebase(usercredential.user!, context);
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      String? errorMessage = "Error Occured";
      switch (e.code) {
        case "invalid-email":
          errorMessage = "User Credentials Failed";
          break;

        case "user-not-found":
          errorMessage = "User Credentials Not Found";
          break;
        case "wrong-password":
          errorMessage = "User Credentials Invalid Password";
          break;
        case "invalid-credential":
          errorMessage = "Invalid Credentials";
          break;
      }
      // ignore: use_build_context_synchronously
      return showDialog(
          context: context,
          builder: (context) => ErrorDialog(
                message: errorMessage,
              ));
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      return showDialog(
          context: context,
          builder: (context) => ErrorDialog(
                message: e.toString(),
              ));
    }
  }

  Future<void> readDataFromFirebase(User? user, context) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) async {
      // ignore: unnecessary_null_comparison
      if (value != null || value.exists) {
        if (value.data()!["status"] == "approved") {
          List<String> userCartList = value.data()!["userCart"].cast<String>();
          sharedPreferences = await SharedPreferences.getInstance();
          await sharedPreferences!.setString("uid", user.uid);
          await sharedPreferences!
              .setString("email", value.data()!["userEmail"]);
          await sharedPreferences!.setString("name", value.data()!["userName"]);
          await sharedPreferences!
              .setString("photoUrl", value.data()!["userAvatarUrl"]);
          await sharedPreferences!.setStringList("userCart", userCartList);

          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
              (route) => false);
        } else {
          await FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
              (route) => false);
          return Fluttertoast.showToast(
              msg: "Admin has blocked your account");
        }
      }
    }).onError((error, stackTrace) async {
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false);
      return showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "No Record found",
            );
          });
    });
  }
}
