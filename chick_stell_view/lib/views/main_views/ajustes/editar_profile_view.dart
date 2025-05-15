import 'dart:io';
import 'package:chick_stell_view/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void editProfileView() {
  final ProfileController controller = Get.put(ProfileController());
  final emailController = TextEditingController(text: controller.authController.user.value?.email ?? '');
  final TextEditingController nameController = TextEditingController(text: controller.name.value);
  final TextEditingController phoneController = TextEditingController(text: controller.phone.value);
  final TextEditingController whatsappController = TextEditingController(text: controller.whatsapp.value);
  final Color primaryColor = Color(0xFF23AB8F); 
  // Mostrar el BottomSheet   
  
  
  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header con título y botón de cerrar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.person_outline, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text('Editar Perfil', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Contenido principal
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección de Información Básica
                    Text('Información Básica', 
                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                    SizedBox(height: 16),
                    
                    // Foto de perfil
                    Center(
                      child: Obx(() {
                         final imagePath = controller.localImagePath.value;
                         final networkImage = controller.authController.user.value?.photoURL;
                          return Stack(
                                children: [
                                   CircleAvatar(
                                       radius: 50,
                                       backgroundColor: Colors.grey.shade200,
                                         backgroundImage: imagePath != null && imagePath.isNotEmpty
                                       ? FileImage(File(imagePath))
                                       : (networkImage != null ? NetworkImage(networkImage) : null) as ImageProvider?,
                                       child: (imagePath == null || imagePath.isEmpty) && networkImage == null
                                       ? Icon(Icons.person, size: 50, color: Colors.grey.shade400)
                                      : null,
                                        ),
                                  Positioned(
                                       right: 0,
                                       bottom: 0,
                                       child: Container(
                                      padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                        color: primaryColor,
                                       shape: BoxShape.circle,
                                         border: Border.all(color: Colors.white, width: 2),
                          ),
                             child: InkWell(
                             onTap: controller.pickImage,
                              child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                           ),
                        ),
                  ),
                  ],
                 );
               }),

                    ),
                    SizedBox(height: 20),
                    
                    // Campos del formulario con estilo similar a la imagen
                    _buildStyledTextField(
                      label: 'Nombre',
                      controller: nameController,
                      icon: Icons.person_outline,
                      iconColor: primaryColor,
                    ),
                    SizedBox(height: 15),
                    _buildStyledTextField(
                      label: 'Email',
                      controller: emailController,
                      icon: Icons.email_outlined,
                      iconColor: primaryColor,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 15),
                    
                    // Teléfono y WhatsApp con estilo de campo numérico como en la imagen
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Teléfono', style: TextStyle(color: Colors.black54, fontSize: 14)),
                              _buildStyledTextField(
                                label: 'Teléfono',
                                controller: phoneController,
                                icon: Icons.phone_outlined,
                                iconColor: primaryColor,
                                keyboardType: TextInputType.phone,
                                hintVisible: false,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('WhatsApp', style: TextStyle(color: Colors.black54, fontSize: 14)),
                              _buildStyledTextField(
                                label: 'WhatsApp',
                                controller: whatsappController,
                                icon: Icons.messenger,
                                iconColor: primaryColor,
                                keyboardType: TextInputType.phone,
                                hintVisible: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Nota informativa como en la imagen
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFE6F7F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: primaryColor, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Esta información será visible en tu perfil público',
                              style: TextStyle(color: Colors.black87, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Botón para guardar
                    ElevatedButton(
                      onPressed: () {
                        controller.updateProfile(
                          newName: nameController.text,
                          newPhone: phoneController.text,
                          newWhatsapp: whatsappController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_box_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('GUARDAR PERFIL', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Botón para cancelar
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Text('CANCELAR', 
                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

Widget _buildStyledTextField({
  required String label,
  required IconData icon,
  required Color iconColor,
  required TextEditingController controller,
  bool enabled = true,
  TextInputType keyboardType = TextInputType.text,
  bool hintVisible = true,
}) {
  return Container(
    height: 48,
    margin: EdgeInsets.only(bottom: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      children: [
        SizedBox(width: 10),
        Icon(icon, color: iconColor, size: 20),
        SizedBox(width: 6),
        Expanded(
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintVisible ? label : null,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    ),
  );
}
