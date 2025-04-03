

import 'package:animate_do/animate_do.dart';
import 'package:chick_stell_view/views/widgets/make_input.dart';
import 'package:flutter/material.dart';

class SingUp extends StatelessWidget {
  const SingUp({super.key});

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
                    'Sing Up',
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
            
            // Spacer to push content toward center
            const Spacer(flex: 1),
            
            // Form Section
            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: Column(
                children: [
                  MakeInput(label: "Email"),
                  MakeInput(label: "Password", obscureText: true),
                  MakeInput(label: "Confirm Password", obscureText: true),
                  // Forgot Password
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
                  onPressed: () {},
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
                        'Create Account',
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
            
            const Spacer(flex: 2),
            SizedBox(height: screenSize.height * 0.05),
          ],
        ),
      ),
    );
  } 
}