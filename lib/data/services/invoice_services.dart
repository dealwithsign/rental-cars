// data/services/invoice_services.dart
import 'dart:io';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rents_cars_app/data/models/invoices_model.dart';
import 'package:rents_cars_app/data/models/ticket_model.dart'; // Import the InvoiceModel

class VaNumber {
  final String bank;
  final String vaNumber;

  VaNumber({required this.bank, required this.vaNumber});

  factory VaNumber.fromJson(Map<String, dynamic> json) {
    return VaNumber(
      bank: json['bank'],
      vaNumber: json['va_number'],
    );
  }
}

class PdfInvoiceApi {
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getExternalStorageDirectory();
    final file = File('${dir?.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  // open pdf file function
  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future<File> generate(
      PdfColor color, pw.Font fontFamily, TicketModels invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Row(
              children: [
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Bukti Pembayaran Tiket',
                      style: pw.TextStyle(
                        fontSize: 17.0,
                        fontWeight: pw.FontWeight.bold,
                        color: color,
                        font: fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'John Doe',
                  style: pw.TextStyle(
                    fontSize: 15.5,
                    fontWeight: pw.FontWeight.bold,
                    color: color,
                    font: fontFamily,
                  ),
                ),
                pw.Text(
                  'john@gmail.com',
                  style: pw.TextStyle(
                    fontSize: 14.0,
                    color: color,
                    font: fontFamily,
                  ),
                ),
                pw.Text(
                  DateTime.now().toString(),
                  style: pw.TextStyle(
                    fontSize: 14.0,
                    color: color,
                    font: fontFamily,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),
            pw.Table.fromTextArray(
              headers: ['Deskripsi', 'Detail'],
              data: [
                ['Order ID', invoice.orderId.toUpperCase()],
                ['Metode Pembayaran', invoice.paymentType],
                ['Status Pembayaran', invoice.transaction_status],
                [
                  'Total Pembayaran',
                  NumberFormat.currency(
                          locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(
                    double.parse(invoice.grossAmount),
                  )
                ],
              ],
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30.0,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
              },
            ),
            pw.Divider(),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                children: [
                  pw.Spacer(flex: 6),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Subtotal',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: color,
                                  font: fontFamily,
                                ),
                              ),
                            ),
                            pw.Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp ',
                                      decimalDigits: 0)
                                  .format(
                                double.parse(
                                  invoice.grossAmount,
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Biaya Jasa Aplikasi',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: color,
                                  font: fontFamily,
                                ),
                              ),
                            ),
                            pw.Text(
                              '12.000',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: color,
                                font: fontFamily,
                              ),
                            ),
                          ],
                        ),
                        pw.Divider(),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Total Pembayaran',
                                style: pw.TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: pw.FontWeight.bold,
                                  color: color,
                                  font: fontFamily,
                                ),
                              ),
                            ),
                            pw.Text(
                              NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp ',
                                      decimalDigits: 0)
                                  .format(
                                double.parse(
                                  invoice.grossAmount,
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.Text(
                          '*sudah termasuk imbal jasa penjualan',
                          style: pw.TextStyle(color: color, font: fontFamily),
                        ),
                        pw.SizedBox(height: 2 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                        pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        footer: (context) {
          return pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Divider(),
              pw.SizedBox(height: 2 * PdfPageFormat.mm),
              pw.Text(
                'Deal with Sign',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: color,
                    font: fontFamily),
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Jakarta, Indonesia',
                    style: pw.TextStyle(color: color, font: fontFamily),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return saveDocument(name: 'E-Receipt-Ticket.pdf', pdf: pdf);
  }
}

Future<TicketModels> fetchPaymentDetails(String bookingId) async {
  final response = await http.get(Uri.parse(
      'https://midtrans-fumjwv6jv-dealwithsign.vercel.app/v1/$bookingId/status'));

  if (response.statusCode == 200) {
    return TicketModels.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load payment details');
  }
}
