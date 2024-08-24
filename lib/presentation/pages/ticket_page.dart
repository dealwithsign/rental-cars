// presentation/pages/ticket_page.dart
import 'dart:convert';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/blocs/tickets/tickets_bloc.dart';

import 'package:skeletonizer/skeletonizer.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../data/models/ticket_model.dart';

import 'package:http/http.dart' as http;

import '../../utils/fonts.dart';
import '../widgets/context_menu.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetCurrentUserRequested());
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.read<TicketsBloc>().add(
                  FetchTransactionsUserEvent(state.user!.id),
                );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: _buildBody(),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      title: Text(
        'Tiket',
        style: titleTextStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return BlocBuilder<TicketsBloc, TicketsState>(
      builder: (context, state) {
        if (state is TicketsLoading) {
          return Center(
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 25.0,
            ),
          );
        } else if (state is TicketsSuccess) {
          if (state.tickets.isEmpty) {
            return Center(
              child: ContextMenu(
                title: 'Belum Ada Pesanan',
                message:
                    'Kamu belum memiliki pesanan tiket \nYuk pesan sekarang!',
                icon: FontAwesomeIcons.bell,
                kIconColor: kappBar,
                kPrimaryColor: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
                subTitleTextStyle: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            );
          }
          return RefreshIndicator(
            color: kPrimaryColor,
            backgroundColor: kBackgroundColor,
            onRefresh: () async {
              context.read<TicketsBloc>().add(
                    FetchTransactionsUserEvent(state.tickets.first.userId),
                  );
              await Future.delayed(const Duration(seconds: 5));
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.tickets.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _otherInformations();
                } else {
                  final booking = state.tickets[index - 1];
                  return _buildBookingCard(booking);
                }
              },
              padding: EdgeInsets.only(bottom: defaultMargin * 6),
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
      margin: EdgeInsets.only(
        top: defaultMargin,
        bottom: defaultMargin,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff018053),
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
              FontAwesomeIcons.circleInfo,
              color: kWhiteColor,
              size: 20,
            ),
            SizedBox(width: defaultMargin),
            Expanded(
              child: Text(
                'Semua transaksi yang sudah selesai tidak dapat diubah atau dibatalkan.',
                style: buttonColor.copyWith(
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

// Fungsi untuk mengambil detail pembayaran berdasarkan bookingId
  Future<TicketModels> fetchPaymentDetails(String bookingId) async {
    final response = await http.get(Uri.parse(
        'https://midtrans-fumjwv6jv-dealwithsign.vercel.app/v1/$bookingId/status'));

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      return TicketModels.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat detail pembayaran');
    }
  }

// Fungsi untuk membangun kartu pemesanan berdasarkan model tiket
  Widget _buildBookingCard(TicketModels ticket) {
    return FutureBuilder<TicketModels>(
      future: fetchPaymentDetails(ticket.bookingId),
      builder: (context, snapshot) {
        String status; // Variabel untuk menyimpan status tampilan
        Color statusColor; // Variabel untuk menyimpan warna status tampilan

        if (snapshot.connectionState == ConnectionState.waiting) {
          // Jika masih menunggu data, tampilkan status "Loading..."
          status = 'Loading...';
          statusColor = descGrey;
        } else if (snapshot.hasError) {
          // Jika terjadi kesalahan, tampilkan status error
          status = 'Error fetching status';
          statusColor = Colors.red;
        } else if (snapshot.hasData) {
          // Jika data berhasil diambil, periksa detail transaksi
          final details = snapshot.data!;
          if (details.transaction_status == 'pending') {
            // Jika status transaksi 'pending', tampilkan "Menunggu Pembayaran"
            status = 'Menunggu Pembayaran';
            statusColor = kPendingColor;
          } else if (details.transaction_status == 'settlement') {
            // Jika status transaksi 'settlement', tampilkan "E-Tiket telah terbit"
            status = 'E-Tiket telah terbit';
            statusColor = kSuccessColor;
          } else if (details.transaction_status.isEmpty) {
            // Jika status transaksi kosong, tampilkan "Menunggu Pembayaran"
            status = 'Dibatalkan';
            statusColor = descGrey;
          } else {
            // Jika tidak, tampilkan "Waktu Pembayaran Habis"
            status = 'Waktu Pembayaran Habis';
            statusColor = kFailedColor;
          }
        } else {
          // Jika data tidak tersedia, tampilkan status "No status available"
          status = 'No status available';
          statusColor = descGrey;
        }

        // Membuat tampilan kartu dengan status dan warna yang ditentukan
        return Skeletonizer(
          enabled: isLoading,
          child: GestureDetector(
            onTap: () {
              if (status == 'E-Tiket telah terbit') {
                // Jika status 'E-Tiket telah terbit', navigasi ke detail tiket
                Navigator.pushNamed(
                  context,
                  '/ticket-detail',
                  arguments: ticket,
                );
              } else if (status == 'Menunggu Pembayaran') {
                // Jika status 'Menunggu Pembayaran', navigasi ke halaman pembayaran
                Navigator.pushNamed(
                  context,
                  '/payment-page',
                  arguments: {
                    'redirectUrl': ticket.paymentLinks,
                    'token': ticket.bookingId,
                  },
                );
              } else if (status == 'Dibatalkan') {
                // Jika status 'Dibatalkan' atau 'Waktu Pembayaran Habis', tampilkan pesan batas waktu habis
                Flushbar(
                  flushbarPosition: FlushbarPosition.TOP,
                  flushbarStyle: FlushbarStyle.FLOATING,
                  duration: const Duration(seconds: 5),
                  backgroundColor: kPrimaryColor,
                  titleText: Text(
                    "Pesanan Dibatalkan",
                    style: buttonColor.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                  messageText: Text(
                    "Pesanan ini telah dibatalkan. Silakan pesan kembali.",
                    style: buttonColor.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  margin: EdgeInsets.only(
                    left: defaultMargin,
                    right: defaultMargin,
                    bottom: defaultMargin,
                  ),
                  borderRadius: BorderRadius.circular(defaultRadius),
                ).show(context);
              } else if (status == 'Waktu Pembayaran Habis') {
                // Jika status 'Dibatalkan' atau 'Waktu Pembayaran Habis', tampilkan pesan batas waktu habis
                Flushbar(
                  flushbarPosition: FlushbarPosition.TOP,
                  flushbarStyle: FlushbarStyle.FLOATING,
                  duration: const Duration(seconds: 5),
                  backgroundColor: kPrimaryColor,
                  titleText: Text(
                    "Waktu Pembayaran Habis",
                    style: buttonColor.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                  messageText: Text(
                    "Batas waktu pembayaran kamu telah habis.",
                    style: buttonColor.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  margin: EdgeInsets.only(
                    left: defaultMargin,
                    right: defaultMargin,
                    bottom: defaultMargin,
                  ),
                  borderRadius: BorderRadius.circular(defaultRadius),
                ).show(context);
              } else {
                // Jika status lainnya, navigasi ke halaman pembayaran
                Navigator.pushNamed(
                  context,
                  '/payment-page',
                  arguments: {
                    'redirectUrl': ticket.paymentLinks,
                    'token': ticket.bookingId,
                  },
                );
              }
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: defaultMargin),
              clipBehavior: Clip.antiAlias,
              color: kWhiteColor,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultRadius),
                side: BorderSide(
                  color: kDivider,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(defaultMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ID ${ticket.bookingId.toUpperCase()}",
                      style: subTitleTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: defaultMargin,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${ticket.carFrom} - ${ticket.carTo}',
                            style: titleTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          LineIcons.angleRight,
                          color: kPrimaryColor,
                          size: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: defaultMargin / 2),
                    Text(
                      formatIndonesianDate(ticket.carDate),
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      ticket.carName,
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: defaultMargin / 2),
                    Divider(
                      color: kDivider,
                      thickness: 1,
                    ),
                    SizedBox(height: defaultMargin),
                    Text(
                      status,
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String formatIndonesianDate(DateTime date) {
    Intl.defaultLocale = 'id_ID';
    var formatter = DateFormat('EEEE, dd MMMM yyyy');
    return formatter.format(date);
  }
}
