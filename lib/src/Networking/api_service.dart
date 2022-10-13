import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Constant/app_urls.dart';
import '../Model/user_api_data_model.dart';
import '../Widget/utility.dart';

class ApiService {
  static Future<UserApiDataModel?> getUserApiData(
      BuildContext context, int page) async {
    var result = await request(context, "${AppUrls.userApiDataUrl}?page=$page");
    if (result != null) {
      print(result);
      return UserApiDataModel.fromJson(result);
    } else {
      return null;
    }
  }

  static Future<dynamic> request(BuildContext? context, String url) async {
    try {
      log("Request url: " + url);
      var result = await http.get(Uri.parse(url));
      if (result.statusCode == 200 && result.body.isNotEmpty) {
        return jsonDecode(result.body);
      } else {
        if (result.statusCode == 404 || result.statusCode == 502) {
          Utility.showToast(context!, "Authentication failed!");
        }
        return null;
      }
    } catch (e) {
      log("Error : " + e.toString());
      return null;
    }
  }
}
