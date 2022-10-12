import 'package:firebase_auth/firebase_auth.dart';

import 'database_services.dart';

class Authentication{
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> getCurrentUser() async{
    return auth.currentUser!;
  }

  Future<void> createUserWithEmailPassword(
      String email, String password, String imageUrl, String username) async{
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

    Map<String, dynamic> userInfoMap = {
      'email' : email,
      'password' : password,
      'username' : username,
      'imgUrl' : imageUrl,
    };

    if(userCredential != null){
      DatabaseMethod().addUserInfoToDB(auth.currentUser!.uid, userInfoMap);
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async{
    UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async{
    await auth.signOut();

  }
}