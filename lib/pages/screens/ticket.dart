import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rents_cars_app/models/bookings.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../bloc/auth/bloc/auth_bloc.dart';
import '../../bloc/auth/bloc/auth_event.dart';
import '../../bloc/bookings/bloc/booking_bloc.dart';
import '../../bloc/bookings/bloc/booking_event.dart';
import '../../utils/fonts/constant.dart'; // Update this path
// Corrected import path for constants

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Request the current user
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
      appBar: _buildAppBar(context),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.read<BookingBloc>().add(FetchBookingsEvent(state.user!.id));
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: _buildBody(),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: kWhiteColor,
      title: Text(
        'Tiket', // Changed app bar title to 'Tiket'
        style: blackTextStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold, // Corrected FontWeight enum usage
        ),
      ),
      centerTitle: false,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingLoading) {
          return Center(
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 25.0,
            ),
          );
        } else if (state is BookingSuccess) {
          if (state.bookings.isEmpty) {
            return Center(child: Text('Belum ada booking'));
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount:
                state.bookings.length + 1, // +1 for additional information
            itemBuilder: (context, index) {
              if (index == 0) {
                return _otherInformations(); // Show additional information widget
              } else {
                final booking = state.bookings[index - 1];
                return _buildBookingCard(booking);
              }
            },
            padding: EdgeInsets.only(
              bottom: defaultMargin * 7,
            ), // Adjust bottom padding as needed
          );
        } else if (state is BookingError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Container(); // For other states or if there are no bookings
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
        color: kIcon,
        borderRadius: BorderRadius.circular(defaultRadius),
        border: Border.all(
          color: kIcon,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.info,
              color: kWhiteColor,
            ),
            SizedBox(
              width: defaultMargin,
            ), // Add some space between the icon and the text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Menampilkan semua riwayat perjalananmu selama 30 hari terakhir",
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingModels booking) {
    return Skeletonizer(
      enabled: isLoading,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: kWhiteColor,
        elevation: 0.5,
        child: Padding(
          padding: EdgeInsets.only(
            top: defaultMargin,
            bottom: defaultMargin,
          ),
          child: ListTile(
            title: Row(
              children: [
                Icon(
                  FontAwesomeIcons.car,
                  color: kIcon,
                ),
                SizedBox(
                  width: defaultMargin,
                ),
                Text(
                  booking.carFrom + ' - ' + booking.carTo,
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Container(
              margin: EdgeInsets.only(
                top: defaultMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatIndonesianDate(booking.carDate),
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    booking.carName + ' . ' + booking.carFrom,
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  // Add more properties of your booking model here
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Assuming booking.carDate is a DateTime object
  String formatIndonesianDate(DateTime date) {
    // Set the locale
    Intl.defaultLocale = 'id';
    // Define the date format
    var formatter = DateFormat('EEEE, dd MMMM yyyy . HH:mm');
    // Return the formatted date string
    return formatter.format(date);
  }
}
