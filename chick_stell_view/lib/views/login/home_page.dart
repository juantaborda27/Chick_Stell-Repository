import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla para cálculos responsivos
    final Size screenSize = MediaQuery.of(context).size;
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
        primaryColor: Colors.yellow,
        fontFamily: 'Poppins', // Considera cambiar la fuente si está disponible
      ),
      home: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: screenSize.height,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.grey.shade100],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Header Section
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      ElasticIn(
                        duration: const Duration(milliseconds: 1200),
                        child: Text(
                          "Welcome",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 36,
                            color: Colors.black87,
                            shadows: [
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.grey.withOpacity(0.5),
                                offset: const Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        duration: const Duration(milliseconds: 1000),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Automatic identity verification which enables you to verify your identity",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[700], 
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Logo Section
                ZoomIn(
                  duration: const Duration(milliseconds: 1000),
                  child: Container(
                    height: screenSize.height * 0.25,
                    width: screenSize.width * 0.7,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.contain,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Buttons Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      SlideInUp(
                        duration: const Duration(milliseconds: 800),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 55,
                          onPressed: () {},
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey.shade800),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          color: Colors.white,
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BounceInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.black87, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.yellow.withOpacity(0.3),
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
                            color: Colors.yellow,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flash(
                                  infinite: true,
                                  duration: const Duration(seconds: 3),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      FadeIn(
                        delay: const Duration(milliseconds: 1500),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Need help?',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}