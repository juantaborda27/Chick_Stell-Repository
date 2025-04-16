import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class WarehouseController extends GetxController {
  RxInt selectedWarehouse = 1.obs;
  RxBool ventilationActive = true.obs;
  RxDouble temperature = 32.5.obs;
  RxDouble humidity = 65.0.obs;
  RxInt co2Level = 850.obs;
  RxString birdActivity = "Normal".obs;
  RxBool hasWarning = true.obs;
  var warehouseCount = 3.obs;


  
  void toggleVentilation() {
    ventilationActive.value = !ventilationActive.value;
  }
  
  void selectWarehouse(int number) {
    selectedWarehouse.value = number;
  }

  void addWarehouse() {
    warehouseCount.value += 1;
  }

}