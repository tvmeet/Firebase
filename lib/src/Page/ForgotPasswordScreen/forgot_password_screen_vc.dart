import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constant/app_input.dart';
import '../../Constant/app_string.dart';
import '../../Element/padding_class.dart';
import '../../Style/text_style.dart';
import '../../Utils/Notifier/forgot_password_notifier.dart';
import '../../Widget/utility.dart';

ForgotPasswordScreen() => ChangeNotifierProvider<ForgotPasswordNotifier>(create: (_) => ForgotPasswordNotifier(), child: ForgotPasswordScreenProvider(),);

class ForgotPasswordScreenProvider extends StatefulWidget {
  const ForgotPasswordScreenProvider({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreenProvider> createState() => _ForgotPasswordScreenProviderState();
}

class _ForgotPasswordScreenProviderState extends State<ForgotPasswordScreenProvider> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<ForgotPasswordNotifier>(
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
                    physics: const NeverScrollableScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: size.height * 0.08, horizontal: size.width * 0.1),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Center(
                              child: TextStyleTheme.customText(
                                  ForgotPasswordStrings.forgotPasswordLabel,
                                  20,
                                  Colors.white,
                                  FontWeight.bold)),
                          paddingTop(30),
                          Align(
                            alignment: Alignment.topLeft,
                            child: TextStyleTheme.customText(ForgotPasswordStrings.emailLabel,
                                14, Colors.white, FontWeight.normal),
                          ),
                          paddingTop(2),
                          Utility.customTextField(
                              false,
                              InputConfig.emailLength,
                              TextInputType.emailAddress,
                              Icons.email,
                              ForgotPasswordStrings.enterEmailHint,
                              emailController),
                          paddingTop(20),
                          Utility.customButton(size, ForgotPasswordStrings.sendLink, () {
                           state.forgotPassword(context);
                          }),
                        ],
                      ),
                    ),
                  )),
            ),
          );
        }
    );
  }
}
