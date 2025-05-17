import 'package:chick_stell_view/controllers/auth_controller.dart';
import 'package:chick_stell_view/controllers/galpon_controller.dart';
import 'package:chick_stell_view/controllers/alerta_controller.dart';
import 'package:chick_stell_view/controllers/notificacion_controller.dart';
import 'package:chick_stell_view/controllers/simulacion_controller.dart';
import 'package:chick_stell_view/services/galpon_service.dart';
import 'package:chick_stell_view/services/local_image_service.dart';
import 'package:chick_stell_view/services/notification_service.dart';
import 'package:chick_stell_view/utils/routes.dart';
import 'package:chick_stell_view/views/widgets/botton_nav_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//importaciones de firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  //Get.find<GalponController>();
  Get.put(AlertaController());
  Get.put(GalponService());
  Get.put(GalponController()); // <- Inyectas el
  Get.put(AuthController()); 
  Get.put(NotificacionController());

  final localImageService = LocalImageService();
  Get.put(localImageService);

  await GetStorage.init();
  
  // Inicializar Hive
  await Hive.initFlutter();
  await Hive.openBox('profile_images');
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
      initialRoute: '/login',
      getPages: AppRoutes.routes,
      home: BottonNavVar(),
      // home: HomePage(),
    );
  }
}
