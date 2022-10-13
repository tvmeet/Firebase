import 'package:flutter/material.dart';

import '../../Element/padding_class.dart';
import '../../Style/text_style.dart';

class ProfileItem extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileUrl;

  const ProfileItem(this.firstName, this.lastName, this.email, this.profileUrl,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(5),
        height: size.height * 0.17 + 45,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(5, 5),
                        blurRadius: 20)
                  ]),
              child: Container(
                height: size.height * 0.17,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextStyleTheme.customText("$firstName $lastName", 20,
                              Colors.black, FontWeight.bold),
                          paddingTop(20),
                          TextStyleTheme.customText(
                              "$email", 18, Colors.black, FontWeight.w500)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.17 - 45,
              left: 45,
              child: Container(
                alignment: Alignment.centerLeft,
                height: 90.0,
                width: 90.0,
                decoration: profileUrl!.isNotEmpty
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(5, 7),
                              blurRadius: 10)
                        ],
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            profileUrl!,
                          ),
                        ),
                      )
                    : null,
                child: profileUrl!.isEmpty
                    ? const Icon(Icons.person, size: 20.0)
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
