import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:chick_stell_view/models/galpon_model.dart';
import 'package:chick_stell_view/services/galpon_service.dart';

class WarehouseController extends GetxController {
  final GalponService _galponService = GalponService();

  var galpones = <Galpon>[].obs;
  RxInt selectedWarehouse = 0.obs; // Cambiado a índice (posición en la lista)

  // Variables de monitoreo (pueden mantenerse como están)
  RxBool ventilationActive = true.obs;
  RxDouble temperature = 32.5.obs;
  RxDouble humidity = 65.0.obs;
  RxInt co2Level = 850.obs;
  RxString birdActivity = "Normal".obs;
  RxBool hasWarning = true.obs;

  @override
  void onInit() {
    super.onInit();
    cargarGalpones();
  }

  void cargarGalpones() async {
    galpones.value = (await _galponService.getGalpones()).cast<Galpon>();
    galpones.sort();
    galpones.refresh(); // Actualizar la lista
  }

  void selectWarehouse(int index) {
    selectedWarehouse.value = index;
  }

  void toggleVentilation() {
    ventilationActive.value = !ventilationActive.value;
  }

  void addWarehouse(Galpon galpon) async {
    await _galponService
        .addGalponConId(galpon); // usa el método que guarda con ID
    cargarGalpones(); // Recarga la lista
    selectedWarehouse.value = galpones.length - 1; // Selecciona el nuevo
  }

  int get warehouseCount => galpones.length;
}
