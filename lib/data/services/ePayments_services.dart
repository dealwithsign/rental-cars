// data/services/ePayments_services.dart
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rents_cars_app/utils/fonts.dart';

import '../models/ticket_model.dart';

PdfColor kPrimaryPdfColor = const PdfColor.fromInt(0xFF191919);
PdfColor kSubTitlePdfColor = const PdfColor.fromInt(0xff717171);
PdfColor kWhitePdfColor = const PdfColor.fromInt(0xffffffff);
PdfColor kDivider = const PdfColor.fromInt(0xffE9F2FD);
PdfColor greenColors = const PdfColor.fromInt(0xff018053);

class PdfService {
  Future<void> generatePdf(
    TicketModels ticket,
    String orderId,
    String name,
    String email,
    String phoneNumber,
    String ticketRute,
    String amountTraveller,
    String productDescription, // New parameter for product description
  ) async {
    final pdf = pw.Document();

    // Load custom fonts
    final primaryFont = await PdfGoogleFonts.interThin();

    // Load logo image

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: pw.EdgeInsets.all(defaultMargin),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Receipt title
                pw.Text(
                  'Bukti Pembayaran Tiket',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: kPrimaryPdfColor,
                  ),
                ),
                pw.SizedBox(height: defaultMargin / 2),
                // Order ID
                pw.Text(
                  'Order ID #$orderId',
                  style: pw.TextStyle(
                    fontSize: 13,
                    color: greenColors,
                  ),
                ),
                pw.SizedBox(height: defaultMargin * 2),
                _buildPersonalDetailsRow(
                  name,
                  email,
                  phoneNumber,
                  primaryFont,
                ),
                pw.SizedBox(height: defaultMargin * 2),

                // Payment Details Section
                _buildPaymentDetailsSection(
                    ticket,
                    primaryFont,
                    primaryFont,
                    ticketRute,
                    amountTraveller,
                    productDescription), // Pass the new parameter

