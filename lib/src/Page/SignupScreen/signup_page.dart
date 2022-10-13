
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constant/app_input.dart';
import '../../Constant/app_string.dart';
import '../../Element/padding_class.dart';
import '../../Style/text_style.dart';
import '../../Utils/Notifier/signup_notifier.dart';
import '../../Widget/utility.dart';

SignupScreen() => ChangeNotifierProvider(create: (_) => SignupNotifier(),child: SignupScreenProvider(),);

class SignupScreenProvider extends StatefulWidget {
  const SignupScreenProvider({Key? key}) : super(key: key);

  @override
  SignupScreenProviderState createState() => SignupScreenProviderState();
}

class SignupScreenProviderState extends State<SignupScreenProvider> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<SignupNotifier>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.lightBlueAccent])),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: size.height * 0.08, horizontal: size.width * 0.1),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Center(
                          child: TextStyleTheme.customText(
                              SignupStrings.signupLabel,
                              20,
                              Colors.white,
                              FontWeight.bold)),
                      paddingTop(20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextStyleTheme.customText(
                            SignupStrings.fullNameLabel,
                            14,
                            Colors.white,
                            FontWeight.normal),
                      ),
                      paddingTop(2),
                      Utility.customTextField(
                          false,
                          InputConfig.fullNameLength,
                          TextInputType.name,
                          Icons.person,
                          SignupStrings.enterfullNameHint,
                          fullNameController),
                      paddingTop(20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextStyleTheme.customText(SignupStrings.phoneLabel,
                            14, Colors.white, FontWeight.normal),
                      ),
                      paddingTop(2),
                      Utility.customTextField(
                          false,
                          InputConfig.phoneLength,
                          TextInputType.number,
                          Icons.phone,
                          SignupStrings.enterPhoneHint,
                          phoneController),
                      paddingTop(20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextStyleTheme.customText(SignupStrings.emailLabel,
                            14, Colors.white, FontWeight.normal),
                      ),
                      paddingTop(2),
                      Utility.customTextField(
                          false,
                          InputConfig.emailLength,
                          TextInputType.emailAddress,
                          Icons.email,
                          SignupStrings.enterEmailHint,
                          emailController),
                      paddingTop(20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextStyleTheme.customText(
                            SignupStrings.passwordLabel,
                            14,
                            Colors.white,
                            FontWeight.normal),
                      ),
                      paddingTop(2),
                      Utility.customTextField(
                          true,
                          InputConfig.passwordLength,
                          TextInputType.visiblePassword,
                          Icons.vpn_key,
                          SignupStrings.enterPasswordHint,
                          passwordController),
                      paddingTop(20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextStyleTheme.customText(
                            SignupStrings.confirmPassLabel,
                            14,
                            Colors.white,
                            FontWeight.normal),
                      ),
                      paddingTop(2),
                      Utility.customTextField(
                          true,
                          InputConfig.passwordLength,
                          TextInputType.visiblePassword,
                          Icons.vpn_key,
                          SignupStrings.enterConfirmPassHint,
                          confirmPassController),
                      paddingTop(40),
                      Utility.customButton(size, SignupStrings.registerLabel, () {
                        state.addData(context);
                      }),
                      paddingTop(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextStyleTheme.customText(
                              SignupStrings.haveAnAccountLabel,
                              14,
                              Colors.white,
                              FontWeight.w300),
                          paddingRight(10),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: TextStyleTheme.customText(
                                SignupStrings.signInLabel,
                                14,
                                Colors.white,
                                FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
