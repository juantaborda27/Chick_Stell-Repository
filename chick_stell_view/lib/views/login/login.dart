import 'package:animate_do/animate_do.dart';
import 'package:chick_stell_view/controllers/auth_controller.dart';
import 'package:chick_stell_view/views/widgets/make_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();


    final Size screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
      ),
      body: Container(
        height: screenSize.height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            // Header Section
            SizedBox(height: screenSize.height * 0.05),
            FadeInDown(
              duration: const Duration(milliseconds: 1000),
              child: Column(
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      shadows: [
                        Shadow(
                          blurRadius: 1.0,
                          // color: Colors.grey.withOpacity(0.3),
                          offset: const Offset(1.0, 1.0),
                        ),
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
            
            // Spacer to push content toward center
            const Spacer(flex: 1),
            
            // Form Section
            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: Column(
                children: [
                  MakeInput(label: "Email"),
                  MakeInput(label: "Password", obscureText: true),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: FadeInRight(
                      duration: const Duration(milliseconds: 1300),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Login Button
            FadeInUp(
              duration: const Duration(milliseconds: 1400),
              child: Container(
                width: screenSize.width * 0.7, // Button width as 70% of screen width
                padding: const EdgeInsets.only(top: 3, bottom: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      // color: Colors.greenAccent.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 55,
                  //llamar a la vista del nav_bar
                  onPressed: () async{
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final success = await Get.find<AuthController>().login(email, password);
                    if (success) {
                      Get.snackbar('Éxito', 'Has iniciado sesión');
                      Get.offNamed('home_nav');
                    } else {
                      Get.snackbar('Error', 'Correo o contraseña incorrectos');
                    }
                    // Get.offNamed('home_nav');
                  },
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
                        'Login',
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
            ),
            
            const SizedBox(height: 25),
            
            // Sign Up link
            FadeInUp(
              duration: const Duration(milliseconds: 1500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {Get.offNamed('signup');},
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Spacer to push content to center
            const Spacer(flex: 2),
            SizedBox(height: screenSize.height * 0.05),
          ],
        ),
      ),
    );
  } 
}

