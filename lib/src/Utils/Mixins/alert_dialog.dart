import 'package:flutter/material.dart';
import '../../Element/padding_class.dart';
import '../../Style/text_style.dart';

class CustomAlertDialog extends StatefulWidget {
  BuildContext context;
  String? title;
  String? content;
  List<Widget>? actions;

  CustomAlertDialog(
      {Key? key,
      required this.context,
      required this.title,
      required this.content,
      this.actions})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Wrap(children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue.shade300]),
          ),
          child: Column(
            children: [
              paddingTop(5),
              TextStyleTheme.customText(
                  widget.title!, 17, Colors.white, FontWeight.bold),
              paddingTop(10),
              Divider(height: 2,indent: 10,color: Colors.white,endIndent: 10,),
              paddingTop(30),
              TextStyleTheme.customText(
                  widget.content!, 15, Colors.white, FontWeight.normal),
              paddingTop(30),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.actions!,
                ),
              )
            ],
          ),
        ),
      ]),
      contentPadding: const EdgeInsets.all(0.0),
    );
  }
}
