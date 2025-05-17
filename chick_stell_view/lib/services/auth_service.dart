import 'dart:io';
import 'package:chick_stell_view/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn( scopes: ['email', 'profile']);

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
        
    } on FirebaseAuthException catch (e) {
      print('Error al registrarse {$e message}' );
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
      print('Error al iniciar sesion {$e message}' );
    }
    return null;
  }

  // Cerrar Sesion
  Future<void> singOut() async {
    await _auth.signOut();

    // Si usas almacenamiento local (opcional):
    await GetStorage().erase();

  }

  // Iniciar sesion con Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {

        await _firestore.collection('usarios').doc(user.uid).set({
          'uid': user.uid,
          'imageUrl': user.photoURL ?? googleUser.photoUrl,
          'name': user.displayName ?? googleUser.displayName,
          'email': user.email,
          'provider': 'google',
          'ws': '',
          'phone': '',
          'fnac': '',
          'lastLogin': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return user;

    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      return null;
    }
  }

  // Exepciones de Google
   void _handleAuthError(FirebaseAuthException e) {
    String errorMessage = 'Error al iniciar sesión';
    
    switch (e.code) {
      case 'account-exists-with-different-credential':
        errorMessage = 'Ya existe una cuenta con este email';
        break;
      case 'invalid-credential':
        errorMessage = 'Credenciales inválidas';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Operación no permitida';
        break;
      case 'user-disabled':
        errorMessage = 'Usuario deshabilitado';
        break;
      case 'user-not-found':
        errorMessage = 'Usuario no encontrado';
        break;
      case 'wrong-password':
        errorMessage = 'Contraseña incorrecta';
        break;
      case 'invalid-verification-code':
        errorMessage = 'Código de verificación inválido';
        break;
      case 'invalid-verification-id':
        errorMessage = 'ID de verificación inválido';
        break;
      default:
        errorMessage = 'Error desconocido: ${e.message}';
    }
    
    Get.snackbar('Error', errorMessage);
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

  Future<Profile?> getProfileById(String uid) async {
    try {
      final doc = await _firestore.collection('usuarios').doc(uid).get();
      if (doc.exists){
        return Profile.fromFirestore(doc);
      }
    } catch (e) {
      print('Error al obtener el perfil: $e');
    }
  }

}


  

