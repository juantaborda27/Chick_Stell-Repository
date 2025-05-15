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
    // Validaciones básicas (simplificadas)
    if (!email.isEmail) throw Exception('Ingresa un email válido');
    if (password.length < 6) throw Exception('La contraseña debe tener al menos 6 caracteres');
    if (password != confirmPassword) throw Exception('Las contraseñas no coinciden');

    User? newUser = await _authService.registerEmail(email, password, confirmPassword);
    
    if (newUser == null) throw Exception('El usuario ya existe');

    user.value = newUser;
    await saveUserStorage(email, password); 
    
    Get.snackbar('Éxito', 'Usuario registrado correctamente');
    Get.offAllNamed('/home_nav'); 
    
  } on FirebaseAuthException catch (e) {
    String errorMessage = e.code == 'email-already-in-use' 
        ? 'El email ya está registrado' 
        : 'Error de Firebase: ${e.message}';
    throw Exception(errorMessage);
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  } finally {
    isloading.value = false;
  }
}

  Future<void> login(String email, String password) async {
  isloading.value = true;
  
  try {
    // Validaciones básicas
    if (!email.isEmail) throw Exception('Ingresa un email válido');
    if (password.isEmpty) throw Exception('Ingresa tu contraseña');

    User? newUser = await _authService.loginEmail(email, password);
    
    if (newUser == null) throw Exception('Credenciales incorrectas');
    
    user.value = newUser;
    await saveUserStorage(email, password);
    
    
    Get.snackbar('Éxito', 'Sesión iniciada correctamente');
    
  } on FirebaseAuthException catch (e) {
    String errorMessage = 'Error durante el inicio de sesión';
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      errorMessage = 'Email o contraseña incorrectos';
    } else if (e.code == 'too-many-requests') {
      errorMessage = 'Demasiados intentos. Intenta más tarde';
    }
    throw Exception(errorMessage);
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
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