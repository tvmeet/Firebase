
import 'package:flutter/material.dart';
import 'package:flutter_firebase/src/Page/DashboardScreen/profile_item.dart';
import 'package:provider/provider.dart';

import '../../Utils/Notifier/dashboard_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardNotifier>(context, listen: false).getUserApiData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardNotifier>(
      builder: (context, state, child) => state.isFirstLoad == false
          ? NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (state.isApiLoad == false &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  state.getUserApiData(context);
                }
                return false;
              },
              child: ListView.builder(
                itemCount: state.isApiLoad == true
                    ? state.data!.length + 1
                    : state.data!.length,
                itemBuilder: (context, int index) {
                  //print('ListView.builder is building index $index && ${state.data!.length}');
                  if (state.isApiLoad == true && index >= state.data!.length) {
                    return const Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                        height: 34,
                        width: 34,
                      ),
                    );
                  }
                  return ProfileItem(
                      state.data![index].firstName,
                      state.data![index].lastName,
                      state.data![index].email,
                      state.data![index].avatar);
                },
              ),
            )
          : const Center(
              child: SizedBox(
              child: CircularProgressIndicator(),
              height: 30,
              width: 30,
            )),
    );
  }
}
