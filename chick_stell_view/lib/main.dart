// import 'package:chick_stell_view/views/login/home_page.dart';
import 'package:chick_stell_view/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chick Stell',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
      ),
      initialRoute: '/login',
      getPages: AppRoutes.routes,
      home: BottomAppBar(),
      // home: HomePage(),
    );
  }
}

