import 'package:chick_stell_view/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';


class SingUp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  SingUp({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
   
      body: Obx(() => Container(
        height: screenSize.height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: authController.isloading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Header Section
                  SizedBox(height: screenSize.height * 0.05),
                  FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    child: Column(
                      children: [
                        Text(
                          'Registrarse',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            shadows: [
                              const Shadow(
                                blurRadius: 1.0,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: Text(
                            'Crea tu cuenta',
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
                  Column(
                    children: [
                      _buildEmailField(),
                      const SizedBox(height: 20),
                      _buildPasswordField(),
                      const SizedBox(height: 20),
                      _buildConfirmPasswordField(),

                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Register Button
                  _buildRegisterButton(screenSize),
                  
                  const SizedBox(height: 25),
                  
                  const Spacer(flex: 2),
                  SizedBox(height: screenSize.height * 0.05),
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: TextField(
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
      ),
    );
  }

  

  Widget _buildPasswordField() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: TextField(
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
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: TextField(
        controller: confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Confirmar Contraseña",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
  

  


  Widget _buildRegisterButton(Size screenSize) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1400),
      child: Container(
        width: screenSize.width * 0.7,
        padding: const EdgeInsets.only(top: 3, bottom: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: MaterialButton(
          minWidth: double.infinity,
          height: 55,
          onPressed: () => _handleRegister(),
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
                'Crear Cuenta',
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
      ),
    );
  }

void _handleRegister() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final confirmPassword = confirmPasswordController.text.trim();

  try {
    await authController.register(email, password, confirmPassword);
   
  } catch (e) {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    Get.snackbar('Error', e.toString());
  }
}
}