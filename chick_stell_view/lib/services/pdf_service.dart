import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class PdfService {
  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final firestore = FirebaseFirestore.instance;

    final prediccionesSnapshot = await firestore.collection('predicciones').get();

    final List<pw.Widget> secciones = [];

    for (final doc in prediccionesSnapshot.docs) {
      final historialSnapshot = await doc.reference.collection('historial').get();

      secciones.add(
        pw.Text(
          'Galpón Nombre: ${doc.id}',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
      );
      secciones.add(pw.SizedBox(height: 5));

      if (historialSnapshot.docs.isEmpty) {
        secciones.add(pw.Text('Sin registros.'));
      } else {
        for (final historialDoc in historialSnapshot.docs) {
          final data = historialDoc.data();
          final fecha = data['fecha']?.toString() ?? 'Sin fecha';
          final predicciones = List<Map<String, dynamic>>.from(data['predicciones'] ?? []);

          secciones.add(pw.Text('Fecha: $fecha', style: pw.TextStyle(fontSize: 12)));
          secciones.add(pw.SizedBox(height: 3));

          if (predicciones.isEmpty) {
            secciones.add(pw.Text('Sin predicciones.'));
          } else {
            secciones.add(
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
            );
          }

          secciones.add(pw.SizedBox(height: 10));
        }
      }

      secciones.add(pw.Divider());
    }

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, text: 'Informe de Historial de Predicciones'),
          ...secciones,
        ],
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/informe_predicciones.pdf");
    await file.writeAsBytes(await pdf.save());

    await OpenFilex.open(file.path);
  }
}
