// presentation/pages/car_book_page.dart
// ignore_for_file: avoid_single_cascade_in_expression_statements, prefer_const_constructors// ignore_for_file: avoid_single_cascade_in_expression_statements, prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rents_cars_app/blocs/auth/auth_event.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:http/http.dart' as http;
import '../../blocs/auth/auth_bloc.dart';

import '../../blocs/bookings/booking_bloc.dart';

import '../../blocs/bookings/booking_event.dart';
import '../../data/models/cars_model.dart';
import '../../data/models/users_model.dart';
import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';
import '../widgets/button_cancle_widget.dart';
import '../widgets/flushbar_widget.dart';
import 'midtrans_page.dart';

class DetailBookingPage extends StatefulWidget {
  final CarsModels carModel;
  final DateTime selectedDate;
  final String selectedTime;
  final int selectedPassengers;
  final String selectedLocationPick;
  final String selectedLocationDrop; // Add this line
  final String id;
  final String specialRequest;

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
    required this.specialRequest,
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
  late String specialRequest;
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
    specialRequest = widget.specialRequest;
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
            color: kWhiteColor,
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
                    'Batalkan pesanan ini ?',
                    textAlign: TextAlign.center, // Center text horizontally
                    style: blackTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: defaultMargin / 2),
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
                            prefs.remove('specialRequest');
                            Navigator.of(context)
                                .pop(); // Close the bottom sheet
                            Navigator.of(context)
                                .pop(); // Go back to the previous page
                          },
                        ),
                        SizedBox(height: defaultMargin),
                        CustomButton(
                          title: "Lanjut Bayar",
                          onPressed: () {
                            Navigator.pop(context); // Close the bottom sheet
                          },
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
          icon: Icon(
            Iconsax.arrow_left_2,
            color: kPrimaryColor,
          ),
          onPressed: () => _showConfirmationBottomSheet(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Pesanan',
              style: titleTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Order ID: ${widget.id.toUpperCase()}",
              style: blackTextStyle.copyWith(
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
                  Container(
                    padding: EdgeInsets.symmetric(vertical: defaultMargin),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      border: Border(
                          top: BorderSide(color: kBackgroundColor, width: 2.5)),
                    ),
                    child: Padding(
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
                                            "Mohon tunggu",
                                            style: blackTextStyle.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: defaultMargin / 2),
                                        Center(
                                          child: Text(
                                            "Sedang mengarahkan \nke halaman pembayaran...",
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
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

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
                                  showErrorFlushbar(
                                    context,
                                    "Pembayaran Gagal",
                                    "Terjadi kesalahan saat melakukan pembayaran.",
                                  );
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
                  ),
                  Padding(padding: EdgeInsets.only(bottom: defaultMargin)),
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
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
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
    // for supabase table
    final int carPrice = int.parse(widget.carModel.carPrice);
    final int totalPriceWithoutAdmin =
        carPrice * widget.selectedPassengers + 17500;
    final int totalPayment = totalPriceWithoutAdmin;

    await dotenv.load(fileName: ".env.dev");
    final apiVercelUrl = dotenv.env['apiVercelUrl']!;
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
    final String carId = widget.carModel.id;
    print('Mengirim request ke API Midtrans...');
    Map<String, dynamic> data = {
      "transaction_details": {
        "order_id": orderId,
        "gross_amount": totalPayment, // Updated to include 17500
        "payment_link_id": widget.carModel.carName,
      },
      "credit_card": {"secure": true},
      "customer_details": {
        "first_name": userName,
        "last_name": "",
        "email": userEmail,
        "phone": userPhone,
        "notes": "Pemesanan Tiket Sewa Mobil",
      },
      "expiry": {"duration": 30, "unit": "minutes"},
      "usage_limit": 1,
      "item_details": [
        {
          "id": widget.carModel.id,
          "price": carPrice,
          "quantity": widget.selectedPassengers,
          "name": widget.carModel.carName,
        },
        {
          "id": "cost_service",
          "price": 7500,
          "quantity": 1,
          "name": "Biaya Pemesanan",
        },
        {
          "id": "admin_fee",
          "price": 10000,
          "quantity": 1,
          "name": "Biaya Jasa",
        }
      ]
    };

    print('Request ke API Midtrans...');
    var response = await http.post(
      Uri.parse(apiVercelUrl),
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
              carId: carId,
              totalPayment: totalPayment,
              specialRequest: specialRequest,
              departureTime: widget.carModel.carTimeDateFrom,
              userEmail: userEmail,
              userPhoneNumber: userPhone,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Pemesan',
                  style: titleTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: defaultMargin),
                Text(
                  user.username,
                  style: blackTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: defaultMargin,
                ), //
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
              Iconsax.info_circle,
              color: kWhiteColor,
              size: 20,
            ),
            SizedBox(width: defaultMargin),
            Expanded(
              child: Text(
                'Sebelum melanjutkan ke pembayaran, pastikan data pemesanan sudah benar',
                style: buttonColor.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
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
    const int costService = 7500;
    const int adminFee = 10000; // Make this a

    // Calculate total price including admin fee
    final int totalPrice = totalPriceWithoutAdmin + adminFee + costService;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Pembayaran',
            style: titleTextStyle.copyWith(
              fontSize: 18,
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
          SizedBox(height: defaultMargin / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Biaya Pemesanan',
                style: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              Text(
                'Rp ${NumberFormat("#,##0", "id_ID").format(costService)}',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: defaultMargin / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Biaya Jasa ',
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
          SizedBox(height: defaultMargin / 2),
          Divider(
            color: kDivider,
            thickness: 1,
          ),
          SizedBox(height: defaultMargin / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pembayaran',
                style: blackTextStyle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                // Format the total price including admin fee
                'Rp ${NumberFormat("#,##0", "id_ID").format(totalPrice)}',
                style: blackTextStyle.copyWith(
                  fontSize: 15,
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
              height: MediaQuery.of(context).size.height * 0.13,
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
                '${widget.carFrom} - ${widget.carTo}',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
              Text(
                DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(widget.carDate),
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
              ),
              SizedBox(width: defaultMargin / 2),
              Text(
                'Jam ${widget.carModel.carTimeDateFrom}',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
              ),
              SizedBox(height: defaultMargin),
              Text(
                widget.carModel.carName,
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              Text(
                widget.carModel.carClass,
                style: blackTextStyle.copyWith(
                  fontSize: 14,
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
    const double defaultMargin = 18.0;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detail Perjalanan',
                style: titleTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
                      'Lokasi jemput',
                      style: subTitleTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: defaultMargin / 2),
                    Text(
                      lokasiJemput,
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: defaultMargin * 2),
                    Text(
                      'Lokasi tujuan',
                      style: subTitleTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: defaultMargin / 2),
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
          SizedBox(height: defaultMargin * 2),
          _buildDetailItem(
            'Permintaan Khusus',
            specialRequest.isEmpty
                ? 'Tidak ada permintaan khusus'
                : specialRequest,
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
        SizedBox(height: defaultMargin / 2),
        Text(
          value,
          style: blackTextStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: defaultMargin),
      ],
    );
  }
}
