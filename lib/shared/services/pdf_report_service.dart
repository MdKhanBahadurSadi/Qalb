import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class PdfReportService {
  static Future<void> generateAndShowReport({
    required String userName,
    required double riskScore,
    required String riskCategory,
    required List<Map<String, String>> riskFactors,
    required List<String> recommendations,
    required List<Map<String, dynamic>> history,
  }) async {
    final pdf = pw.Document();

    // Bangla এবং Unicode সাপোর্ট করার জন্য গুগল ফন্ট লোড করা
    final banglaFont = await PdfGoogleFonts.hindSiliguriMedium();
    final banglaFontBold = await PdfGoogleFonts.hindSiliguriBold();
    
    // আরবিক সাপোর্ট করার জন্য ফন্ট (ঐচ্ছিক, যদি প্রয়োজন হয়)
    final arabicFont = await PdfGoogleFonts.notoNaskhArabicRegular();

    final theme = pw.ThemeData.withFont(
      base: banglaFont,
      bold: banglaFontBold,
    );

    // Page 1: Cover
    pdf.addPage(
      pw.Page(
        theme: theme,
        build: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(40),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.teal, width: 2),
          ),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Qalb', style: pw.TextStyle(fontSize: 60, fontWeight: pw.FontWeight.bold, color: PdfColors.teal)),
              pw.SizedBox(height: 20),
              pw.Text('Health Report', style: const pw.TextStyle(fontSize: 30, color: PdfColors.grey700)),
              pw.SizedBox(height: 60),
              pw.Divider(color: PdfColors.teal),
              pw.SizedBox(height: 20),
              pw.Text('Patient: $userName', style: const pw.TextStyle(fontSize: 20)),
              pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}', style: const pw.TextStyle(fontSize: 16)),
              pw.Spacer(),
              pw.Text('Islamic Heart Health Assessment', style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic)),
            ],
          ),
        ),
      ),
    );

    // Page 2: Risk Assessment
    pdf.addPage(
      pw.Page(
        theme: theme,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Risk Assessment', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              color: riskScore > 50 ? PdfColors.red100 : PdfColors.green100,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Overall Risk Score', style: const pw.TextStyle(fontSize: 16)),
                      pw.Text('${riskScore.toStringAsFixed(1)}%', 
                        style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold, color: riskScore > 50 ? PdfColors.red : PdfColors.green)),
                    ],
                  ),
                  pw.Text(riskCategory, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Text('Risk Factors Breakdown', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Factor', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Status', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ],
                ),
                ...riskFactors.map((f) => pw.TableRow(
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(f['factor'] ?? '')),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(f['status'] ?? '', 
                      style: pw.TextStyle(color: f['status'] == 'High' ? PdfColors.red : PdfColors.black))),
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );

    // Page 3: Recommendations
    pdf.addPage(
      pw.Page(
        theme: theme,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Recommendations', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            ...recommendations.asMap().entries.map((e) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 10),
              child: pw.Text('${e.key + 1}. ${e.value}'),
            )),
            pw.SizedBox(height: 40),
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.orange),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Medical Disclaimer', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.orange)),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'This report is an AI-based assessment. It is not a substitute for professional medical advice. Always consult a qualified doctor for any health concerns.',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Page 4: Health Trends
    pdf.addPage(
      pw.Page(
        theme: theme,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Health Trends', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Date')),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Score')),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Category')),
                  ],
                ),
                ...history.map((h) => pw.TableRow(
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(h['date'].toString())),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('${h['score']}%')),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(h['category'] ?? '')),
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();

    // 1. Show PDF
    await Printing.layoutPdf(onLayout: (format) async => bytes);

    // 2. Share PDF
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/qalb_report.pdf');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], text: 'My Qalb Health Report');

    // 3. Save to Firestore (Optional based on user request)
    try {
      final storageRef = FirebaseStorage.instance.ref().child('reports/${DateTime.now().millisecondsSinceEpoch}.pdf');
      await storageRef.putData(bytes);
      final url = await storageRef.getDownloadURL();
      
      await FirebaseFirestore.instance.collection('reports').add({
        'userName': userName,
        'url': url,
        'timestamp': FieldValue.serverTimestamp(),
        'score': riskScore,
      });
    } catch (e) {
      debugPrint('Error saving report: $e');
    }
  }
}
