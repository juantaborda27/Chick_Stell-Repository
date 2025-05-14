

// import 'package:flutter/material.dart';

// class AjustesView extends StatelessWidget {
//   const AjustesView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ajustes'),
//       ),
//     );
//   }
// }

import 'package:chick_stell_view/views/main_views/ajustes/editar_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AjustesView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<AjustesView> {
  // Variables de estado local (temporales)
  bool alertasCriticas = true;
  bool predicciones = true;
  bool informesDiarios = true;
  String frecuenciaActualizacion = 'Cada 5 minutos';

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
              _buildToggleOption(
                'Alertas críticas', 
                'Recibir alertas de situaciones críticas', 
                alertasCriticas,
                (value) {
                  setState(() {
                    alertasCriticas = value;
                  });
                }
              ),
              _buildDivider(),
              _buildToggleOption(
                'Predicciones', 
                'Notificaciones de predicciones de IA', 
                predicciones,
                (value) {
                  setState(() {
                    predicciones = value;
                  });
                }
              ),
              _buildDivider(),
              _buildToggleOption(
                'Informes diarios', 
                'Recibir resumen diario por email', 
                informesDiarios,
                (value) {
                  setState(() {
                    informesDiarios = value;
                  });
                }
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
              child: Text(
                'JD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Juan Díaz',
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
  }
  
  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey[200]);
  }
  
  Widget _buildEditProfileButton() {
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
              child: Text('juan.diaz@ejemplo.com'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
               
              },
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
  
  // ignore: unused_element
  Widget _buildDropdownOption() {
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
              'Frecuencia de actualización',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: frecuenciaActualizacion,
                  icon: Icon(Icons.keyboard_arrow_down),
                  isExpanded: true,
                  items: [
                    'Cada 1 minuto',
                    'Cada 5 minutos',
                    'Cada 15 minutos',
                    'Cada 30 minutos',
                    'Cada hora',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        frecuenciaActualizacion = newValue;
                      });
                    }
                  },
                ),
              ),
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
          onPressed: () {},
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
            onPressed: () {},
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