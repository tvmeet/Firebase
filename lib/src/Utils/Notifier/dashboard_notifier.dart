import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Model/user_api_data_model.dart';
import '../../Networking/api_service.dart';
import '../../Page/DashboardScreen/home_page.dart';
import '../../Page/DashboardScreen/video_page.dart';

class DashboardNotifier extends ChangeNotifier {
  var drawerItems = ["Home", "Videos", "Images", "About us", "Logout"];
  var drawerItemsIcons = [
    Icons.home,
    Icons.videocam,
    Icons.image,
    Icons.account_circle,
    Icons.logout
  ];

  bool? isFirstLoad = false;
  bool? isApiLoad = false;
  bool? isNeedToLoadMore = true;
  int page = 0;
  List<Data>? data = [];

  void getUserApiData(BuildContext context) async {
    if (page == 0) {
      isFirstLoad = true;
    } else {
      isApiLoad = true;
    }
    notifyListeners();
    page += 1;
    if (isNeedToLoadMore == false) {
      //This will prevent more api calls if data will getting empty
      isApiLoad = isFirstLoad = false;
      Future.delayed(const Duration(milliseconds: 500), () {
        print("no more data");
        notifyListeners();
      });
      return;
    }
    var res = await ApiService.getUserApiData(context, page);
    if (res!.data!.isEmpty) {
      isNeedToLoadMore = false;
      isApiLoad = isFirstLoad = false;
    } else {
      isApiLoad = isFirstLoad = false;
      data!.addAll(res.data!);
      print(data![0].firstName);
    }
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  Widget? getSelectedPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const VideoPage();
      case 2:
        return Center(child: Text(drawerItems[index]));
      case 3:
        return Center(child: Text(drawerItems[index]));
      case 4:
        return Center(child: Text(drawerItems[index]));
    }
  }
}
