import 'package:flutter/material.dart';

var _var;
// 언더바를 쓰면 다른 파일로 전송되지 않음

var theme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.grey,
    )
  ),
    iconTheme: IconThemeData(color:Colors.grey),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      actionsIconTheme: IconThemeData(color: Colors.black,),
    ),
    textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.black, fontSize: 13,)
    ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black,
  )
);