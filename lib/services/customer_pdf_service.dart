import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/customer.dart';

class CustomerPdfService {
  Future<Uint8List> buildCustomerListPdf(
    List<Customer> customers, {
    String title = 'Customer List',
  }) async {
    final pdf = pw.Document();
    final dateLabel = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text('Generated: $dateLabel', style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: const ['ID', 'Name', 'Phone'],
              data: [
                for (final customer in customers)
                  [customer.id, customer.name, customer.phone],
              ],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(),
              cellAlignment: pw.Alignment.centerLeft,
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellHeight: 20,
              columnWidths: const {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(3),
                2: pw.FlexColumnWidth(2),
              },
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Future<File> savePdf(Uint8List bytes, String fileName) async {
    if (kIsWeb) {
      throw Exception('Saving PDF to files is not supported on web.');
    }

    Directory? dir;
    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
      if (dir == null) {
        dir = await getApplicationDocumentsDirectory();
      }
      final downloadsDir = Directory('${dir.path}/Download');
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }
      dir = downloadsDir;
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
