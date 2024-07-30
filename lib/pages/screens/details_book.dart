// ignore_for_file: avoid_single_cascade_in_expression_statements, prefer_const_constructors

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
import 'package:rents_cars_app/pages/screens/midtrans/midtrans_page.dart';
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
  final String id;

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
    required this.carFrom,
    required this.carTo,
    required this.carDate,
    required this.id,
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
  late String orderId;

  late String phone_number;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize state variables
    orderId = widget.id;
    selectedDate = DateFormat('dd MMMM yyyy').format(widget.selectedDate);
    selectedTime = widget.selectedTime;
    selectedPassengers = '${widget.selectedPassengers} Orang';
    selectedLocationPick = widget.selectedLocationPick;
    selectedLocationDrop = widget.selectedLocationDrop;

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
                            prefs.remove('selectedTime');
                            prefs.remove('selectedDate');
                            prefs.remove('orderId');
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Pesanan',
              style: blackTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Order ID: ${widget.id.toUpperCase()}",
              style: subTitleTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ],
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
                        // Tampilkan dialog loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: defaultMargin * 5),
                                  padding: EdgeInsets.all(defaultMargin),
                                  decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius:
                                        BorderRadius.circular(defaultRadius),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SpinKitThreeBounce(
                                        color: kPrimaryColor,
                                        size: 25.0,
                                      ),
                                      SizedBox(height: defaultMargin),
                                      Center(
                                        child: Text(
                                          "Mohon tunggu...",
                                          style: blackTextStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Center(
                                        child: Text(
                                          "Sedang mengarahkan ke halaman pembayaran.",
                                          textAlign: TextAlign.center,
                                          style: subTitleTextStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                        try {
                          await _handlePayment(
                            context,
                            state.user!,
                            (success, token, redirectUrl) async {
                              Navigator.of(context, rootNavigator: true).pop();

                              if (success) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MidtransPayment(
                                      redirectUrl: redirectUrl,
                                      token: token,
                                    ),
                                  ),
                                );
                              } else {
                                Flushbar(
                                  flushbarPosition: FlushbarPosition.TOP,
                                  flushbarStyle: FlushbarStyle.FLOATING,
                                  duration: const Duration(seconds: 5),
                                  backgroundColor: kflushBackError,
                                  titleText: Text(
                                    "Transaksi gagal",
                                    style: redTextStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: bold,
                                    ),
                                  ),
                                  messageText: Text(
                                    "Mobil yang kamu pesan tidak tersedia. Silakan coba lagi.",
                                    style: redTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: defaultMargin,
                                    right: defaultMargin,
                                    bottom: defaultMargin,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(defaultRadius),
                                ).show(context);
                              }
                            },
                          );
                        } catch (e) {
                          Navigator.of(context, rootNavigator: true).pop();
                          print('Error: $e');
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
          return const Center(
            child: Text("Silakan login untuk melanjutkan"),
          );
        } else {
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

  Future<void> _handlePayment(
    BuildContext context,
    UserModel user,
    void Function(bool, String, String) onResult,
  ) async {
    final int carPrice = int.parse(widget.carModel.carPrice);
    final int totalPriceWithoutAdmin = carPrice * widget.selectedPassengers;
    const int adminFee = 12000;
    final int totalPayment = totalPriceWithoutAdmin + adminFee;

    BookingServices bookingServices = BookingServices();
    // data to be saved
    final String orderId = widget.id;
    final String userId = user.id;
    final String userName = user.username;
    final String userEmail = user.email;
    final String formattedUserPhone =
        user.phone_number.toString().startsWith('0')
            ? user.phone_number.toString()
            : '0${user.phone_number}';
    final String userPhone = formattedUserPhone;
    final String ownerCar = widget.carModel.ownerCar;
    final String selectedLocationPick = widget.selectedLocationPick;
    final String selectedLocationDrop = widget.selectedLocationDrop;

    // services
    print('Membuat tiket rental...');
    await bookingServices.saveBookingData(
      id: orderId,
      carModel: widget.carModel,
      selectedDate: widget.selectedDate,
      selectedTime: widget.selectedTime,
      selectedPassengers: widget.selectedPassengers,
      selectedLocationPick: widget.selectedLocationPick,
      selectedLocationDrop: widget.selectedLocationDrop,
      carFrom: widget.carFrom,
      carTo: widget.carTo,
      carDate: widget.carDate,
      userId: userId,
      userName: userName,
      userPhone: userPhone,
      userEmail: userEmail,
      totalPayment: totalPayment,
      isPayment: false,
    );
    print('Tiket bus berhasil dibuat.');

    Map<String, dynamic> data = {
      "transaction_details": {
        "order_id": orderId,
        "gross_amount": widget.selectedPassengers * carPrice,
        "payment_link_id": widget.carModel.carName,
      },
      "credit_card": {"secure": true},
      "customer_details": {
        "first_name": userName,
        "last_name": "",
        "email": userEmail,
        "phone": userPhone,
        "notes": "Pemesanan sewa mobil",
      },
      "expiry": {"duration": 1, "unit": "hours"},
      "usage_limit": 1,
      "item_details": [
        {
          "id": widget.carModel.id,
          "price": carPrice,
          "quantity": widget.selectedPassengers,
          "name": widget.carModel.carName,
        }
      ]
    };

    print('Request ke API Midtrans...');
    var response = await http.post(
      Uri.parse(
          "https://midtrans-fumjwv6jv-dealwithsign.vercel.app/v1/payment-links"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    print('Server response: ${response.body}');

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      String token = responseData['token'];
      String redirectUrl = responseData['redirect_url'];

      context.read<BookingBloc>().add(
            CreatePaymentUrl(
              token: token,
              redirectUrl: redirectUrl,
              orderId: orderId,
              userId: userId,
              userName: userName,
              cityFrom: widget.carFrom,
              cityTo: widget.carTo,
              carName: widget.carModel.carName,
              carDate: widget.carDate,
              seletedTime: widget.selectedTime,
              selectedPassengers: widget.selectedPassengers,
              ownerCar: ownerCar,
              selectedLocationPick: selectedLocationPick,
              selectedLocationDrop: selectedLocationDrop,
            ),
          );

      onResult(
          true, token, redirectUrl); // Menandakan bahwa pembayaran berhasil
    } else {
      print('Error: ${response.body}');
      onResult(false, "", ""); // Menandakan bahwa pembayaran gagal
    }
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
              "Sebelum melanjutkan pembayaran, pastikan datamu sudah benar. Tidak bisa diubah setelah pembayaran dilakukan.",
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
            color: kDivider,
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
