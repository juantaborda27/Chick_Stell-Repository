

import 'package:chick_stell_view/views/login/home_page.dart';
import 'package:chick_stell_view/views/login/login.dart';
import 'package:chick_stell_view/views/login/singup.dart';
import 'package:chick_stell_view/views/main_views/ajustes/ajustes_view.dart';
import 'package:chick_stell_view/views/main_views/clima/clima_view.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/create_galpon/create_galpon.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/monitoreo_view.dart';
import 'package:chick_stell_view/views/main_views/prediccion/prediccion_view.dart';
import 'package:chick_stell_view/views/widgets/botton_nav_var.dart';
import 'package:get/get.dart';

class AppRoutes{
  static final routes = [
    GetPage(
      name: '/',
      page: () => const HomePage(),
    ),
    GetPage(
      name: '/login',
      page: () => LoginPage(),
    ),
    GetPage(
      name: '/signup',
      page: () => SingUp(),
    ),
    GetPage(
      name: '/monitoreo',
      page: () => MonitoreoView(),
    ),
    GetPage(
      name: '/clima',
      page: () => ClimaView(),
    ),
    GetPage(
      name: '/prediccion',
      page: () => SimulacionView(),
    ),
    GetPage(
      name: '/ajustes',
      page: () => AjustesView(),
    ),
    GetPage(
      name: '/home_nav',
      page: () => BottonNavVar(),
    ),
    GetPage(
      name: '/create_galpon',
      page: () => CreateGalpon(),
    ),
  ];
}