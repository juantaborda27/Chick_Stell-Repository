// import 'package:chick_stell_view/views/login/home_page.dart';
import 'package:chick_stell_view/controllers/galpon_controller.dart';
import 'package:chick_stell_view/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//importaciones de firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(GalponController()); // <- Inyectas el controlador
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chick Stell',
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      initialRoute: '/login',
      getPages: AppRoutes.routes,
      home: BottomAppBar(),
      // home: HomePage(),
    );
  }
}
