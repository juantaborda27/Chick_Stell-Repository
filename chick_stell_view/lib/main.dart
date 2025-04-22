// import 'package:chick_stell_view/views/login/home_page.dart';
import 'package:chick_stell_view/controllers/auth_controller.dart';
import 'package:chick_stell_view/controllers/galpon_controller.dart';
import 'package:chick_stell_view/services/galpon_service.dart';
import 'package:chick_stell_view/utils/routes.dart';
import 'package:chick_stell_view/views/widgets/botton_nav_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//importaciones de firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Get.find<GalponController>();
  Get.put(AuthController());
  Get.put(GalponService());
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
      home: BottonNavVar(),
      // home: HomePage(),
    );
  }
}
