
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/src/Page/SignIn/auth_page.dart';
import 'package:flutter_firebase/src/Page/Home/home_screen.dart';



class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }else if(snapshot.hasError){
            return const Center(child: Text('Something went wrong!'));
        }else if(snapshot.hasData) {
          return const HomeScreen();
        }else{
          return const AuthPage();
        }
      },
    ),
  );
}
