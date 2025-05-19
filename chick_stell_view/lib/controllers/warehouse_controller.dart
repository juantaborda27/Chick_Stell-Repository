import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:chick_stell_view/services/galpon_service.dart';

class WarehouseController extends GetxController {
  final GalponService _galponService = GalponService();

  var galpones = <Galpon>[].obs;
  RxInt selectedWarehouse = 0.obs; // Cambiado a índice (posición en la lista)

  // Variables de monitoreo (pueden mantenerse como están)
  RxBool ventilationActive = false.obs;
  RxInt co2Level = 850.obs;
  RxString birdActivity = "Normal".obs;
  RxBool hasWarning = true.obs;


  @override
  void onInit() {
    super.onInit();
    cargarGalpones();
  }

  Future<void> cargarGalpones() async {
    galpones.value = (await _galponService.getGalpones()).cast<Galpon>();
    // galpones.sort();
    galpones.sort((a, b) => a.id.compareTo(b.id));
    galpones.refresh(); // Actualizar la lista
  }

  // void selectWarehouse(int index) {
  //   if (index >= 0 && index < galpones.length) {
  //     selectedWarehouse.value = index;
  //   } else {
  //     print('Índice inválido: $index. La lista tiene ${galpones.length} elementos');
  //   }
  // }

  // void toggleVentilation() {
  //   ventilationActive.value = !ventilationActive.value;
  // }

  // En tu WarehouseController
void toggleVentilation() {
    ventilationActive.value = !ventilationActive.value;
    update(); // Asegúrate de notificar a los listeners
    print('Ventilación: ${ventilationActive.value}'); // Para depuración
  }

  void addWarehouse(Galpon galpon) async {
    await _galponService
        .addGalponConId(galpon); // usa el método que guarda con ID
    cargarGalpones(); // Recarga la lista
    selectedWarehouse.value = galpones.length - 1; // Selecciona el nuevo
  }



  //METODOS PARA BUSCAR EL GALPON SELECCIONADO
  var searchQuery = ''.obs;

  // Computed list para los galpones filtrados
  List<Galpon> get galponesFiltrados {
    if (searchQuery.value.isEmpty) {
      return galpones;
    } else {
      return galpones
          .where((g) => g.nombre.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    if (galponesFiltrados.isNotEmpty) {
      selectedWarehouse.value = galpones.indexOf(galponesFiltrados[0]);
    }
  }

  Galpon? get galponSeleccionado {
    if (galpones.isEmpty || selectedWarehouse.value >= galpones.length)
      return null;
    return galpones[selectedWarehouse.value];
  }



  int get warehouseCount => galpones.length;



  final Rx<AlertData?> alertaActiva = Rx<AlertData?>(null);

  void activarAlerta(String title, String message) {
    // Cancela cualquier alerta pendiente
    limpiarAlerta();

    alertaActiva.value = AlertData(title: title, message: message);

    // Programa la limpieza automática
    Future.delayed(const Duration(seconds: 15), () {
      if (alertaActiva.value != null) {
        limpiarAlerta();
      }
    });
  }

  void limpiarAlerta() {
    alertaActiva.value = null;
  }


  





  Rx<Galpon?> get galponSeleccionadoObs => Rx<Galpon?>(galponSeleccionado);

// Y actualizarlo cuando cambie la selección
void selectWarehouse(int index) {
  if (index >= 0 && index < galpones.length) {
    selectedWarehouse.value = index;
    galpones.refresh(); // Esto activará los listeners
  }
}





}

class AlertData {
  final String title;
  final String message;

  AlertData({required this.title, required this.message});
}
