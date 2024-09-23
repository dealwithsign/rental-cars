// presentation/pages/ticket_success_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pdf/pdf.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:http/http.dart' as http;

import '../../blocs/tickets/tickets_bloc.dart';
import '../../data/models/ticket_model.dart';
import '../../data/services/invoice_services.dart';
import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';
import 'package:pdf/widgets.dart' as pw;

class TicketDetailScreen extends StatefulWidget {
  final TicketModels ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: _buildAppBar(context),
      body: BlocListener<TicketsBloc, TicketsState>(
        listener: (context, state) {
          if (state is TicketsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      leading: IconButton(
        icon: Icon(
          LineIcons.angleLeft,
          color: kPrimaryColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.ticket.carFrom} - ${widget.ticket.carTo}',
            style: titleTextStyle.copyWith(
              fontSize: 16,
              fontWeight: bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Order ID: ${widget.ticket.bookingId.toUpperCase()}',
            style: blackTextStyle.copyWith(
              fontSize: 14,
            ),
          ),
        ],
      ),
      centerTitle: false,
      elevation: 0,
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<TicketsBloc, TicketsState>(
      builder: (context, state) {
        if (state is TicketsLoading) {
          return Center(
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 25,
            ),
          );
        } else if (state is TicketsSuccess) {
          if (state.tickets.isEmpty) {
            return Center(
              child: Text('Belum ada booking', style: blackTextStyle),
            );
          }
          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: defaultMargin),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Detail Perjalanan',
                        //   style: titleTextStyle.copyWith(
                        //     fontSize: 18,
                        //     fontWeight: bold,
                        //   ),
                        // ),
                        // SizedBox(height: defaultMargin),
                        _buildDetailsTravel(
                          lokasiJemput: widget.ticket.carFrom,
                          lokasiTujuan: widget.ticket.carTo,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: defaultMargin),
                  Divider(
                    color: kBackgroundColor,
                    thickness: 5,
                  ),
                  SizedBox(height: defaultMargin),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _otherInformations(),
                        SizedBox(height: defaultMargin),
                        _buildDetailsPrice(),
                        Padding(
                            padding:
                                EdgeInsets.only(bottom: defaultMargin * 2)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is TicketsError) {
          return Center(
            child: Text('Error: ${state.message}', style: blackTextStyle),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildDetailsTravel({
    required String lokasiJemput,
    required String lokasiTujuan,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.ticket.carName,
          style: titleTextStyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
        SizedBox(height: defaultMargin),
        Text(
          "Dioperasikan oleh ${widget.ticket.ownerCar}",
          style: blackTextStyle.copyWith(
            fontSize: 15,
          ),
        ),
        Text(
          formatIndonesianDate(widget.ticket.carDate),
          style: blackTextStyle.copyWith(
            fontSize: 15,
          ),
        ),
        Text(
          "${widget.ticket.selectedPassengers.toString()} penumpang",
          style: blackTextStyle.copyWith(
            fontSize: 15,
          ),
        ),
        SizedBox(height: defaultMargin * 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: kBackgroundColor,
                  child: Icon(
                    FontAwesomeIcons.locationArrow,
                    color: kPrimaryColor,
                    size: 20,
                  ),
                ),
                Container(
                  width: 2,
                  height: 80,
                  color: kBackgroundColor,
                ),
                CircleAvatar(
                  backgroundColor: kBackgroundColor,
                  child: Icon(
                    FontAwesomeIcons.locationDot,
                    color: kPrimaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(width: defaultMargin),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ticket.carFrom,
                    style: blackTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.ticket.selected_location_pick,
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: defaultMargin * 4),
                  Text(
                    widget.ticket.carTo,
                    style: blackTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.ticket.selected_location_drop,
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: defaultMargin * 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Permintaan Khusus",
              style: titleTextStyle.copyWith(
                fontSize: 14,
                fontWeight: bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.ticket.specialRequest,
              style: subTitleTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
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

  Widget _buildDetailsPrice() {
    return FutureBuilder<TicketModels>(
      future: fetchPaymentDetails(widget.ticket.bookingId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final ticket = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                'Nomor Transaksi',
                ticket.transactionId,
              ),
              _buildDetailItem('Metode Pembayaran', ticket.paymentType),
              _buildDetailItem(
                'Tanggal Pembayaran',
                formatIndonesianDate(ticket.settlement_time),
              ),
              _buildDetailItem(
                'Total Pembayaran',
                NumberFormat.currency(
                        locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                    .format(
                  double.parse(ticket.grossAmount),
                ),
              ),
              // SizedBox(height: defaultMargin),
              // CustomButton(
              //   title: "Bukti Pembayaran",
              //   onPressed: () async {
              //     final file = await PdfInvoiceApi.generate(
              //       PdfColors.blue, // Warna untuk teks dan elemen lainnya
              //       pw.Font.helvetica(), // Font yang akan digunakan
              //       // Font yang akan digunakan
              //       ticket, // Data yang akan ditampilkan
              //     );

              //     // Setelah invoice dihasilkan, buka file tersebut
              //     PdfInvoiceApi.openFile(file);
              //   },
              // ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return SpinKitThreeBounce(
          color: kPrimaryColor,
          size: 25,
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    String displayValue = value;
    Color textColor = Colors.black;

    if (label == 'Metode Pembayaran' && value == 'bank_transfer' ||
        value == 'echannel') {
      displayValue = 'Transfer Bank';
    } else if (label == 'Metode Pembayaran' && value == 'qris') {
      displayValue = 'QRIS';
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: defaultMargin,
      ), // Add padding to the bottom
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: subTitleTextStyle.copyWith(
              fontSize: 14,
            ),
          ),
          SizedBox(height: defaultMargin),
          Text(
            displayValue,
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String formatIndonesianDate(DateTime date) {
    Intl.defaultLocale = 'id_ID'; // Ensure the locale is set to Indonesian
    var formatter = DateFormat('EEEE, dd MMMM hh:mm a');
    return formatter.format(date);
  }

  String formatCurrency(double amount) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currencyFormatter.format(amount);
  }
}

Widget _otherInformations() {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xffCEEAD6),
      borderRadius: BorderRadius.circular(defaultRadius),
      border: Border.all(
        color: kTransparentColor,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.checkCircle,
            color: kPrimaryColor,
            size: 20,
          ),
          SizedBox(width: defaultMargin),
          Expanded(
            child: Text(
              'Terima kasih! Pembayaran Anda sudah diterima \nSilakan cek email untuk detail pemesanan',
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
