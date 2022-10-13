import '../Constant/app_keys.dart';

class UserDataModel {
  String? fullName;
  String? email;
  String? number;
  String? deviceToken;
  String? loginType;
  String? deviceType;
  String? createdAt;

  UserDataModel(this.fullName, this.email, this.number, this.deviceToken,
      this.loginType, this.deviceType, this.createdAt);

  UserDataModel fromJson(Map<String, dynamic> json) {
    fullName = json[FirestoreFields.fullName];
    email = json[FirestoreFields.email];
    number = json[FirestoreFields.phone];
    deviceToken = json[FirestoreFields.deviceToken];
    deviceType = json[FirestoreFields.deviceType];
    createdAt = json[FirestoreFields.createdAt];
    loginType = json[FirestoreFields.loginType];
    return UserDataModel(
        fullName, email, number, deviceToken, loginType, deviceType, createdAt);
  }

  Map<String, dynamic> toJson(UserDataModel userDataModel) {
    Map<String, dynamic> json = <String, dynamic>{};
    json[FirestoreFields.fullName] = userDataModel.fullName;
    json[FirestoreFields.email] = userDataModel.email;
    json[FirestoreFields.loginType] = userDataModel.loginType;
    json[FirestoreFields.phone] = userDataModel.number;
    json[FirestoreFields.deviceToken] = userDataModel.deviceToken;
    json[FirestoreFields.deviceType] = userDataModel.deviceType;
    json[FirestoreFields.createdAt] = userDataModel.createdAt;
    return json;
  }
}
