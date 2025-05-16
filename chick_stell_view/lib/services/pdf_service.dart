import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class PdfService {
  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final firestore = FirebaseFirestore.instance;

    // 1. Obtener predicciones
    final prediccionesSnapshot = await firestore.collection('predicciones').get();

    // 2. Crear una lista de secciones para cada documento
    final List<pw.Widget> secciones = [];

    for (final doc in prediccionesSnapshot.docs) {
      final historialSnapshot = await doc.reference.collection('historial').get();

      secciones.add(
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Galpón ID: ${doc.id}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            if (historialSnapshot.docs.isEmpty)
              pw.Text('Sin registros.'),
            if (historialSnapshot.docs.isNotEmpty)
              ...historialSnapshot.docs.map((historialDoc) {
                final data = historialDoc.data();
                final fecha = data['fecha']?.toString() ?? 'Sin fecha';
                final predicciones = List<Map<String, dynamic>>.from(data['predicciones'] ?? []);

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Fecha: $fecha', style: pw.TextStyle(fontSize: 12)),
                    pw.SizedBox(height: 3),
                    pw.Table.fromTextArray(
                      headers: ['Hora', 'Confianza', 'Probabilidad', 'Estrés térmico'],
                      data: predicciones.map((pred) {
                        return [
                          pred['hora']?.toString() ?? '',
                          pred['confianza']?.toString() ?? '',
                          pred['probabilidad']?.toString() ?? '',
                          pred['estres_termico']?.toString() ?? '',
                        ];
                      }).toList(),
                    ),
                    pw.SizedBox(height: 10),
                  ],
                );
              }).toList(),
            pw.Divider(),
          ],
        ),
      );
    }

    // 3. Agregar la página al PDF
    pdf.addPage(pw.MultiPage(
      build: (context) => [
        pw.Header(level: 0, text: 'Informe de Historial de Predicciones'),
        ...secciones,
      ],
    ));

    // 4. Guardar el archivo
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/informe_predicciones.pdf");
    await file.writeAsBytes(await pdf.save());

    // 5. Abrir automáticamente
    await OpenFilex.open(file.path);
  }
}
