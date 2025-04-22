import 'package:animate_do/animate_do.dart';
import 'package:chick_stell_view/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

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
            
            // Spacer to push content to center
            const Spacer(flex: 2),
            SizedBox(height: screenSize.height * 0.05),
          ],
        ),
      ),
    );
  } 
}

