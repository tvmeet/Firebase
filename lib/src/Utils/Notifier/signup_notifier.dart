import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/src/Page/DashboardScreen/dashboard_page.dart';
import 'package:intl/intl.dart';

import '../../Constant/app_string.dart';
import '../../Constant/app_tables.dart';
import '../../Model/user_data_model.dart';
import '../../Widget/utility.dart';
import '../Validation/validation.dart';

TextEditingController fullNameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPassController = TextEditingController();
UserDataModel? dataModel;

class SignupNotifier extends ChangeNotifier {
  bool? validate(BuildContext context) {
    print(
        "Password matched?:${passwordController.value.text == confirmPassController.value.text}");
    if (fullNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPassController.text.isEmpty) {
      if (fullNameController.text.isEmpty) {
        Utility.showToast(context, SignupStrings.enterFullNameMsg);
      } else if (phoneController.text.isEmpty) {
        Utility.showToast(context, SignupStrings.enterPhoneMsg);
      } else if (emailController.text.isEmpty) {
        Utility.showToast(context, SignupStrings.enterEmailMsg);
      } else if (passwordController.text.isEmpty) {
        Utility.showToast(context, SignupStrings.enterPasswordMsg);
      } else if (confirmPassController.text.isEmpty) {
        Utility.showToast(context, SignupStrings.enterConfirmPassMsg);
      }
      return false;
    } else if (!Validation.validatePhoneNumber(phoneController.value.text)) {
      Utility.showToast(context, SignupStrings.enterValidPhoneMsg);
      return false;
    } else if (!Validation.validateEmail(emailController.value.text)) {
      Utility.showToast(context, SignupStrings.enterValidEmailMsg);
      return false;
    } else if (passwordController.value.text.toString() !=
        confirmPassController.value.text.toString()) {
      Utility.showToast(context, SignupStrings.passNotMatchMsg);
      return false;
    } else {
      dataModel = UserDataModel(
          fullNameController.text,
          emailController.text,
          phoneController.text,
          "123456",
          Theme.of(context).platform == TargetPlatform.android
              ? "Android"
              : Theme.of(context).platform == TargetPlatform.iOS
                  ? "Ios"
                  : "Web",
          "email",
          DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now()));
      return true;
    }
  }

  void addData(BuildContext context) async {
    if (validate(context) != null && validate(context) == true) {
      Utility.showLoader(
        true,
        context,
        SignupStrings.registrationWaitMsg,
      );
      try {
        await FirebaseFirestore.instance
            .collection(AppTables.fireStoreCollectionName)
            .where("email", isEqualTo: dataModel!.email)
            .get()
            .then((value) async {
          if (value.docs.isNotEmpty) {
            try {
              await signUpWithEmailPassword(
                  email: dataModel!.email,
                  password: passwordController.value.text);
            } catch (e) {
              print("Error signup: " + e.toString());
            }
            Utility.showToast(context, SignupStrings.dataExistMsg);
            emptyInputs();
            Utility.hideLoader(context);
            return false;
          } else {
            print("add data signin with email pass");
            await signUpWithEmailPassword(
                    email: dataModel!.email,
                    password: passwordController.value.text)
                .whenComplete(() async {
              await FirebaseFirestore.instance
                  .collection(AppTables.fireStoreCollectionName)
                  .add(dataModel!.toJson(dataModel!))
                  .whenComplete(() {
                Utility.showToast(
                    context, SignupStrings.registrationSuccessMsg);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashboardScreen(
                            "",
                            dataModel!.fullName,
                            dataModel!.email,
                            dataModel!.number)));
                emptyInputs();
                Utility.hideLoader(context);
              });
            });
          }
        });
      } catch (e) {
        print("Error signup: " + e.toString());
      }
    }
  }

  void emptyInputs() {
    fullNameController.text = phoneController.text = emailController.text =
        passwordController.text = confirmPassController.text = "";
  }

  //Signup with email and password
  Future signUpWithEmailPassword(
      {required String? email, required String? password}) async {
    try {
      print("signin email pass");
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
