import 'package:chick_stell_view/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class AuthService {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<Profile?> login(String email, String password) async {
    try {
      final querySnapshot = await usersRef
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Profile.fromFirestore(querySnapshot.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error durante el login: $e');
    }
  }
}
