import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Constant/app_string.dart';
import '../../Widget/utility.dart';
TextEditingController emailController = TextEditingController();
class ForgotPasswordNotifier extends ChangeNotifier{
  final _auth = FirebaseAuth.instance;

  forgotPassword(BuildContext context) async {
    if (emailController.text.isEmpty) {
      if (emailController.text.isEmpty) {
        Utility.showToast(context, LoginStrings.enterEmailMsg);
      }
      return;
    }
    else{
      sendLink(context, emailController.text);
    }
  }

  sendLink(BuildContext context, String email) async {
    try {
      Utility.showLoader(
        true,
        context,
        ForgotPasswordStrings.forgotInPleaseWait,
      );
      await sendPasswordResetEmail(email);
      Utility.hideLoader(context);
      Utility.showToast(
        context,
        "Check your email and reset your password",
      );
    }
    catch (e) {
      Utility.showToast(
        context,
        "Please enter your valid email address",
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
}