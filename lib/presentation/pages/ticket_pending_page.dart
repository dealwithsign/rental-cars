// presentation/pages/ticket_pending_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rents_cars_app/presentation/pages/midtrans_page.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:http/http.dart' as http;

import '../../blocs/tickets/tickets_bloc.dart';
import '../../data/models/ticket_model.dart';
import '../../utils/fonts.dart';
import '../widgets/flushbar_widget.dart';

class TicketPendingPage extends StatefulWidget {
  final TicketModels ticket;

  const TicketPendingPage({super.key, required this.ticket});

  @override
  State<TicketPendingPage> createState() => _TicketPendingPageState();
}

class _TicketPendingPageState extends State<TicketPendingPage> {
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
      body: BlocListener<TicketsBloc, TicketsState>(
        listener: (context, state) {
          if (state is TicketsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: _buildCarDetails(),
      ),
    );
  }

  Widget _buildCarDetails() {
    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: kWhiteColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Iconsax.arrow_left_2,
                color: kPrimaryColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildCarImage(),
            ),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildBody(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarImage() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(),
          child: ClipRRect(
            child: Image.network(widget.ticket.carImage, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionDivider() {
    return const Divider(color: Color(0XFFEBEBEB), thickness: 1);
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
                  _buildSectionDivider(),
                  SizedBox(height: defaultMargin),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Pembayaran',
                          style: titleTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: bold,
                          ),
                        ),
                        SizedBox(height: defaultMargin),
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
        color: const Color(0xffFEEFC3),
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
                'Mohon dibayarkan sebelum waktu pembayaranmu kedaluwarsa untuk menghindari pembatalan pesanan',
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

  Widget _buildDetailsTravel({
    required String lokasiJemput,
    required String lokasiTujuan,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order ID: ${widget.ticket.bookingId.toUpperCase()}',
            style: subTitleTextStyle.copyWith(
              fontSize: 14,
              fontWeight: bold,
            )),
        SizedBox(height: defaultMargin / 2),
        Text(
          widget.ticket.carName,
          style: titleTextStyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
        Text(
          "Dioperasikan oleh ${widget.ticket.ownerCar}",
          style: subTitleTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
        SizedBox(height: defaultMargin),
        Row(
          children: [
            Text(
              DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                  .format(widget.ticket.carDate),
              style: blackTextStyle.copyWith(
                fontSize: 15,
                fontWeight: bold,
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
                fontWeight: bold,
              ),
            ),
          ],
        ),
        SizedBox(height: defaultMargin / 2),
        Text(
          "${widget.ticket.selectedPassengers} penumpang",
          style: blackTextStyle.copyWith(
            fontSize: 15,
            fontWeight: bold,
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
                    color: kGreyColor,
                    size: 20,
                  ),
                ),
                Container(
                  width: 1,
                  height: 100,
                  color: kBackgroundColor,
                ),
                CircleAvatar(
                  backgroundColor: kBackgroundColor,
                  child: Icon(
                    Iconsax.location,
                    color: kGreyColor,
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
                    "Kota Asal",
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                  SizedBox(height: defaultMargin / 2),
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
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: defaultMargin * 3),
                  Text(
                    "Kota Tujuan",
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                  SizedBox(height: defaultMargin / 2),
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
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: defaultMargin),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: kBackgroundColor,
              child: Icon(
                Iconsax.document,
                color: kGreyColor,
                size: 20,
              ),
            ),
            SizedBox(width: defaultMargin),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: defaultMargin),
                  Text(
                    "Permintaan Khusus",
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                  SizedBox(height: defaultMargin / 2),
                  Text(
                    widget.ticket.specialRequest,
                    style: blackTextStyle.copyWith(
                      fontSize: 15,
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
                _buildDetailItem('Nomor Transaksi', 'Loading...'),
                _buildDetailItem('Status Pembayaran', 'Loading...'),
                _buildDetailItem('Metode Pembayaran', 'Loading...'),
                _buildDetailItem('Bayar Sebelum', 'Loading...'),
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
                'Nomor Transaksi',
                ticket.transactionId,
              ),
              _buildDetailItem(
                'Status Pembayaran',
                ticket.transaction_status,
              ),
              _buildDetailItem(
                'Metode Pembayaran',
                ticket.paymentType,
              ),
              _buildDetailItem(
                'Bayar Sebelum',
                formatIndonesianDatePayments(ticket.expiry_time),
              ),
              _buildDetailItem(
                'Total Pembayaran',
                NumberFormat.currency(
                        locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                    .format(
                  double.parse(ticket.grossAmount),
                ),
              ),
              SizedBox(height: defaultMargin),
              CustomButton(
                title: "Bayar Sekarang",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MidtransPayment(
                        redirectUrl: widget.ticket.paymentLinks,
                        token: ticket.transactionId,
                      ),
                    ),
                  );
                },
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
      displayValue = 'Transfer Bank';
    } else if (label == 'Status Pembayaran' && value == 'pending') {
      displayValue = 'Menunggu Pembayaran';
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
              fontSize: 15,
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
    var formatter = DateFormat('EEEE, dd MMMM ');
    return formatter.format(date);
  }

  String formatIndonesianDatePayments(DateTime date) {
    Intl.defaultLocale = 'id_ID'; // Ensure the locale is set to Indonesian
    var formatter = DateFormat('EEEE, dd MMMM \'Jam\' HH:mm');
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
