class Validation{
  static bool validateEmail(String email){
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
  static bool validatePhoneNumber(String number){
    return RegExp(r"^[0-9]{10}$").hasMatch(number);
  }
}