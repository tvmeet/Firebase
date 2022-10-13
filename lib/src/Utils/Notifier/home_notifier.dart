import 'package:flutter/material.dart';

class HomeNotifier extends ChangeNotifier{
  String? dummyInitText;
  bool? isLoading;

  initialiseHomeScreen()async{
    isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 800));
    dummyInitText = 'Test';
    isLoading = false;
    notifyListeners();
  }
}