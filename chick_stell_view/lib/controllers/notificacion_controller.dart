

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';

class NotificacionController extends GetxController {

  final _box = GetStorage();
  var notificacionesActivas = true.obs;
  
  get value => null;
  
  @override
  void onInit() {
    notificacionesActivas.value = _box.read('notificacionesActivas') ?? true;
    super.onInit();
  }

  void toggleNotificaciones() {
    notificacionesActivas.value;
    _box.write('notificaconesActivas',value);
  }
}

