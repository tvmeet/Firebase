import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Constant/app_string.dart';
import '../Element/padding_class.dart';

class Utility {

  //Todo Custom TextField with error text
  static TextField customTextFieldWithError(
      IconData icon, String hintText, String errorText,TextEditingController controller) {
    return TextField(
        controller: controller,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            fillColor: Colors.white30,
            filled: true,
            errorText: errorText,
            hintText: hintText,
            hintStyle: const TextStyle(
                color: Colors.white60, fontWeight: FontWeight.normal),
            prefixIcon: Icon(
              icon,
              color: Colors.white,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            )));
  }

  //Todo Custom TextField
  static TextField  customTextField(bool isSecure,int inputLength,TextInputType keyboardType,
      IconData icon, String hintText,TextEditingController controller) {
    return TextField(
        controller: controller,
        keyboardType : keyboardType,
        textAlign: TextAlign.start,
        obscureText: isSecure,
        inputFormatters: [LengthLimitingTextInputFormatter(inputLength)],
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            fillColor: Colors.white30,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(
                color: Colors.white60, fontWeight: FontWeight.normal),
            prefixIcon: Icon(
              icon,
              color: Colors.white,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            )));
  }

  //Todo Custom Rounded Button
  static InkWell customButton(Size size, String text,Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.06,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 5)]),
        child: Text(
          text,
          style: const TextStyle(color: Colors.blue, fontSize: 20),
        ),
      ),
    );
  }

  //Todo Custom Rounded Image Button
  static Container customRoundedImageButton(
      double width,
      double height,
      double imgHeight,
      Color backgroundColor,
      double roundRadius,
      Color shadowColor,
      double shadowBlurRadius,
      String imgPath,
      Color? imgColor) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(roundRadius)),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withAlpha(30), blurRadius: shadowBlurRadius)
          ]),
      child: Image.asset(
        imgPath,
        height: imgHeight,
        color: imgColor,
      ),
    );
  }


  //Todo Floating Custom Loader with Text

 static void showLoader(bool isShow,BuildContext context, String loadingText) {
    final scaffold = ScaffoldMessenger.of(context);
    if(isShow) {
      scaffold.showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 500),
        backgroundColor: Colors.transparent.withOpacity(0),
        content: Center(
          child: Container(
            height: 100,
            width: 100,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                const CircularProgressIndicator(
                  strokeWidth: 5,
                ),
                paddingTop(20),
                Text(
                  loadingText,
                  style: const TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        )));
    }else{
      scaffold.removeCurrentSnackBar();
    }
  }
  static void hideLoader(BuildContext context){
    showLoader(false, context, "");
  }
  //Todo Custom Snackbar with OK button
  static void showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
            label: CommonStrings.toastOkLabel,
            onPressed: scaffold.removeCurrentSnackBar),
      ),
    );
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
