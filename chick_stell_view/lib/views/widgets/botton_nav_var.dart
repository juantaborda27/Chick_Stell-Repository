

import 'package:chick_stell_view/views/main_views/ajustes/ajustes_view.dart';
import 'package:chick_stell_view/views/main_views/clima/clima_view.dart';
import 'package:chick_stell_view/views/main_views/monitoreo/monitoreo_view.dart';
import 'package:chick_stell_view/views/main_views/prediccion/prediccion_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BottonNavVar extends StatelessWidget {

  final NavigationController controller = Get.put(NavigationController());

  BottonNavVar({super.key});
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: '',
        onGenerateRoute: (settings) {
          return GetPageRoute(
            settings: settings,
            page: () {
              switch (settings.name) {
                case '/clima':
                  return ClimaView();
                case '/prediccion':
                  return PrediccionView();
                case '/ajustes':
                  return AjustesView();
                case '/monitoreo':
                default:
                  return MonitoreoView();
              }
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF26A69A),
            unselectedItemColor: Colors.grey,
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changePage,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Monitoreo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud),
                label: 'Clima',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Predicción',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Ajustes',
              ),
            ],
          ),
        ),
      ),
    );
  }  
}



class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<String> routeNames = [
    '/monitoreo',
    '/clima',
    '/prediccion',
    '/ajustes',
  ];

  void changePage(int index) {
    selectedIndex.value = index;
    Get.offNamed(routeNames[index], id: 1); // id:1 para navegación anidada
  }
}