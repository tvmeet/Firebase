import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constant/app_string.dart';
import '../../Element/padding_class.dart';
import '../../Style/text_style.dart';
import '../../Utils/Mixins/hide_scroll_glow.dart';
import '../../Utils/Notifier/dashboard_notifier.dart';
import '../../Utils/Notifier/login_notifier.dart';

DashboardScreen(profileUrl, fullName, email, phone) => ChangeNotifierProvider(create: (_) => DashboardNotifier(),child: DashboardScreenProvider(profileUrl, fullName, email, phone) ,);

class DashboardScreenProvider extends StatefulWidget {
  final String? profileUrl;
  final String? fullName;
  final String? email;
  final String? phone;
  int selectedDrawerItemPosition = 1;

  DashboardScreenProvider(this.profileUrl, this.fullName, this.email, this.phone,
      {Key? key})
      : super(key: key);

  @override
  State<DashboardScreenProvider> createState() => DashboardScreenProviderState();
}

class DashboardScreenProviderState extends State<DashboardScreenProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<DashboardNotifier>(
      builder: (context, state, child) {
        return SafeArea(
          child: Scaffold(
            drawer: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.black),
              child: buildDrawer(size, context, state),
            ),
            backgroundColor: Colors.white,
            appBar: buildAppBar(context),
            body: state.getSelectedPage(widget.selectedDrawerItemPosition)!,
          ),
        );
      }
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Container(
          alignment: Alignment.center,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Dashboard"),
            paddingRight(10),
            InkWell(
                onTap: () {
                  LoginNotifier().signOut(context);
                },
                child: const Icon(Icons.logout))
          ])),
    );
  }

  Drawer buildDrawer(Size size, BuildContext context,DashboardNotifier state) {
    return Drawer(
        child: Container(
      height: size.height,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Container(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: widget.profileUrl!.isNotEmpty
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      widget.profileUrl!,
                                    ),
                                  ),
                                )
                              : null,
                          child: widget.profileUrl!.isEmpty
                              ? const Icon(Icons.person, size: 200.0)
                              : const SizedBox(),
                        ),
                        paddingRight(5),
                        TextStyleTheme.customText("${widget.fullName}", 15,
                            Colors.white, FontWeight.normal),
                      ],
                    )
                  ],
                ),
              )),
          Container(
            color: Colors.blue,
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
              ),
              height: size.height - 193,
              child: ScrollConfiguration(
                behavior: HideScrollGlow(),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: size.height - 280,
                      height: 70,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withAlpha(60),
                                  blurRadius: 1)
                            ],
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(colors: [
                              Colors.transparent,
                              Colors.transparent
                            ])),
                        child: Center(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  state.drawerItemsIcons[
                                      state.drawerItemsIcons.length - 1],
                                  color: Colors.white,
                                ),
                                paddingRight(10),
                                TextStyleTheme.customText(
                                    state.drawerItems[
                                        state.drawerItems.length - 1],
                                    15,
                                    Colors.white,
                                    FontWeight.bold),
                              ],
                            ),
                            onTap: () {
                              LoginNotifier().signOut(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.62,
                      child: ListView.builder(
                          itemCount: state.drawerItems.length - 1,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  widget.selectedDrawerItemPosition = index;
                                });
                              },
                              child: Container(
                                height: 60,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.blue.withAlpha(80),
                                          blurRadius: 1)
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent
                                    ])),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      state.drawerItemsIcons[index],
                                      color: Colors.white,
                                    ),
                                    paddingRight(10),
                                    Center(
                                        child: TextStyleTheme.customText(
                                            state.drawerItems[index],
                                            15,
                                            Colors.white,
                                            FontWeight.bold)),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Container buildContainer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.blue),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 40),
          child: Column(
            children: [
              Container(
                height: 200.0,
                width: 200.0,
                decoration: widget.profileUrl!.isNotEmpty
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            widget.profileUrl!,
                          ),
                        ),
                      )
                    : null,
                child: widget.profileUrl!.isEmpty
                    ? const Icon(Icons.person, size: 200.0)
                    : const SizedBox(),
              ),
              paddingTop(20),
              Row(
                children: [
                  TextStyleTheme.customText(DashboardStrings.nameLabel, 15,
                      Colors.white, FontWeight.bold),
                  paddingRight(10),
                  TextStyleTheme.customText("${widget.fullName}", 15,
                      Colors.white, FontWeight.normal),
                ],
              ),
              paddingTop(20),
              Row(
                children: [
                  TextStyleTheme.customText(DashboardStrings.phoneLabel, 15,
                      Colors.white, FontWeight.bold),
                  paddingRight(10),
                  TextStyleTheme.customText(
                      "${widget.phone}", 15, Colors.white, FontWeight.normal),
                ],
              ),
              paddingTop(20),
              Row(
                children: [
                  TextStyleTheme.customText(DashboardStrings.emailLabel, 15,
                      Colors.white, FontWeight.bold),
                  paddingRight(10),
                  TextStyleTheme.customText(
                      "${widget.email}", 15, Colors.white, FontWeight.normal),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
