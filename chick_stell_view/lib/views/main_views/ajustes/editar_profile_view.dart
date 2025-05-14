
import 'dart:io';
import 'package:chick_stell_view/controllers/auth_controller.dart';
import 'package:chick_stell_view/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final AuthController authController = Get.find();
  File? imageFile;
  
    final nombreController = TextEditingController();
    final emailController = TextEditingController();
    final wsController = TextEditingController();
    final phoneController = TextEditingController();

     @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile?>(
      future: authController.loadUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(body: Center(child: Text('Error al cargar el perfil')));
        }

        final profile = snapshot.data!;

        nombreController.text = profile.name ?? '';
        emailController.text = profile.email;
        wsController.text = profile.ws ?? '';
        phoneController.text = profile.phone ?? '';

        return Scaffold(
          appBar: AppBar(title: Text('Editar perfil')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      setState(() {
                        imageFile = File(picked.path);
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: imageFile != null
                        ? FileImage(imageFile!)
                        : (profile.imageUrl != null && profile.imageUrl!.isNotEmpty
                            ? NetworkImage(profile.imageUrl!)
                            : null),
                    child: imageFile == null && (profile.imageUrl?.isEmpty ?? true)
                        ? Icon(Icons.camera_alt)
                        : null,
                  ),
                ),
                TextField(controller: nombreController, decoration: InputDecoration(labelText: 'Nombre')),
                TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
                TextField(controller: wsController, decoration: InputDecoration(labelText: 'WhatsApp')),
                TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Teléfono')),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final updated = Profile(
                      id: profile.id,
                      imageUrl: profile.imageUrl,
                      name: nombreController.text,
                      email: emailController.text,
                      ws: wsController.text,
                      phone: phoneController.text,
                      password: '',
                    );
                    authController.updateProfile(updated, imageFile);
                    Get.back();
                  },
                  child: Text('Guardar cambios'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  
}