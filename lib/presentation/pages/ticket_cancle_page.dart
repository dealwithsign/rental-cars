// presentation/pages/ticket_cancle_page.dart
import 'dart:convert';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:http/http.dart' as http;

import '../../blocs/tickets/tickets_bloc.dart';
import '../../data/models/ticket_model.dart';
import '../../utils/fonts.dart';
import '../widgets/flushbar_widget.dart';

class TicketCancelPage extends StatefulWidget {
  final TicketModels ticket;

  const TicketCancelPage({super.key, required this.ticket});

  @override
  State<TicketCancelPage> createState() => _TicketCancelPageState();
}

class _TicketCancelPageState extends State<TicketCancelPage> {
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
          Iconsax.arrow_left_2,
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
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: defaultMargin * 2)),
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

  Widget _otherInformations() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFAD2CF),
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
              Iconsax.info_circle,
              color: kPrimaryColor,
              size: 20,
            ),
            SizedBox(width: defaultMargin),
            Expanded(
              child: Text(
                'Batas waktu pembayaranmu telah berakhir \nPesanan ini tidak dapat lagi digunakan',
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

  Widget _infoPayment() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Setelah pembayaran diverifikasi, detail pemesanan tiket akan \ndikirimkan ke email yang terdaftar.',
              style: subTitleTextStyle.copyWith(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
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
        Row(
          children: [
            Text(
              formatIndonesianDate(widget.ticket.carDate),
              style: blackTextStyle.copyWith(
                fontSize: 15,
              ),
            ),
            SizedBox(width: defaultMargin / 2),
            Icon(
              Icons.circle,
              color: descGrey,
              size: 5,
            ),
            SizedBox(width: defaultMargin / 2),
            Text(
              widget.ticket.selectedTime,
              style: blackTextStyle.copyWith(
                fontSize: 15,
              ),
            ),
            SizedBox(width: defaultMargin / 2),
            Icon(
              Icons.circle,
              color: descGrey,
              size: 5,
            ),
            SizedBox(width: defaultMargin / 2),
            Text(
              widget.ticket.departureTime,
              style: blackTextStyle.copyWith(
                fontSize: 15,
              ),
            ),
          ],
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
                    Iconsax.location_tick,
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
                    Iconsax.location,
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
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: defaultMargin * 3),
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
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<TicketModels> fetchPaymentDetails(String bookingId) async {
    await dotenv.load(fileName: ".env.dev");
    final apiVercelUrl = dotenv.env['apiVercelGetTransactions']!;
    final url = '$apiVercelUrl/v1/$bookingId/status';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      return TicketModels.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat data transaksi');
    }
  }

  Widget _buildDetailsPrice() {
    return FutureBuilder<TicketModels>(
      future: fetchPaymentDetails(widget.ticket.bookingId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Skeletonizer(
            enabled: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('Status Pembayaran', 'Loading...'),
                _buildDetailItem('Total Pembayaran', 'Loading...'),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final ticket = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                'Status Pembayaran',
                ticket.transaction_status,
              ),
              _buildDetailItem(
                'Total Pembayaran',
                NumberFormat.currency(
                        locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                    .format(
                  double.parse(ticket.grossAmount),
                ),
              ),
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
      displayValue = 'Virtual Account';
    } else if (label == 'Status Pembayaran' && value == 'expire') {
      displayValue = 'Kedaluwarsa';
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
            '$label:',
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
    var formatter = DateFormat('EEEE, dd MMMM');
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

  Widget _buildDetailItemWithClipboard(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: subTitleTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.copy,
                size: 18,
                color: kPrimaryColor,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                showErrorFlushbar(
                  context,
                  "Virtual Disalin",
                  "No. Virtual Account berhasil disalin",
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
