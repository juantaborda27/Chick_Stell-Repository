import 'package:animate_do/animate_do.dart';
import 'package:chick_stell_view/controllers/auth_contorller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
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
        labelText: "Password",
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
    );
  }

  Widget _buildSignUpLink() {
    return Row(
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
          onTap: () => Get.toNamed('signup'),
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
    );
  }

  void _handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
     authController.login(email, password); 
    
    
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Por favor completa todos los campos');
      return;
    }

    try {
      authController.login(email, password);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    
    Get.offNamed('/home_nav');
  }
}