                // Footer
                pw.Spacer(),
                _buildFooter(),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _buildPersonalDetailsRow(
      String name, String email, String phoneNumber, pw.Font font) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: kWhitePdfColor,
        borderRadius: pw.BorderRadius.all(
          pw.Radius.circular(defaultRadius),
        ),
        border: pw.Border.all(
          width: 1,
          style: pw.BorderStyle.solid,
          color: kDivider,
        ),
      ),
      padding: pw.EdgeInsets.all(defaultMargin),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Nama Pemesan',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: kPrimaryPdfColor,
                  fontSize: 13,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                name,
                style: pw.TextStyle(
                  fontSize: 13,
                  color: kPrimaryPdfColor,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Alamat Email',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: kPrimaryPdfColor,
                  fontSize: 13,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                email,
                style: pw.TextStyle(
                  fontSize: 13,
                  color: kPrimaryPdfColor,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Nomor Ponsel',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: kPrimaryPdfColor,
                  fontSize: 13,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                phoneNumber,
                style: pw.TextStyle(
                  fontSize: 13,
                  color: kPrimaryPdfColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPaymentDetailsSection(
    TicketModels ticket,
    pw.Font primaryFont,
    pw.Font secondaryFont,
    String ticketRute,
    String amountTraveller,
    String productDescription, // New parameter for product description
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Detail Pembayaran',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: kPrimaryPdfColor,
          ),
        ),
        pw.SizedBox(height: defaultMargin),
        pw.Container(
          decoration: pw.BoxDecoration(
            color: kWhitePdfColor,
            borderRadius: pw.BorderRadius.all(
              pw.Radius.circular(defaultRadius),
            ),
            border: pw.Border.all(
              width: 1,
              style: pw.BorderStyle.solid,
              color: kDivider,
            ),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Payment table headers
              pw.Padding(
                padding: pw.EdgeInsets.all(defaultMargin),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Produk',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: kPrimaryPdfColor,
                        fontSize: 13,
                      ),
                    ),
                    pw.Text(
                      'Deskripsi',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: kPrimaryPdfColor,
                        fontSize: 13,
                      ),
                    ),
                    pw.Text(
                      'Jumlah',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: kPrimaryPdfColor,
                        fontSize: 13,
                      ),
                    ),
                    pw.Text(
                      'Total',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: kPrimaryPdfColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Divider(
                color: kDivider,
                thickness: 1,
              ),

              // Ticket details from real data
              pw.Padding(
                padding: pw.EdgeInsets.all(defaultMargin),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Tiket Mobil",
                      style: pw.TextStyle(
                        fontSize: 13,
                        color: kPrimaryPdfColor,
                      ),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          productDescription,
                          style: pw.TextStyle(
                            fontSize: 13,
                            color: kPrimaryPdfColor,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          ticketRute,
                          style: pw.TextStyle(
                            fontSize: 13,
                            color: kPrimaryPdfColor,
                          ),
                        ),
                      ],
                    ),
                    pw.Text(
                      amountTraveller,
                      style: pw.TextStyle(
                        fontSize: 13,
                        color: kPrimaryPdfColor,
                      ),
                    ),
                    pw.Text(
                      _formatCurrency(
                        double.parse(ticket.grossAmount),
                      ),
                      style: pw.TextStyle(
                        fontSize: 13,
                        color: kPrimaryPdfColor,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: defaultMargin),
              pw.Padding(
                padding: pw.EdgeInsets.all(defaultMargin),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Biaya Pemesanan',
                      style: pw.TextStyle(
                        fontSize: 13,
                        color: kPrimaryPdfColor,
                      ),
                    ),
                    pw.Text(
                      "Termasuk",
                      style: pw.TextStyle(
                        fontSize: 13,
                        color: greenColors,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(defaultMargin),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Biaya Jasa',
                      style: pw.TextStyle(
                        fontSize: 13,
                        color: kPrimaryPdfColor,
                      ),
                    ),
                    pw.Text(
                      "Termasuk",
                      style: pw.TextStyle(
                        fontSize: 13,
                        color: greenColors,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Divider(
                color: kDivider,
                thickness: 1,
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(defaultMargin),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Pembayaran',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: kPrimaryPdfColor,
                      ),
                    ),
                    pw.Text(
                      _formatCurrency(double.parse(ticket.grossAmount)),
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: kPrimaryPdfColor,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(defaultMargin),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Metode Pembayaran:',
                      style: pw.TextStyle(
                        fontSize: 13,
                        color: kPrimaryPdfColor,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      _getPaymentMethod(ticket.paymentType),
                      style: pw.TextStyle(
                        fontSize: 13,
                        color: kPrimaryPdfColor,
                      ),
                    ),
                    pw.SizedBox(height: defaultMargin),
                    pw.Text(
                      'Waktu Pembayaran:',
                      style: pw.TextStyle(
                        fontSize: 13,
                        color: kPrimaryPdfColor,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      _formatIndonesianDatePayments(ticket.settlement_time),
                      style: pw.TextStyle(
                        fontSize: 13,
                        color: kPrimaryPdfColor,
                      ),
                    ),
                  ],
                ),
              )
              // Payment Method and Payment Time in Column without Border
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Lalan.id',
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: kPrimaryPdfColor,
          ),
        ),
        pw.SizedBox(height: defaultMargin),
        pw.Text(
          'Jakarta, Indonesia',
          style: pw.TextStyle(
            fontSize: 12,
            color: kPrimaryPdfColor,
          ),
        ),
        pw.Text(
          'helpmelalan@gmail.com',
          style: pw.TextStyle(
            fontSize: 12,
            color: kPrimaryPdfColor,
          ),
        ),
        pw.Text(
          '+62 82134400200',
          style: pw.TextStyle(
            fontSize: 12,
            color: kPrimaryPdfColor,
          ),
        ),
      ],
    );
  }

  String _getPaymentMethod(String paymentType) {
    switch (paymentType) {
      case 'bank_transfer':
      case 'echannel':
        return 'Transfer Bank - Virtual Account';
      case 'qris':
        return 'QRIS';
      default:
        return paymentType;
    }
  }

  String _formatIndonesianDatePayments(DateTime date) {
    Intl.defaultLocale = 'id_ID';
    var formatter = DateFormat('EEEE, dd MMMM \'Jam\' HH:mm');
    return formatter.format(date);
  }

  String _formatCurrency(double amount) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(amount);
  }
}
