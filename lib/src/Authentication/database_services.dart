import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod{
  Future addUserInfoToDB(String userId, Map <String, dynamic> userInfoMap){
    return FirebaseFirestore.instance.collection('user').doc(userId).set(userInfoMap);
  }
}