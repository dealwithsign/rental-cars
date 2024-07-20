import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rents_cars_app/bloc/auth/bloc/auth_event.dart';
import 'package:rents_cars_app/models/bookings.dart';
import 'package:rents_cars_app/models/cars.dart';
import 'package:rents_cars_app/models/users.dart';
import 'package:rents_cars_app/utils/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../bloc/auth/bloc/auth_bloc.dart';
import '../../bloc/bookings/bloc/booking_bloc.dart';
import '../../bloc/bookings/bloc/booking_event.dart';
import '../../services/bookings/booking_services.dart';
import '../../services/cars/cars_services.dart';
import '../../services/users/auth_services.dart';
import '../../utils/fonts/constant.dart';
import '../../utils/widgets/button_cancle.dart';

class DetailBookingPage extends StatefulWidget {
  final CarsModels carModel;
  final DateTime selectedDate;
  final String selectedTime;
  final int selectedPassengers;
  final String selectedLocationPick;
  final String selectedLocationDrop; // Add this line

  final int phone_number;
  final String carFrom;
  final String carTo;
  final DateTime carDate;

  const DetailBookingPage({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedPassengers,
    required this.selectedLocationPick,
    required this.selectedLocationDrop, // Add this line

    required this.carModel,
    required this.phone_number,
    required this.carFrom,
    required this.carTo,
    required this.carDate,
  });

  @override
  State<DetailBookingPage> createState() => _DetailBookingPageState();
}

class _DetailBookingPageState extends State<DetailBookingPage> {
  late String selectedDate;
  late String selectedTime;
  late String selectedPassengers;
  late String selectedLocationPick;
  late String selectedLocationDrop;

  late String phone_number;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize state variables
    selectedDate = DateFormat('dd MMMM yyyy').format(widget.selectedDate);
    selectedTime = widget.selectedTime;
    selectedPassengers = '${widget.selectedPassengers} Orang';
    selectedLocationPick = widget.selectedLocationPick;
    selectedLocationDrop = widget.selectedLocationDrop;

