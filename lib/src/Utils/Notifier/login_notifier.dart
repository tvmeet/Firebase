import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase/src/Utils/Notifier/signup_notifier.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Constant/app_keys.dart';
import '../../Constant/app_string.dart';
import '../../Constant/app_tables.dart';
import '../../Model/facebook_data_model.dart';
import '../../Model/user_data_model.dart';
import '../../Page/DashboardScreen/dashboard_page.dart';
import '../../Page/LoginScreen/login_screen_vc.dart';
import '../../Widget/utility.dart';
import '../Mixins/alert_dialog.dart';
import '../Validation/validation.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginNotifier extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  void signInwithGoogle(BuildContext context) async {
    googleSignIn.signOut();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      //print("Login with google : ${FirebaseAuth.instance.currentUser!.email}");
      await _auth.signInWithCredential(credential).then((value) {
        dataModel = UserDataModel(
            value.user!.displayName,
            value.user!.email,
            value.user!.phoneNumber,
            "123456",
            Theme.of(context).platform == TargetPlatform.android
                ? "Android"
                : Theme.of(context).platform == TargetPlatform.iOS
                    ? "Ios"
                    : "Web",
            "google",
            DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now()));
        FirebaseFirestore.instance
            .collection(AppTables.fireStoreCollectionName)
            .add(dataModel!.toJson(dataModel!))
            .whenComplete(() {
          Utility.showToast(context, SignupStrings.registrationSuccessMsg);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                      value.user!.photoURL!.replaceAll("s96-c", "s192-c"),
                      value.user!.displayName,
                      value.user!.email,
                      value.user!.phoneNumber)));
        });
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      rethrow;
    }
  }

  void signInWithFacebook(BuildContext context) async {
    print('Facebook Login');
    final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        loginBehavior: LoginBehavior.webOnly);
    if (loginResult.status == LoginStatus.success) {
      Utility.showToast(context, LoginStrings.loginSuccessMsg);
      final graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${loginResult.accessToken!.token}'));
      print(graphResponse.body);
      print(
          jsonDecode(graphResponse.body)["picture"]["data"]["url"].toString());
      //Utility.showLoader(true, context, "Profile load\nPlease wait...");
      final AccessToken fbToken = loginResult.accessToken!;
      final AuthCredential credential =
          FacebookAuthProvider.credential(fbToken.token);
      UserCredential result = await _auth.signInWithCredential(credential);
      FacebookDataModel facebookDataModel = FacebookDataModel(
          jsonDecode(graphResponse.body)["name"],
          jsonDecode(graphResponse.body)["first_name"],
          jsonDecode(graphResponse.body)["last_name"],
          jsonDecode(graphResponse.body)["picture"]["data"]["url"].toString(),
          result.user!.email,
          result.user!.phoneNumber);
      dataModel = UserDataModel(
          jsonDecode(graphResponse.body)["name"],
          result.user!.email,
          result.user!.phoneNumber,
          "123456",
          Theme.of(context).platform == TargetPlatform.android
              ? "Android"
              : Theme.of(context).platform == TargetPlatform.iOS
                  ? "Ios"
                  : "Web",
          "facebook",
          DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now()));
      FirebaseFirestore.instance
          .collection(AppTables.fireStoreCollectionName)
          .add(dataModel!.toJson(dataModel!))
          .whenComplete(() {
        Utility.showToast(context, SignupStrings.registrationSuccessMsg);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardScreen(
                    facebookDataModel.profileUrl,
                    facebookDataModel.fullName,
                    facebookDataModel.email,
                    facebookDataModel.phone)));
      });
      //Utility.showLoader(false, context, "Profile load\nPlease wait...");
    } else {
      Utility.showToast(context, LoginStrings.loginFailedMsg);
    }
  }

  bool? validate(BuildContext context) {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      if (emailController.text.isEmpty) {
        Utility.showToast(context, LoginStrings.enterEmailMsg);
      } else if (passwordController.text.isEmpty) {
        Utility.showToast(context, LoginStrings.enterPasswordMsg);
        return false;
      }
      return false;
    } else if (!Validation.validateEmail(emailController.value.text)) {
      Utility.showToast(context, LoginStrings.enterValidEmailMsg);
      return false;
    } else {
      return true;
    }
  }

  void loginWithExistData(BuildContext context) async {
    if (validate(context) == true) {
      Utility.showLoader(
        true,
        context,
        LoginStrings.loginWaitMsg,
      );
      try {
        await FirebaseFirestore.instance
            .collection(AppTables.fireStoreCollectionName)
            .where(FirestoreFields.email, isEqualTo: emailController.text)
            .get()
            .then((value) async {
          if (value.docs.isNotEmpty) {
            await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                  email: emailController.text,
                  password: Utility.generateMd5(passwordController.text),
                )
                .then((user) => {
                      if (user.user != null)
                        {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardScreen(
                                      "",
                                      value.docs
                                          .single[FirestoreFields.fullName],
                                      value.docs.single[FirestoreFields.email],
                                      value.docs
                                          .single[FirestoreFields.phone]))),
                          Utility.hideLoader(context),
                          emptyInputs()
                        }
                      else
                        {
                          Utility.hideLoader(context),
                          emptyInputs(),
                          Utility.showToast(
                            context,
                            LoginStrings.invalidDataMsg,
                          ),
                        }
                    });
          } else {
            Utility.hideLoader(context);
            emptyInputs();
            Utility.showToast(
              context,
              LoginStrings.invalidDataMsg,
            );
          }
        });
      } catch (e) {
        print(e.toString());
        Utility.hideLoader(context);
        emptyInputs();
        Utility.showToast(
          context,
          LoginStrings.invalidDataMsg,
        );
      }
    }
  }

  void emptyInputs() {
    emailController.text = passwordController.text = "";
  }

  Future resetPassword({required String? email}) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email!)
          .then((value) => {});
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CustomAlertDialog(
              context: context,
              title: DashboardStrings.logoutAlertTitle,
              content: DashboardStrings.logoutAlertMsg,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      elevation: 4,
                      shadowColor: Colors.white),
                  child: const Text(DashboardStrings.logoutAlertCancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      elevation: 4,
                      shadowColor: Colors.white),
                  child: const Text(DashboardStrings.logoutAlertLogout),
                  onPressed: () async {
                    Utility.showLoader(
                        true, context, DashboardStrings.logoutWaitMsg);
                    await _auth.signOut().whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    });
                  },
                ),
              ]);
        });
  }
}

