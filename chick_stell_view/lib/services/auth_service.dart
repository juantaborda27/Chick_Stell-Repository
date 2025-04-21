


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerEmail(String email, String password, String confirmPassword) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
        );

        User? user = userCredential.user;

        if(user != null){
          await _firestore.collection('usuarios').doc(user.uid).set({
            'imageUrl': '',
            'name': '',
            'email': email,
            'ws': '',
            'phone': '',
            'password': password,
            'fnac': null,
            'createdAt': FieldValue.serverTimestamp(),

          });
          return user;
        }
        return null;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('error', 'Error al registrarse {$e message}' );
    }
  }
  
  Future<User?> loginEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
        );
       return userCredential.user;

    } on FirebaseAuthException catch (e) {
      Get.snackbar('error', 'Error al iniciar sesion {$e message}' );
    }
  }

  Future<void> saveUsers(String uid, String email) async{
    await _firestore.collection('usuaios-nuevos').doc(uid).set({
      'imageUrl': '',
            'name': '',
            'email': email,
            'ws': '',
            'phone': '',
            'fnac': null,
            'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
}