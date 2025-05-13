import 'package:chick_stell_view/controllers/galpon_controller.dart';
import 'package:chick_stell_view/controllers/simulacion_controller.dart';
import 'package:chick_stell_view/services/galpon_service.dart';
import 'package:chick_stell_view/services/notification_service.dart';
import 'package:chick_stell_view/utils/routes.dart';
import 'package:chick_stell_view/views/widgets/botton_nav_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//importaciones de firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Get.find<GalponController>();
  Get.put(GalponService());
  Get.put(GalponController()); // <- Inyectas el controlador

  // Inicializar Hive
  await Hive.initFlutter();
  //limpiar la base de datos
  await Hive.openBox("predicciones");
  Get.put(SimulacionController(), permanent: true);
  await NotificationService.initialize();
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
      initialRoute: '/',
      getPages: AppRoutes.routes,
      home: BottonNavVar(),
      // home: HomePage(),
    );
  }
}
