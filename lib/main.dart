
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'src/Constant/app_config.dart';
import 'src/Page/LoginScreen/login_screen_vc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    /*Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });*/
  }

  Future initLibraries() async {
    await Firebase.initializeApp();
    if (kIsWeb) {
      // initialiaze the facebook javascript SDK
      FacebookAuth.instance.webInitialize(
        appId: AppConfigs.facebookAppId,
        cookie: true,
        xfbml: true,
        version: "v11.0",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initLibraries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LoginScreen(),
            //DashboardPage("https://lh3.googleusercontent.com/a-/AOh14GgJrQgB1YQnwtFTDBDA27hWUUoUzR76O44bLTHy=s192-c", "Tushar Patel", "tc@gmail.com", "901222222"),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return const Text("No data");
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
