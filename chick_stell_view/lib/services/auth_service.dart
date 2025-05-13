import 'dart:io';

import 'package:chick_stell_view/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
            'fnac': '',
            'createdAt': FieldValue.serverTimestamp(),

          });
          return user;
        }
        return null;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('error', 'Error al registrarse {$e message}' );
    }
    return null;
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
    return null;
  }

  // Iniciar sesion con Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }  

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        final doc = await _firestore.collection('usuarios').doc(user.uid).get();
        if (!doc.exists) {
          await _firestore.collection('usarios').doc(user.uid).set({
            'imageUrl': user.photoURL,
            'name': user.displayName,
            'email': user.email,
            'ws': '',
            'phone': '',
            'fnac': '',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return user;
    } catch (e) {
      Get.snackbar('Error', 'Error al iniciar sesion con Google: $e');
      return null; 
    }
  }

  // Editar Perfil
  Future<Profile> updateUserProfile(Profile user, File imageFile) async{
   String? imageUrl = user.imageUrl; 

    if (imageFile != null) {
      final ref = _storage.ref().child('user_image/${user.id}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
      user.imageUrl = imageUrl;
    }

    final updateUser = Profile(
      id: user.id, imageUrl: user.imageUrl, name: user.name, email: user.email, ws: user.ws, phone: user.phone, password: '');


      await _firestore.collection('usuarios').doc(user.id).update(user.toFirestore());
      
   return user;
  }

}
  

