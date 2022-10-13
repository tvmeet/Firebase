import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constant/app_image.dart';
import '../../Constant/app_input.dart';
import '../../Constant/app_string.dart';
import '../../Element/padding_class.dart';
import '../../Style/check_box_style.dart';
import '../../Style/text_style.dart';
import '../../Utils/Notifier/login_notifier.dart';
import '../../Widget/utility.dart';
import '../ForgotPasswordScreen/forgot_password_screen_vc.dart';
import '../SignupScreen/signup_page.dart';

LoginScreen() => ChangeNotifierProvider<LoginNotifier>(create: (_) => LoginNotifier(),child: LoginScreenProvider(),);

class LoginScreenProvider extends StatefulWidget {
  const LoginScreenProvider({Key? key}) : super(key: key);

  @override
  LoginScreenProviderState createState() =>LoginScreenProviderState();
}

TextEditingController nameTextEditingController = TextEditingController();

class LoginScreenProviderState extends State<LoginScreenProvider> {
  bool isRemember = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<LoginNotifier>(
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
                                LoginStrings.signInLabel,
                                20,
                                Colors.white,
                                FontWeight.bold)),
                        paddingTop(30),
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextStyleTheme.customText(LoginStrings.emailLabel,
                              14, Colors.white, FontWeight.normal),
                        ),
                        paddingTop(2),
                        Utility.customTextField(
                            false,
                            InputConfig.emailLength,
                            TextInputType.emailAddress,
                            Icons.email,
                            LoginStrings.enterEmailHint,
                            emailController),
                        paddingTop(20),
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextStyleTheme.customText(
                              LoginStrings.passwordLabel,
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
                            LoginStrings.enterPasswordHint,
                            passwordController),
                        paddingTop(10),
                        Container(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen()));
                            },
                            child: TextStyleTheme.customText(
                                LoginStrings.forgotPasswordLabel,
                                14,
                                Colors.white,
                                FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: CheckBoxStyle.customCheckBox(
                              Colors.white,
                              Colors.white,
                              Colors.lightBlue,
                              Colors.white,
                              LoginStrings.rememberMeCheck,
                              Colors.white,
                              isRemember, (value) {
                            setState(() {
                              isRemember = value!;
                            });
                          }),
                        ),
                        paddingTop(20),
                        Utility.customButton(size, LoginStrings.loginLabel, () {
                          state.loginWithExistData(context);
                        }),
                        paddingTop(20),
                        TextStyleTheme.customText(LoginStrings.orLabel, 14,
                            Colors.white, FontWeight.w300),
                        paddingTop(20),
                        TextStyleTheme.customText(LoginStrings.signInWithLabel, 14,
                            Colors.white, FontWeight.w300),
                        paddingTop(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                state.signInWithFacebook(context);
                              },
                              child: Utility.customRoundedImageButton(
                                  60,
                                  60,
                                  40,
                                  Colors.white,
                                  40,
                                  Colors.black,
                                  5,
                                  AppImages.fbIcon,
                                  Colors.blue),
                            ),
                            paddingRight(20),
                            InkWell(
                              onTap: () {
                                state.signInwithGoogle(context);
                              },
                              child: Utility.customRoundedImageButton(
                                  60,
                                  60,
                                  40,
                                  Colors.white,
                                  40,
                                  Colors.black,
                                  5,
                                  AppImages.googleIcon,
                                  null),
                            ),
                          ],
                        ),
                        paddingTop(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextStyleTheme.customText(
                                LoginStrings.dontHaveAccountLabel,
                                14,
                                Colors.white,
                                FontWeight.w300),
                            paddingRight(10),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()));
                              },
                              child: TextStyleTheme.customText(
                                  LoginStrings.signUpLabel,
                                  14,
                                  Colors.white,
                                  FontWeight.bold),
                            ),
                          ],
                        )
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
