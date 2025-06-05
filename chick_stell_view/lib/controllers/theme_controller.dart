
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController {
  final _box = GetStorage();
  var isDarkMode = false.obs;

  void toggleTheme(bool value){
    isDarkMode.value = !isDarkMode.value;
    if (isDarkMode.value) {
      Get.changeTheme(ThemeData.dark());
    } else {
      Get.changeTheme(ThemeData.light());
      
    }
  }
  
}