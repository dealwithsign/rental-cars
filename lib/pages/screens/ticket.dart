import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rents_cars_app/bloc/tickets/bloc/tickets_bloc.dart';
import 'package:rents_cars_app/models/bookings.dart';
import 'package:rents_cars_app/models/ticket.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../bloc/auth/bloc/auth_bloc.dart';
import '../../bloc/auth/bloc/auth_event.dart';
import '../../utils/fonts/constant.dart';
import 'package:http/http.dart' as http;

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

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
        style: blackTextStyle.copyWith(
          fontSize: 18,
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
              size: 25,
            ),
          );
        } else if (state is TicketsSuccess) {
          if (state.tickets.isEmpty) {
            return Center(
              child: Text('Belum ada booking', style: blackTextStyle),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TicketsBloc>().add(
                    FetchTransactionsUserEvent(state.tickets.first.userId),
                  );
              await Future.delayed(const Duration(seconds: 2));
            },
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: state.tickets.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _otherInformations();
                } else {
                  final booking = state.tickets[index - 1];
                  return _buildBookingCard(booking);
                }
              },
              padding: EdgeInsets.only(bottom: defaultMargin * 7),
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
      margin: EdgeInsets.symmetric(vertical: defaultMargin),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: kIcon,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: kWhiteColor),
          SizedBox(width: defaultMargin),
          Expanded(
            child: Text(
              "Semua tiket sewa mobil yang sudah aktif dan menunggu pembayaran akan muncul di sini.",
              style: whiteTextStyle.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
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

  Widget _buildBookingCard(TicketModels ticket) {
    // Convert UTC time to local time

    return FutureBuilder<TicketModels>(
      future: fetchPaymentDetails(ticket.bookingId),
      builder: (context, snapshot) {
        String status;
        Color statusColor;

        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data
          status = 'Loading...';
          statusColor = Colors.grey;
        } else if (snapshot.hasError) {
          // Error occurred while fetching data
          status = 'Error fetching status';
          statusColor = Colors.red;
        } else if (snapshot.hasData) {
          // Data successfully fetched
          final details = snapshot.data!;
          switch (details.transaction_status) {
            case 'settlement':
              status = 'Selesai';
              statusColor = Colors.green;
              break;
            case 'pending':
              status = 'Menunggu Pembayaran';
              statusColor = Colors.red;
              break;
            case 'expire':
              status = 'Dibatalkan';
              statusColor = Colors.grey;
              break;
            default:
              status = 'Unknown Status';
              statusColor = Colors.orange;
          }
        } else {
          // No data
          status = 'No status available';
          statusColor = Colors.orange;
        }

        return Skeletonizer(
          enabled: isLoading,
          child: GestureDetector(
            onTap: () {
              // Navigate based on status
              if (status == 'Selesai') {
                Navigator.pushNamed(context, '/ticket-detail',
                    arguments: ticket);
              } else if (status == 'Menunggu Pembayaran') {
                Navigator.pushNamed(context, '/payment-page', arguments: {
                  'redirectUrl': ticket.paymentLinks,
                  'token': ticket.bookingId,
                });
              }
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: defaultMargin),
              clipBehavior: Clip.antiAlias,
              color: kWhiteColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultRadius),
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
                    SizedBox(height: defaultMargin),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.carSide, color: kIcon),
                        SizedBox(width: defaultMargin),
                        Expanded(
                          child: Text(
                            '${ticket.carFrom} - ${ticket.carTo}',
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.chevronRight,
                          color: kIcon,
                          size: 15,
                        ),
                      ],
                    ),
                    SizedBox(height: defaultMargin / 2),
                    Text(
                      formatIndonesianDate(ticket.carDate),
                      style: subTitleTextStyle.copyWith(fontSize: 14),
                    ),
                    Text(ticket.carName,
                        style: subTitleTextStyle.copyWith(fontSize: 14)),
                    SizedBox(height: defaultMargin / 2),
                    Text(
                      status,
                      style: subTitleTextStyle.copyWith(
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
