import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../bloc/tickets/bloc/tickets_bloc.dart';
import '../../models/ticket.dart';
import '../../utils/fonts/constant.dart';

class TicketDetailScreen extends StatefulWidget {
  final TicketModels ticket;

  const TicketDetailScreen({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
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
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.ticket.carFrom} - ${widget.ticket.carTo}',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Order ID: ${widget.ticket.bookingId.toUpperCase()}',
            style: subTitleTextStyle.copyWith(
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
          ));
        } else if (state is TicketsSuccess) {
          if (state.tickets.isEmpty) {
            return Center(
                child: Text('Belum ada booking', style: blackTextStyle));
          }
          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _buildDetailsTravel(
                      lokasiJemput: widget.ticket.carFrom,
                      lokasiTujuan: widget.ticket.carTo,
                    ),
                  ),
                  SizedBox(height: defaultMargin),
                  Divider(
                    color: kBackgroundColor,
                    thickness: 5,
                  ),
                  SizedBox(height: defaultMargin),
                ],
              ),
            ),
          );
        } else if (state is TicketsError) {
          return Center(
              child: Text('Error: ${state.message}', style: blackTextStyle));
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
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
        SizedBox(height: defaultMargin),
        Text(
          "Dioperasikan oleh ${widget.ticket.ownerCar}",
          style: blackTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
        Text(
          formatIndonesianDate(widget.ticket.carDate),
          style: blackTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
        Text(
          "${widget.ticket.selectedPassengers.toString()} penumpang",
          style: blackTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
        // Update this with actual data
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
                    color: kIcon,
                    size: 18,
                  ),
                ),
                Container(
                  width: 2,
                  height: 50,
                  color: kBackgroundColor,
                ),
                CircleAvatar(
                  backgroundColor: kBackgroundColor,
                  child: Icon(
                    FontAwesomeIcons.locationDot,
                    color: kIcon,
                    size: 18,
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
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.ticket.selected_location_pick,
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: defaultMargin * 3),
                  Text(
                    widget.ticket.carTo,
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                  SizedBox(height: 5),
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
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: subTitleTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: blackTextStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  String formatIndonesianDate(DateTime date) {
    Intl.defaultLocale = 'id_ID'; // Ensure the locale is set to Indonesian
    var formatter = DateFormat('EEEE, dd MMMM yyyy');
    return formatter.format(date);
  }
}
