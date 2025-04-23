
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String id;
  String? imageUrl;
  String? name;
  String email;
  String? ws;
  String? phone;
  String password;

  DateTime? createdAt;
  DateTime? fnac;

  Profile({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.email,
    required this.ws,
    required this.phone,
    required this.password,
    this.createdAt,
    this.fnac
  });

  factory Profile.fromFirestore(DocumentSnapshot data) {
    return Profile(
      id: data['id'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      ws: data['ws'] ?? '',
      phone: data['phone'] ?? '',
      password: data['password'] ?? '',
      createdAt: (data['createdAt'] != null)
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      fnac: (data['fnac'] != null)
          ? (data['fnac'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'email': email,
      'ws': ws,
      'phone': phone,
      'password': password,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'fnac': fnac != null ? Timestamp.fromDate(fnac!) : null,
    };
  }
}