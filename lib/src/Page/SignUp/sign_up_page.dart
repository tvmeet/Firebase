import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/main.dart';
import 'package:flutter_firebase/src/Utils/Validation/validation.dart';
import 'package:flutter_firebase/src/Widget/password_text_box.dart';
import 'package:image_picker/image_picker.dart';
import '../../Authentication/authentication_services.dart';
import '../../Constant/app_string.dart';
import '../../Widget/button_widget.dart';
import '../../Widget/header_widget.dart';
import '../../Widget/textbox_widget.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

import '../Home/home_screen.dart';

class SignUpPage extends StatefulWidget {
final Function() onClicKedSignIn;
  const SignUpPage({Key? key, required this.onClicKedSignIn}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  double headerHeight = 250;
  String username = "";
  String password = "";
  String email = "";

  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future ImagePic() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  Future<String> getDownload() async{
    File uploadFile = File(_photo!.path);
    return firebase_storage.FirebaseStorage
        .instance.ref('uploads/${uploadFile.path}')
        .getDownloadURL();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: headerHeight,
                child: HeaderWidget(headerHeight, true, Icons.person)
            ),
            SafeArea(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: [
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ImagePic();
                                },
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: const Color(0xffFDCF09),
                                  child: _photo != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      _photo!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                      : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              customTextField(lableText: AppString.username, hintText: AppString.userhint, controller: userController, validator:(value)=>validateName(value), onSave: (value){
                                if(value.isNotEmpty){
                                  username = value;
                                }
                              },),
                              const SizedBox(height: 15),
                              customTextField(lableText: AppString.email, hintText: AppString.emailhint,  controller: emailController, validator: (value)=>validateEmail(value),
                                  onSave: (value){
                                    if(value.isNotEmpty){
                                      email = value;
                                    }
                                  }
                              ),
                              const SizedBox(height: 15),
                              ///customTextField(lableText: AppString.password, obscureText: true, hintText: AppString.passhitnt, controller: passwordController, validator: (value){validatePassword(value);return null;},),
                              PasswordField(labelText: AppString.password,
                                controller: passwordController,
                                hintText: AppString.passhitnt,
                                validator: (value) => validatePassword(value),
                                  onSaved: (value){
                                    if(value!.isEmpty){
                                      password = value;
                                    }
                                  }
                              ),
                              const SizedBox(height: 15),
                              ButtonWidgets(onTap: () async  {
                                if(_formKey.currentState?.validate()==true){
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await uploadFile().then((value) async{});
                                  String value = await getDownload();
                                  try{
                                    await Authentication().createUserWithEmailPassword(email, password, value !=null ? value : '', username).then((value){
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                                    });
                                  }on FirebaseException catch(e){
                                    print(e);
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              }, buttonText: 'register'),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10,20,10,20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(
                                    TextSpan(
                                        children: [
                                          const TextSpan(text: "Already have an account "),
                                          TextSpan(
                                            text: 'Login',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = widget.onClicKedSignIn,
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                                          ),
                                        ]
                                    )
                                ),
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
// Future signUp() async{
//     showDialog(context: context,
//         barrierDismissible: false,
//         builder: (context)=>const Center(child: CircularProgressIndicator(),));
//
//     try{
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );
//     } on FirebaseAuthException catch(e){
//       print(e);
//     }
//     navigatorKey.currentState!.popUntil((route) => route.isFirst);
//   }
}
