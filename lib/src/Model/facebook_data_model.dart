

import '../Constant/app_keys.dart';

class FacebookDataModel{
  String? fullName;
  String? firstName;
  String? lastName;
  String? profileUrl;
  String? email;
  String? phone;
  FacebookDataModel(this.fullName, this.firstName, this.lastName,
      this.profileUrl, this.email, this.phone);

  FacebookDataModel fromJson(Map<String,dynamic> json){
    fullName = json[FacebookDataFields.fieldFullName];
    firstName = json[FacebookDataFields.fieldFirstName];
    lastName = json[FacebookDataFields.fieldLastName];
    profileUrl = json[FacebookDataFields.fieldProfileUrl];
    email = json[FacebookDataFields.fieldEmail];
    phone = json[FacebookDataFields.fieldPhone];
    return FacebookDataModel(fullName, firstName, lastName, profileUrl, email, phone);
  }
  Map<String,dynamic> toJson(FacebookDataModel facebookDataModel){
    Map<String,dynamic> json = <String,dynamic>{};
    json[FacebookDataFields.fieldFullName] = facebookDataModel.fullName;
    json[FacebookDataFields.fieldFirstName] = facebookDataModel.firstName;
    json[FacebookDataFields.fieldLastName] = facebookDataModel.lastName;
    json[FacebookDataFields.fieldProfileUrl] = facebookDataModel.profileUrl;
    json[FacebookDataFields.fieldEmail] = facebookDataModel.email;
    json[FacebookDataFields.fieldPhone] = facebookDataModel.phone;
    return json;
  }
}
