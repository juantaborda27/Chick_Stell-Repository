import 'package:chick_stell_view/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController {

  final AuthService _authService = AuthService();
  var isloading = false.obs;
  Rxn<User> user = Rxn<User>();

final storage = GetStorage();

  Future<void> register(String email, String password, String confirmPassword) async {
    isloading.value = true;
    try {
      isloading.value = true;
      User? newUser = await _authService.registerEmail(
      email,
      password,
      confirmPassword
      );

       if(newUser != null){
        user.value = newUser;
        await saveUserStorage(email, password);
        
       } else {
        Get.snackbar('Error', 'Error al registrarse');
       } 
      } catch (e) {

        Get.snackbar('Error', 'Error durante el registro: $e');
    }
  }

  Future<void> login(String email, String password) async {
    isloading.value = true;
    try {
      User? newUser = await _authService.loginEmail(
        email,
        password
        );
          if (newUser != null) {
            user.value = newUser;
            await saveUserStorage(email, password);
          
          } else {
            Get.snackbar('Error', 'Error al iniciar sesion');
          }
        } catch (e) {
            Get.snackbar('Error', 'Error durante el inicio de sesion');
        } finally {
            isloading.value = false;
    }
  }


  Future<void> saveUserStorage(String email, String password) async {
  await storage.write('email', email);
  await storage.write('password', password);

  }



  // Inicio con Google
  Future<void> loginWithGoogle() async {
    isloading.value = true;
    try {
      User? newUser = await _authService.signInWithGoogle();
      if (newUser != null) {
        user.value = newUser;
        await saveUserStorage(newUser.email ?? '', '');
        Get.offAllNamed('/');
      } else {
        Get.snackbar('Erorr', 'No se pudo iniciar sesion con Google');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error al iniciar sesion con Google: $e');
    } finally {
      isloading.value = false;
      
    }
  }

}