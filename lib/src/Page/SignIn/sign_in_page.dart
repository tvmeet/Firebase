

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase/main.dart';
import 'package:flutter_firebase/src/Page/Google_SignIn/google_sign_in.dart';
import 'package:flutter_firebase/src/Utils/Validation/validation.dart';
import 'package:flutter_firebase/src/Widget/password_text_box.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../Constant/app_string.dart';
import '../../Widget/button_widget.dart';
import '../../Widget/header_widget.dart';
import '../../Widget/textbox_widget.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickSignUp;
  const LoginPage({Key? key, required this.onClickSignUp}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double headerHeight = 250;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: headerHeight,
                child: HeaderWidget(headerHeight, true, Icons.login_rounded)
            ),
            SafeArea(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: [
                      const Text('Hello',
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Signing into your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              customTextField(lableText: AppString.email,
                                hintText: AppString.emailhint,
                                controller: emailController,
                                validator: (value) =>
                                  validateEmail(value)
                                  ),
                              const SizedBox(height: 15),
                              PasswordField(labelText: AppString.password,
                              controller: passwordController,
                              hintText: AppString.passhitnt, validator: (value) => validatePassword(value),),
                              const SizedBox(height: 15),
                              ButtonWidgets(
                                onTap: signIn, buttonText: 'Sign In',),
                              Container(
                                margin: const EdgeInsets.fromLTRB(
                                    10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(
                                    TextSpan(
                                        children: [
                                          const TextSpan(
                                              text: "Don't have an account? "),
                                          TextSpan(
                                            text: 'Create',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = widget.onClickSignUp,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme
                                                    .of(context)
                                                    .colorScheme
                                                    .secondary),
                                          ),
                                        ]
                                    )
                                ),
                              ),
                              const Text("Or create sign in using social media",
                                  style: TextStyle(color: Colors.grey)),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: const FaIcon(
                                      FontAwesomeIcons.googlePlus, size: 35,
                                      color: Colors.red,),
                                    onTap: () {
                                      final provider = Provider.of<
                                          GoogleSignInProvider>(
                                          context, listen: false);
                                      provider.googleLogin();
                                    },
                                  ),
                                  const SizedBox(width: 30.0,),
                                  GestureDetector(
                                    onTap: signInWithFacebook,
                                    child: const FaIcon(
                                        FontAwesomeIcons.facebook, size: 35,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
  Future signIn() async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) =>
        const Center(child: CircularProgressIndicator(),));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}