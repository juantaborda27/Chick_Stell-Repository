import 'package:chick_stell_view/controllers/auth_controller.dart';
import 'package:chick_stell_view/controllers/notificacion_controller.dart';
import 'package:chick_stell_view/controllers/profile_controller.dart';
import 'package:chick_stell_view/controllers/simulacion_controller.dart';
import 'package:chick_stell_view/views/main_views/ajustes/editar_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AjustesView extends StatefulWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final AuthController authController = Get.find<AuthController>();
  final SimulacionController simulacionController = Get.put(SimulacionController());
  final NotificacionController notificacionController = Get.put(NotificacionController());
  
  

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<AjustesView> {
final profileController = Get.put(ProfileController());
final authContreller = Get.put(AuthController()); 
final simulacionController = Get.put(SimulacionController());
final notificacionController = Get.put(NotificacionController());

  // Variables de estado local (temporales)
  bool alertasCriticas = true;
  bool informesDiarios = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes', style: TextStyle(color: Colors.teal[800], fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Perfil de Usuario
              _buildSectionTitle('Perfil de Usuario', Icons.person_outline),
              _buildUserProfileCard(),
              SizedBox(height: 8),
              _buildEditProfileButton(),
              
              SizedBox(height: 24),
              
              // Notificaciones
              _buildSectionTitle('Notificaciones', Icons.notifications_none),
              Obx(() => _buildToggleOption(
                'Alertas críticas', 
                'Recibir alertas de situaciones críticas',
                notificacionController.notificacionesActivas.value,
                (value) {
                  notificacionController.toggleNotificaciones();
                },
              )),
              _buildDivider(),
              Obx(() => _buildToggleOption(
                'Predicciones',
                'Modulo de predicciones de IA',
                simulacionController.simulando.value,
              (value) {
                simulacionController.toggleSimulacion(value);
                },
              )),
              _buildDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton.icon(
                onPressed: () {
                  simulacionController.descargarHistorialPredicciones();
              },
                icon: Icon(Icons.picture_as_pdf),
                label: Text("Descargar informe PDF"),
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ),
              
              SizedBox(height: 24),
              
              // Seguridad
              _buildSectionTitle('Seguridad', Icons.lock_outline),
              _buildPasswordButton(),
              _buildDivider(),
              
              
              SizedBox(height: 24),
              
              // Botones de soporte y cerrar sesión
              _buildBottomButtons(),
              
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.teal[800]),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.teal[800],
            ),
          ),
        ],
      ),
    );
  }
  
Widget _buildUserProfileCard() {
  return Obx(() {
    final name = profileController.name.value;
    final photoUrl = profileController.profileImageUrl.value;
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : 'JD';

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 24,
              backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                  ? NetworkImage(photoUrl)
                  : null,
              child: photoUrl == null || photoUrl.isEmpty
                  ? Text(
                      initials,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Administrador',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });
}


  
  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey[200]);
  }
  
Widget _buildEditProfileButton() {
  return Obx(() {
    final email = authContreller.user.value?.email ?? '';

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Correo electrónico',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(email),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: editProfileView,
              child: Center(child: Text('Editar perfil')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.teal,
                elevation: 0,
                side: BorderSide(color: Colors.teal),
                minimumSize: Size(double.infinity, 44),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

  
  Widget _buildToggleOption(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
  
  
  Widget _buildPasswordButton() {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            authContreller.logOut();
          },
          child: Center(child: Text('Cambiar contraseña')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.teal,
            elevation: 0,
            side: BorderSide(color: Colors.teal),
            minimumSize: Size(double.infinity, 44),
          ),
        ),
      ),
    );
  }
  
  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.help_outline),
            label: Text('Soporte'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal,
              elevation: 0,
              side: BorderSide(color: Colors.teal),
              minimumSize: Size(0, 44),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              authContreller.logOut();
            },
            icon: Icon(Icons.logout),
            label: Text('Cerrar sesión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey[700],
              elevation: 0,
              side: BorderSide(color: Colors.grey[400]!),
              minimumSize: Size(0, 44),
            ),
          ),
        ),
      ],
    );
  }
}