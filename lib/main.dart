import 'package:flutter/material.dart';
import 'package:genius_clean_arch/constants/constantColors.dart';
import 'package:genius_clean_arch/dashboard_screen.dart';
import 'package:genius_clean_arch/modules/ranking/presenter/albuns_tab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: PRIMARY_SWATCH,
          scaffoldBackgroundColor: BACKGROUND_COLOR,
          textTheme: TextTheme(bodyText2: TextStyle(color: FONT_COLOR))),
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
