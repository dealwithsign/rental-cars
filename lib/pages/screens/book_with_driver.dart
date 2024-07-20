import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:rents_cars_app/models/users.dart';
import 'package:rents_cars_app/pages/screens/details_book.dart';
import 'package:rents_cars_app/pages/screens/maps/pick_locations.dart';
import 'package:rents_cars_app/services/users/auth_services.dart';
import 'package:rents_cars_app/utils/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../bloc/auth/bloc/auth_bloc.dart';
import '../../bloc/auth/bloc/auth_event.dart';
import '../../models/cars.dart';
import '../../utils/fonts/constant.dart';
import 'maps/drop_locations.dart';

class BookWithDriverPage extends StatefulWidget {
  final CarsModels car;
  final String carFrom;
  final String carTo;
  final DateTime carDate;
  const BookWithDriverPage({
    super.key,
    required this.car,
    required this.carFrom,
    required this.carTo,
    required this.carDate,
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

  final TextEditingController _phoneController = TextEditingController();

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

        _phoneController.text = prefs.getString('phone') ?? '';
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
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selesaikan Pesananmu',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
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
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 25.0,
            ),
          );
        } else if (state is AuthSuccess) {
          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _buildDetailCarBooking(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _otherInformations(),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: _buildBottomBar(context),
                  ),
                ],
              ),
            ),
          );
        } else if (state is AuthFailure) {
          return Center(
            child: Text("Please log in to continue"),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _accountInformations(UserModel user) {
    TextEditingController _phoneController =
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
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Kami akan mengirimkan semua e-ticket ke kontak ini",
                style: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              backgroundColor: kWhiteColor,
              context:
                  context, // Ensure you have a BuildContext context variable available
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                    child: Container(
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(defaultRadius),
                      topRight: Radius.circular(defaultRadius),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context)
                          .viewInsets
                          .bottom, // Add padding equal to the keyboard height
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: defaultMargin,
                            top: defaultMargin * 2,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Detail Pemesan",
                                style: blackTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: defaultMargin),
                              Text(
                                "Detail kontak ini akan di gunakan untuk pengirman e-ticket dan keperluan transaksi lainnya.",
                                style: subTitleTextStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: defaultMargin),
                              Container(
                                margin: EdgeInsets.only(
                                  right: defaultMargin,
                                ),
                                decoration: BoxDecoration(
                                  color: kWhiteColor,
                                  borderRadius:
                                      BorderRadius.circular(defaultRadius),
                                  border:
                                      Border.all(color: kDivider, width: 1.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: defaultMargin,
                                  ),
                                  child: TextFormField(
                                    cursorColor: kPrimaryColor,
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: "Nomor Telepon",
                                      labelStyle: blackTextStyle.copyWith(
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      hintStyle: blackTextStyle.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: defaultMargin * 2),
                              Container(
                                margin: EdgeInsets.only(
                                  right: defaultMargin,
                                  bottom: defaultMargin,
                                ),
                                child: CustomButton(
                                  title: "Simpan",
                                  onPressed: () async {
                                    final AuthServices _authServices =
                                        AuthServices();
                                    await _authServices.updateUser(
                                      id: user.id,
                                      phone_number:
                                          int.parse(_phoneController.text),
                                    );
                                    // Assuming `user` is a part of your state, update it with the new phone number
                                    setState(() {
                                      user.phone_number =
                                          int.parse(_phoneController.text);
                                      displayedPhoneNumber = _phoneController
                                          .text; // Update the displayed phone number
                                      context
                                          .read<AuthBloc>()
                                          .add(GetCurrentUserRequested());
                                    });

                                    Navigator.pop(context); // Close modal
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
              },
            );
          },
          child: Container(
            margin: EdgeInsets.only(
              top: defaultMargin,
            ),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(defaultRadius),
              border: Border.all(color: kDivider, width: 1.0),
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        FontAwesomeIcons.arrowRight,
                        color: kPrimaryColor,
                        size: 16,
                      ),
                    ],
                  ),
                  SizedBox(height: 8), // Spacer for better alignment
                  Text(
                    displayedPhoneNumber.isEmpty || displayedPhoneNumber == "0"
                        ? "Nomor Telepon Belum Diatur"
                        : (displayedPhoneNumber.startsWith('0')
                            ? displayedPhoneNumber
                            : '0$displayedPhoneNumber'),
                    style: subTitleTextStyle.copyWith(
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
              border: Border.all(color: kDivider, width: 1.0),
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
                          DateFormat('EEE, dd MMMM yyyy', 'id_ID')
                              .format(widget.carDate),
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: bold,
                          ),
                        ),
                        Text(
                          widget.car.carName,
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: bold,
                          ),
                        ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Text(
                          widget.carFrom,
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kota Asal",
                          style: subTitleTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
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
            "Detail Pesanan",
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Lengkapi data dibawah ini untuk melanjutkan pemesanan",
            style: subTitleTextStyle.copyWith(
              fontSize: 14,
            ),
          ),
          SizedBox(height: defaultMargin),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: kWhiteColor,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(defaultRadius),
                        topRight: Radius.circular(defaultRadius),
                      ),
                    ),
                    child: SizedBox(
                      height: 180, // Adjust the height as needed
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Pagi',
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              // Update your state to reflect the pick and close the bottom sheet
                              setState(() {
                                selectedTime = 'Pagi';
                              });
                              Navigator.pop(context, 'Pagi');
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Sore',
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              // Update your state to reflect the pick and close the bottom sheet
                              setState(() {
                                selectedTime = 'Sore';
                              });
                              Navigator.pop(context, 'Sore');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).then((value) {
                // Assuming you have a state variable to hold the time selection
                if (value != null) {
                  setState(() {
                    // Update your variable that holds the time selection here
                    // For example: selectedTime = value;
                  });
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(defaultRadius),
                border: Border.all(color: kDivider, width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pilih Waktu",
                          style: subTitleTextStyle.copyWith(fontSize: 14),
                        ),
                        // Display the selected time here
                        Text(
                          selectedTime,
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
            onTap: () {
              showModalBottomSheet(
                backgroundColor: kWhiteColor,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(defaultRadius),
                        topRight: Radius.circular(defaultRadius),
                      ),
                    ),
                    child: SizedBox(
                      height: 250, // Adjust the height as needed
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              '1 Orang',
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              // Update your state to reflect the pick and close the bottom sheet
                              setState(() {
                                selectedPassengers = '1 Orang';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(
                              '2 Orang',
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedPassengers = '2';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(
                              '3 Orang',
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedPassengers = '3 Orang';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(
                              '4 Orang',
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedPassengers = '4 Orang';
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
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
                border: Border.all(color: kDivider, width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pilih Jumlah Penumpang",
                          style: subTitleTextStyle.copyWith(fontSize: 14),
                        ),
                        Text(
                          selectedPassengers, // This should be a state variable
                          style: blackTextStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold),
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
              // Navigate to the pick location screen and wait for the result
              final selectedLocation = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PickLocations(),
                ),
              );

              if (selectedLocation != null) {
                setState(() {
                  // Update the location with the selected location
                  _selectedLocationPick = selectedLocation;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(defaultRadius),
                border: Border.all(color: kDivider, width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      // Wrap Column in Expanded
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pilih Titik Jemput",
                            style: subTitleTextStyle.copyWith(fontSize: 14),
                          ),
                          Text(
                            _selectedLocationPick ??
                                "Silahkan pilih lokasi jemput",
                            style: blackTextStyle.copyWith(
                                fontSize: 14, fontWeight: FontWeight.bold),
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
              // Navigate to the pick location screen and wait for the result
              final selectedLocation = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PickDrop(),
                ),
              );

              if (selectedLocation != null) {
                setState(() {
                  // Update the location with the selected location
                  _selectedLocationDrop = selectedLocation;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(defaultRadius),
                border: Border.all(color: kDivider, width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      // Wrap Column in Expanded
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pilih Titik Drop-off",
                            style: subTitleTextStyle.copyWith(fontSize: 14),
                          ),
                          Text(
                            _selectedLocationDrop ??
                                "Silahkan pilih lokasi drop-off",
                            style: blackTextStyle.copyWith(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
      child: CustomButton(
        title: 'Lanjutkan',
        onPressed: () {
          if (_selectedLocationPick.isEmpty ||
              _selectedLocationDrop.isEmpty ||
              _phoneController.text.isEmpty) {
            Flushbar(
              flushbarPosition: FlushbarPosition.BOTTOM,
              flushbarStyle: FlushbarStyle.FLOATING,
              duration: const Duration(seconds: 5),
              backgroundColor: Color(0xff171616),
              titleText: Text(
                "Data Belum Lengkap",
                style: whiteTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
              ),
              messageText: Text(
                "Silahkan lengkapi data terlebih dahulu",
                style: whiteTextStyle.copyWith(
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
            saveData();
            // Debug print untuk mengecek data
            print('Data Tanggal Jemput: ${selectedDate.toString()}');
            print('Data Waktu Berangkat: $selectedTime');
            print('Data Jumlah Penumpang: $selectedPassengers');
            print('Data Lokasi Jemput: $_selectedLocationPick');
            print('Data Lokasi Drop-off: $_selectedLocationDrop');
            // Data Permintaan Khusus: Check if input is empty and provide default text if so

            // Navigate to next screen or perform other actions
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailBookingPage(
                  carFrom: widget.carFrom,
                  carTo: widget.carTo,
                  carDate: widget.carDate,
                  carModel: widget.car,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  selectedPassengers: int.parse(RegExp(r'\d+')
                          .firstMatch(selectedPassengers)
                          ?.group(0) ??
                      '1'), // Extracts digits and falls back to '1' if none found
                  selectedLocationPick: _selectedLocationPick,
                  selectedLocationDrop: _selectedLocationDrop,
                  phone_number: int.parse(_phoneController.text),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _otherInformations() {
    return Container(
      margin: EdgeInsets.only(
        top: defaultMargin,
      ),
      decoration: BoxDecoration(
        color: kIcon,
        borderRadius: BorderRadius.circular(defaultRadius),
        border: Border.all(color: kIcon, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.circleInfo,
              color: kWhiteColor,
              size: 15,
            ),
            SizedBox(width: defaultMargin),
            Expanded(
              // Wrap the Text widget with Expanded
              child: Text(
                "Pemesanan tiket dengan aplikasi tidak bisa refund atau reschedule.",
                style: whiteTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
