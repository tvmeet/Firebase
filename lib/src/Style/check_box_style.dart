import 'package:flutter/material.dart';

class CheckBoxStyle{
  static Theme customCheckBox(Color unselectedColor,Color tileColor,Color checkColor,Color activeColor,String text,Color textColor,bool isChecked,Function(bool?)? onChange){
   return Theme(
      data: ThemeData(unselectedWidgetColor: unselectedColor),
      child: CheckboxListTile(
        checkColor: checkColor,
        tileColor: tileColor,
        activeColor: activeColor,
        title:  Text(
          text,
          style: TextStyle(color: textColor),
        ),
        value: isChecked,
        onChanged: onChange,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}