import 'package:animate_do/animate_do.dart';
import 'package:chick_stell_view/controllers/auth_controller.dart';
import 'package:chick_stell_view/controllers/warehouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
   
      body: Container(
        height: screenSize.height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            // Header Section with Logo
            SizedBox(height: screenSize.height * 0.05),
            FadeInDown(
              duration: const Duration(milliseconds: 1000),
              child: Column(
                children: [
                  // Logo Image
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        // Reemplaza esto con tu logo real
                        child: Image.asset(
                          'assets/images/logo2.png',
                          height: 80,
                          width: 80,
                          fit: BoxFit.contain,
                        ),
                        // Si prefieres usar un icono como placeholder:
                        // child: Icon(
                        //   Icons.chat,
                        //   size: 60,
                        //   color: Colors.greenAccent,
                        // ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      shadows: [
                        const Shadow(
                          blurRadius: 1.0,
                          offset: Offset(1.0, 1.0),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1200),
                    child: Text(
                      'Ingresa a tu cuenta',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(flex: 1),
            
            // Form Section
            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: Column(
                children: [
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 10),
                  _buildForgotPassword(),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Login Button
            FadeInUp(
              duration: const Duration(milliseconds: 1400),
              child: _buildLoginButton(screenSize),
            ),

            const SizedBox(height: 10),

            FadeInUp(
              duration: const Duration(milliseconds: 1400),
              child: _buildGoogleLoginButton(screenSize),
            ),
            
            const SizedBox(height: 25),
            
            // Sign Up link
            FadeInUp(
              duration: const Duration(milliseconds: 1500),
              child: _buildSignUpLink(),
            ),
            
            const Spacer(flex: 2),
            SizedBox(height: screenSize.height * 0.05),
          ],
        ),
      ),
    );
  }

  // Widgets personalizados para cada elemento del formulario
  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Contraseña",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: FadeInRight(
        duration: const Duration(milliseconds: 1300),
        child: TextButton(
          onPressed: () => Get.toNamed('forgot_password'),
          child: Text(
            'Olvidaste tu contraseña?',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(Size screenSize) {
    return Container(
      width: screenSize.width * 0.7,
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
            color: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        height: 55,
        onPressed: _handleLogin,
        color: Colors.greenAccent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: Colors.greenAccent.shade700),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 10),
            FadeIn(
              delay: const Duration(milliseconds: 1600),
              child: const Icon(Icons.login, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  // Google
  Widget _buildGoogleLoginButton(Size screenSize) {
  final controller = Get.find<AuthController>();

  return Container(
    width: screenSize.width * 0.7,
    padding: const EdgeInsets.only(top: 3, bottom: 3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 3),
          color: Colors.grey.withOpacity(0.5),
        ),
      ],
    ),
    child: MaterialButton(
      minWidth: double.infinity,
      height: 55,
      onPressed: controller.loginWithGoogle,
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: const BorderSide(color: Colors.black26),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FaIcon(FontAwesomeIcons.google, color: Colors.red, size: 20),
          const SizedBox(width: 10),
          const Text(
            'Continuar con Google',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          FadeIn(
            delay: const Duration(milliseconds: 1600),
            child: const Icon(Icons.login, size: 20),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "No tienes cuenta? ",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed('signup'),
          child: const Text(
            'Registrarse',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.greenAccent,
            ),
          ),
        ),
      ],
    );
  }

//  void _handleLogin() async {
//   final email = emailController.text.trim();
//   final password = passwordController.text.trim();

//   try {
//     await authController.login(email, password);
    
//     Get.offNamed('/home_nav');
//   } catch (e) {
    
//     passwordController.clear();
//     Get.snackbar('Error', e.toString());
//   }
// }
void _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await authController.login(email, password);

      // Cargar los galpones antes de navegar
      await Get.find<WarehouseController>().cargarGalpones();

      // Navegar reemplazando toda la pila de navegación
      Get.offAllNamed('/home_nav');
    } catch (e) {
      passwordController.clear();
      Get.snackbar('Error', e.toString());
    }
  }
}