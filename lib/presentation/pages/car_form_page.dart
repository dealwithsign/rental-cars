// presentation/pages/car_form_page.dart

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uuid/uuid.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';

import '../../data/models/bookings_model.dart';
import '../../data/models/cars_model.dart';
import '../../data/models/users_model.dart';
import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';
import '../widgets/flushbar_widget.dart';
import 'car_book_page.dart';
import 'drop_maps_page.dart';
import 'pick_maps_page.dart';

class BookWithDriverPage extends StatefulWidget {
  final CarsModels car;
  final String carFrom;
  final String carTo;
  final DateTime carDate;

  final int availableSeats;
  const BookWithDriverPage({
    super.key,
    required this.car,
    required this.carFrom,
    required this.carTo,
    required this.carDate,
    required this.availableSeats,
  });

  @override
  State<BookWithDriverPage> createState() => _BookWithDriverPageState();
}

class _BookWithDriverPageState extends State<BookWithDriverPage> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = 'Sore';
  String selectedPassengers = '1 Orang';
  String _selectedLocationPick = '';
  String _selectedLocationDrop = '';
  String _departureTime = '';
  String specialRequest = '';
  BookingModels? bookingModels;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specialRequestController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load previously saved values from SharedPreferences (if any)
    loadSavedData();
    context.read<AuthBloc>().add(GetCurrentUserRequested());
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        // Load saved values
        selectedDate = prefs.containsKey('selectedDate')
            ? DateTime.parse(prefs.getString('selectedDate')!)
            : DateTime.now(); // Default to current date/time if not saved
        selectedTime = prefs.getString('selectedTime') ?? selectedTime;
        selectedPassengers =
            prefs.getString('selectedPassengers') ?? selectedPassengers;
        _selectedLocationPick = prefs.getString('selectedLocationPick') ?? '';
        _selectedLocationDrop = prefs.getString('selectedLocationDrop') ?? '';
        specialRequest = prefs.getString('specialRequest') ?? '';
        _phoneController.text = prefs.getString('phone') ?? '';
        _departureTime = prefs.getString('departureTime') ?? '';
      },
    );
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedDate', selectedDate.toString());
    prefs.setString('selectedTime', selectedTime);
    prefs.setString('selectedPassengers', selectedPassengers);
    prefs.setString('selectedLocationPick', _selectedLocationPick);
    prefs.setString('selectedLocationDrop', _selectedLocationDrop);
    prefs.setString('phone', _phoneController.text);
    prefs.setString('specialRequest', _specialRequestController.text);
    prefs.setString('departureTime', _departureTime);
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: kWhiteColor,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          surfaceTintColor: kWhiteColor,
          backgroundColor: kWhiteColor,
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
                'Selesaikan Pesananmu',
                style: titleTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          elevation: 0,
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          );
        } else if (state is AuthSuccess) {
          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _buildDetailCarBooking(),
                  ),
                  SizedBox(height: defaultMargin),
                  Divider(
                    color: kBackgroundColor,
                    thickness: 5,
                  ),
                  SizedBox(height: defaultMargin),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _buildPickDateAndDropDate(),
                  ),
                  SizedBox(height: defaultMargin),
                  Divider(
                    color: kBackgroundColor,
                    thickness: 5,
                  ),
                  SizedBox(height: defaultMargin),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _accountInformations(state.user!),
                  ),
                  SizedBox(height: defaultMargin * 2),
                  _buildBottomBar(context),
                  Padding(padding: EdgeInsets.only(bottom: defaultMargin)),
                ],
              ),
            ),
          );
        } else if (state is AuthFailure) {
          return const Center(
            child: Text("Please log in to continue"),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _accountInformations(UserModel user) {
    TextEditingController phoneController =
        TextEditingController(text: user.phone_number.toString());

    String displayedPhoneNumber = user.phone_number.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: defaultMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Detail Pemesan",
                style: titleTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: defaultMargin / 2),
              Text(
                "Nomor WhatsApp ini akan digunakan untuk pengiriman \ninformasi tiket pesanan.",
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(
              top: defaultMargin,
            ),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(defaultRadius),
              border: Border.all(
                color: kDivider,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user.username,
                        style: blackTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Icon(
                      //   FontAwesomeIcons.penToSquare,
                      //   color: kPrimaryColor,
                      //   size: 20,
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: defaultMargin,
                  ), // Spacer for better alignment
                  Text(
                    displayedPhoneNumber.isEmpty || displayedPhoneNumber == "0"
                        ? "Nomor Telepon Belum Diatur"
                        : (displayedPhoneNumber.startsWith('0')
                            ? displayedPhoneNumber
                            : '0$displayedPhoneNumber'),
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    user.email,
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCarBooking() {
    print(widget.car.carDate);
    return Container(
      margin: EdgeInsets.only(
        top: defaultMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(defaultMargin),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(defaultRadius),
              border: Border.all(
                color: kDivider,
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.car.carName,
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: bold,
                          ),
                        ),
                        SizedBox(height: defaultMargin / 2),
                        Text(
                          "Disediakan oleh ${widget.car.ownerCar}",
                          style: subTitleTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: defaultMargin),
                Row(
                  children: [
                    Column(
                      children: [
                        // Start point icon
                        Icon(
                          Iconsax.location_tick,
                          color: kGreyColor,
                          size: 18,
                        ),
                        // Timeline line
                        Container(
                          width: 1,
                          height: 50,
                          decoration: BoxDecoration(
                            color: kDivider,
                          ),
                        ),
                        // End point icon
                        Icon(
                          Iconsax.location,
                          color: kGreyColor,
                          size: 18,
                        ),
                      ],
                    ),
                    SizedBox(width: defaultMargin),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kota Asal",
                                style: subTitleTextStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: defaultMargin / 2),
                              Text(
                                widget.carFrom,
                                style: blackTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kota Tujuan",
                                style: subTitleTextStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: defaultMargin / 2),
                              Text(
                                widget.carTo,
                                style: blackTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: defaultMargin),
                Row(
                  children: [
                    Icon(
                      Iconsax.calendar,
                      size: 18,
                      color: kGreyColor,
                    ),
                    SizedBox(width: defaultMargin),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Berangkat",
                          style: subTitleTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: defaultMargin / 2),
                        Text(
                          DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                              .format(widget.carDate),
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: defaultMargin),
                Row(
                  children: [
                    Icon(
                      Iconsax.clock,
                      size: 18,
                      color: kGreyColor,
                    ),
                    SizedBox(width: defaultMargin),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jam Berangkat",
                          style: subTitleTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: defaultMargin / 2),
                        Text(
                          widget.car.departureTime,
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickDateAndDropDate() {
    return Container(
      margin: EdgeInsets.only(
        top: defaultMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Informasi Perjalanan",
            style: titleTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: defaultMargin / 2),
          Text(
            "Pastikan semua data di bawah ini sudah lengkap \nuntuk melanjutkan pemesanan.",
            style: blackTextStyle.copyWith(
              fontSize: 14,
            ),
          ),
          SizedBox(height: defaultMargin),
          // GestureDetector(
          //   onTap: () {
          //     showModalBottomSheet(
          //       backgroundColor: kWhiteColor,
          //       context: context,
          //       builder: (BuildContext context) {
          //         return Container(
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(defaultRadius),
          //               topRight: Radius.circular(defaultRadius),
          //             ),
          //           ),
          //           child: SizedBox(
          //             height: 180, // Adjust the height as needed
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: <Widget>[
          //                 ListTile(
          //                   title: Text(
          //                     'Pagi',
          //                     style: blackTextStyle.copyWith(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                   onTap: () {
          //                     setState(() {
          //                       selectedTime = 'Pagi';
          //                     });
          //                     Navigator.pop(context, 'Pagi');
          //                   },
          //                 ),
          //                 ListTile(
          //                   title: Text(
          //                     'Sore',
          //                     style: blackTextStyle.copyWith(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                   onTap: () {
          //                     setState(() {
          //                       selectedTime = 'Sore';
          //                     });
          //                     Navigator.pop(context, 'Sore');
          //                   },
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //     ).then((value) {
          //       if (value != null) {
          //         setState(() {
          //           selectedTime = value;
          //         });
          //       }
          //     });
          //   },
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: kWhiteColor,
          //       borderRadius: BorderRadius.circular(defaultRadius),
          //       border: Border.all(
          //         color: kDivider,
          //       ),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         children: [
          //           SizedBox(width: defaultMargin),
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 "Pilih Waktu",
          //                 style: subTitleTextStyle.copyWith(fontSize: 14),
          //               ),
          //               SizedBox(height: defaultMargin / 2),
          //               Text(
          //                 selectedTime,
          //                 style: blackTextStyle.copyWith(
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               )
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: defaultMargin),
          GestureDetector(
            onTap: () {
              int availableSeats =
                  widget.car.availableSeats - widget.car.selectedSeats;
              List<String> passengerOptions = [
                '1 Orang',
                '2 Orang',
                '3 Orang',
                '4 Orang',
                '5 Orang',
                '6 Orang',
                '7 Orang',
              ];
              List<String> filteredOptions = passengerOptions.where((option) {
                int passengers = int.parse(option.split(' ')[0]);
                return passengers <= availableSeats;
              }).toList();

              showModalBottomSheet(
                backgroundColor: kWhiteColor,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(defaultRadius),
                        topRight: Radius.circular(defaultRadius),
                      ),
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.6, // Adjust the height as needed
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: filteredOptions.map((option) {
                          return ListTile(
                            title: Text(
                              option,
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedPassengers = option;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(defaultRadius),
                border: Border.all(
                  color: kDivider,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(width: defaultMargin),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pilih Jumlah Penumpang",
                          style: subTitleTextStyle.copyWith(fontSize: 14),
                        ),
                        SizedBox(height: defaultMargin / 2),
                        Text(
                          selectedPassengers,
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: defaultMargin),
          GestureDetector(
            onTap: () async {
              final selectedLocation = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PickLocations(),
                ),
              );

              if (selectedLocation != null) {
                setState(() {
                  _selectedLocationPick = selectedLocation;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(defaultRadius),
                border: Border.all(
                  color: kDivider,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(width: defaultMargin),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pilih Titik Jemput",
                            style: subTitleTextStyle.copyWith(fontSize: 14),
                          ),
                          SizedBox(height: defaultMargin / 2),
                          Text(
                            _selectedLocationPick,
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: defaultMargin),
          GestureDetector(
            onTap: () async {
              final selectedLocation = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PickDrop(),
                ),
              );

              if (selectedLocation != null) {
                setState(() {
                  _selectedLocationDrop = selectedLocation;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(defaultRadius),
                border: Border.all(
                  color: kDivider,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(width: defaultMargin),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pilih Titik Drop-off",
                            style: subTitleTextStyle.copyWith(fontSize: 14),
                          ),
                          SizedBox(height: defaultMargin / 2),
                          Text(
                            _selectedLocationDrop,
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: defaultMargin),
          Container(
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(defaultRadius),
              border: Border.all(
                color: kDivider,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: defaultMargin,
                  ),
                  child: Text(
                    "Permintaan Khusus",
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: defaultMargin,
                    bottom: defaultMargin,
                  ),
                  child: TextField(
                    cursorColor: kPrimaryColor,
                    controller: _specialRequestController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    maxLength: 200,
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ), // Make user input bold
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Tolong sediakan kursi di depan.",
                      hintStyle: subTitleTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: regular,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: defaultMargin),
      decoration: BoxDecoration(
        color: kWhiteColor,
        border: Border(top: BorderSide(color: kBackgroundColor, width: 2.5)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: CustomButton(
          title: 'Lanjutkan',
          onPressed: () {
            if (_selectedLocationPick.isEmpty ||
                _selectedLocationDrop.isEmpty) {
              showErrorFlushbar(
                context,
                "Data Belum Lengkap",
                "Silakan lengkapi informasi perjalanan sebelum melanjutkan",
              );
            } else {
              // Print saved data before saving
              SharedPreferences.getInstance().then((prefs) {
                print('Selected Date: ${selectedDate.toString()}');
                print('Selected Time: $selectedTime');
                print('Selected Passengers: $selectedPassengers');
                print('Selected Location Pick: $_selectedLocationPick');
                print('Selected Location Drop: $_selectedLocationDrop');

                print('Special Request: ${_specialRequestController.text}');
                print('Departure Time: $_departureTime');
              });

              saveData();
              var uuid = const Uuid();
              String orderId = uuid.v1().replaceAll('-', '').substring(0, 8);
              bookingModels?.id = orderId;

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailBookingPage(
                    id: orderId,
                    carFrom: widget.carFrom,
                    carTo: widget.carTo,
                    carDate: widget.carDate,
                    carModel: widget.car,
                    selectedDate: selectedDate,
                    selectedTime: selectedTime,
                    selectedPassengers: int.parse(RegExp(r'\d+')
                            .firstMatch(selectedPassengers)
                            ?.group(0) ??
                        '1'),
                    selectedLocationPick: _selectedLocationPick,
                    selectedLocationDrop: _selectedLocationDrop,
                    specialRequest: _specialRequestController.text,
                    departureTime: _departureTime,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _otherInformations() {
    return Container(
      margin: EdgeInsets.only(
        top: defaultMargin,
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
              // Wrap the Text widget with Expanded
              child: Text(
                "Pemesanan tiket dengan aplikasi tidak bisa refund atau reschedule.",
                style: buttonColor.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
