

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final prediccioneRef = FirebaseFirestore.instance.collection('predicicones');

    final snapshot = await prediccioneRef.get();
    for (final doc in snapshot.docs) {
      final historialSnapshot = await doc.reference.collection('historial').get();
      final historial = historialSnapshot.docs.map((e) => e.data()).toList();

      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment:pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Predicción ID: ${doc.id}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ...historial.map((item) => pw.Text(item.toString())).toList(),
            ] 
            ),
        )
      );
      
    }
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/predicciones.pdf");
    await file.writeAsBytes(await pdf.save());
  }
}