    phone_number = widget.phone_number.toString();
    context.read<AuthBloc>().add(GetCurrentUserRequested());
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _showConfirmationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: kWhiteColor,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(defaultRadius),
              topRight: Radius.circular(defaultRadius),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center children vertically
                children: [
                  SizedBox(height: defaultMargin),
                  Text(
                    'Batalkan pesanan ini?',
                    textAlign: TextAlign.center, // Center text horizontally
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Kembali ke halaman sebelumnya, lokasi, jumlah penumpang dan data yang sudah diisi akan hilang.',
                    textAlign: TextAlign.center, // Center text horizontally
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: defaultMargin),
                  Expanded(
                    // Make the buttons fill the available space
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButtonCancel(
                          title: "Lihat Halaman Sebelumnya",
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove('selectedPassengers');
                            prefs.remove('selectedLocationPick');
                            prefs.remove('selectedLocationDrop');
                            Navigator.of(context)
                                .pop(); // Close the bottom sheet
                            Navigator.of(context)
                                .pop(); // Go back to the previous page
                          },
                        ),
                        SizedBox(height: defaultMargin),
                        CustomButton(
                          title: "Lanjut Bayar",
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        surfaceTintColor: kWhiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => _showConfirmationBottomSheet(context),
        ),
        title: Text(
          'Detail Pesanan',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: _otherInformations(),
            ),
            SizedBox(height: defaultMargin),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          // User is authenticated, display the content
          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _buildCarDetail(),
                  ),
                  SizedBox(height: defaultMargin),
                  Divider(
                    color: kBackgroundColor,
                    thickness: 5,
                  ),
                  SizedBox(height: defaultMargin),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _buildDetailsTravel(
                      lokasiJemput: selectedLocationPick,
                      lokasiTujuan: selectedLocationDrop,
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
                    child: _buildUserProfile(state.user!),
                  ),
                  SizedBox(height: defaultMargin),
                  Divider(
                    color: kBackgroundColor,
                    thickness: 5,
                  ),
                  SizedBox(height: defaultMargin),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _buildDetailsPrice(),
                  ),
                  SizedBox(height: defaultMargin * 2),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: CustomButton(
                      title: "Lanjut Bayar",
                      onPressed: () async {
                        final int carPrice =
                            int.parse(widget.carModel.carPrice);
                        final int totalPriceWithoutAdmin =
                            carPrice * widget.selectedPassengers;
                        const int adminFee = 12000;
                        final int totalPayment =
                            totalPriceWithoutAdmin + adminFee;
                        var uui = Uuid();
                        String ticketId = uui.v4().substring(0, 8);
                        print('Ticket ID: $ticketId');
                        // mapping
                        Map<String, dynamic> data = {
                          "transaction_details": {
                            "order_id": ticketId,
                            "gross_amount": totalPayment,
                            "payment_link_id": widget.carModel.carName,
                          },
                          "credit_card": {"secure": true},
                          "customer_details": {
                            "first_name": state.user!.username,
                            "last_name": "",
                            "email": state
                                .user!.email, // Use email from AuthCubit state
                            "phone": state.user!.phone_number
                                .toString(), // Use phoneNumber from AuthCubit state
                            "notes": "Pembayaran sewa mobil",
                          },
                          "expiry": {"duration": 1, "unit": "month"},
                          "usage_limit": 1,
                          "item_details": [
                            {
                              "id": widget.carModel.id,
                              "price": carPrice,
                              "quantity": widget
                                  .selectedPassengers, // Use selectedPassengers from widget
                              "name": widget.carModel.carName,
                            }
                          ]
                        };
                        print('Data sent to API: $data');
                        var response = await http.post(
                          Uri.parse(
                              "https://eed1-110-137-194-43.ngrok-free.app/v1/payment-links" // api postan
                              ),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(data),
                        );
                        print('Server response: ${response.body}');
                        print(
                            'Server response status code: ${response.statusCode}');
                        print(
                            'Server response status message: ${response.reasonPhrase}');
                        print('Server response headers: ${response.headers}');
                        if (response.statusCode == 200) {
                          try {
                            var result = jsonDecode(response.body);
                            print('Payment link created: $result');
                            String token = result['token'];
                            String redirectUrl = result['redirect_url'];
                            print(token);
                            print(redirectUrl);
                            print('Payment link created: $result');
                            var paymentUrl = result['payment_url'];
                            print('Payment URL: $paymentUrl');
                          } catch (e) {
                            print('Error creating payment link: $e');
                          }
                        } else {
                          print('Failed to create payment link');
                        }
                      },
                    ),
                  ),
                  SizedBox(height: defaultMargin * 2),
                ],
              ),
            ),
          );
        } else if (state is AuthFailure) {
          // User is not authenticated, display a login prompt or similar
          return const Center(
            child: Text("Please log in to continue"),
          );
        } else {
          // Loading or initial state, adjust according to your needs
          return Center(
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 25.0,
            ),
          );
        }
      },
    );
  }

  Widget _buildUserProfile(UserModel user) {
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detail Pemesan',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: defaultMargin),
              Text(
                user.username,
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
              ),
              Text(
                user.phone_number.toString().startsWith('0')
                    ? user.phone_number.toString()
                    : '0${user.phone_number}',
                style: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              Text(
                user.email,
                style: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Informasi Penting",
              style: whiteTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: defaultMargin),
            Text(
              "Pastikan data yang kamu masukkan sudah benar, sebelum ke halaman pembayaran.",
              style: whiteTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsPrice() {
    // Parse carPrice to int and calculate total car price
    final int carPrice = int.parse(widget.carModel.carPrice);
    final int totalPriceWithoutAdmin = carPrice * widget.selectedPassengers;
    // Assuming adminFee is a constant 50000
    const int adminFee = 12000;
    // Calculate total price including admin fee
    final int totalPrice = totalPriceWithoutAdmin + adminFee;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Pembayaran',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: defaultMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp ${widget.carModel.carPrice} x ${widget.selectedPassengers} Orang',
                style: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              Text(
                // Calculate the car price and the selected passengers, then format the result
                'Rp ${NumberFormat("#,##0", "id_ID").format(totalPriceWithoutAdmin)}',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Biaya Admin',
                style: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              Text(
                'Rp ${NumberFormat("#,##0", "id_ID").format(adminFee)}',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
            color: kDividerColor,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Harga',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                // Format the total price including admin fee
                'Rp ${NumberFormat("#,##0", "id_ID").format(totalPrice)}',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarDetail() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                defaultRadius,
              ), // Set border radius as needed
              // Add other decoration properties if needed, like boxShadow, border, etc.
            ),
            clipBehavior: Clip
                .antiAlias, // This clips the child within the decoration's border
            child: Image.network(
              widget.carModel.carLogo,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: defaultMargin),
        Expanded(
          // Optionally wrap the Column in an Expanded widget if necessary
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMMM yyyy').format(widget.carDate),
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
              ),
              Text(
                widget.carModel.carName,
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.carFrom + ' - ' + widget.carTo,
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
              ),
              SizedBox(height: defaultMargin),
              Text(
                "Disediakan oleh ${widget.carModel.ownerCar}",
                style: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTravel({
    required String lokasiJemput,
    required String lokasiTujuan,
  }) {
    final double defaultMargin = 16.0;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail perjalanan',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: defaultMargin),
          _buildDetailItem('Waktu', selectedTime),
          _buildDetailItem('Jumlah Penumpang', selectedPassengers),
          SizedBox(height: defaultMargin),
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
                    height: 80,
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
                      'Lokasi jemput',
                      style: subTitleTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      lokasiJemput,
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: defaultMargin),
                    Text(
                      'Lokasi tujuan',
                      style: subTitleTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lokasiTujuan,
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
}
