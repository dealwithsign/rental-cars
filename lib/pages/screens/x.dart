// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:rents_cars_app/pages/screens/details_book.dart';
// import 'package:rents_cars_app/pages/screens/maps/pick_locations.dart';
// import 'package:rents_cars_app/utils/widgets/button.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../models/cars.dart';
// import '../../utils/fonts/constant.dart';
// import '../../utils/widgets/input.dart';
// import 'maps/drop_locations.dart';

// class BookWithDriverPage extends StatefulWidget {
//   final CarsModels car;
//   final String carFrom;
//   final String carTo;
//   final DateTime carDate;

//   const BookWithDriverPage({
//     Key? key,
//     required this.car,
//     required this.carFrom,
//     required this.carTo,
//     required this.carDate,
//   }) : super(key: key);

//   @override
//   _BookWithDriverPageState createState() => _BookWithDriverPageState();
// }

// class _BookWithDriverPageState extends State<BookWithDriverPage> {
//   DateTime selectedDate = DateTime.now();
//   String selectedTime = 'Sore';
//   String selectedPassengers = '1 Orang';
//   String _selectedLocationPick = '';
//   String _selectedLocationDrop = '';
//   final TextEditingController _specialRequestsController =
//       TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     loadSavedData();
//   }

//   Future<void> loadSavedData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       selectedDate = prefs.containsKey('selectedDate')
//           ? DateTime.parse(prefs.getString('selectedDate')!)
//           : DateTime.now();
//       selectedTime = prefs.getString('selectedTime') ?? selectedTime;
//       selectedPassengers =
//           prefs.getString('selectedPassengers') ?? selectedPassengers;
//       _selectedLocationPick = prefs.getString('selectedLocationPick') ?? '';
//       _selectedLocationDrop = prefs.getString('selectedLocationDrop') ?? '';
//       _specialRequestsController.text =
//           prefs.getString('specialRequests') ?? '';
//       _phoneController.text = prefs.getString('phone') ?? '';
//     });
//   }

//   Future<void> saveData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedDate', selectedDate.toString());
//     await prefs.setString('selectedTime', selectedTime);
//     await prefs.setString('selectedPassengers', selectedPassengers);
//     await prefs.setString('selectedLocationPick', _selectedLocationPick);
//     await prefs.setString('selectedLocationDrop', _selectedLocationDrop);
//     await prefs.setString('specialRequests', _specialRequestsController.text);
//     await prefs.setString('phone', _phoneController.text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       color: kWhiteColor,
//       home: Scaffold(
//         backgroundColor: kWhiteColor,
//         appBar: AppBar(
//           surfaceTintColor: kWhiteColor,
//           backgroundColor: kWhiteColor,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           title: Text(
//             'Selesaikan Pesananmu',
//             style: blackTextStyle.copyWith(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           elevation: 0,
//         ),
//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildBody(),
//               _buildBottomBar(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: defaultMargin),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildDetailCarBooking(),
//           _buildOrderDetails(),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailCarBooking() {
//     return Container(
//       margin: EdgeInsets.only(top: defaultMargin),
//       padding: EdgeInsets.all(defaultMargin),
//       decoration: BoxDecoration(
//         color: kWhiteColor,
//         borderRadius: BorderRadius.circular(defaultRadius),
//         border: Border.all(color: kDivider, width: 1.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.car.carName,
//             style: blackTextStyle.copyWith(
//               fontSize: 16,
//               fontWeight: bold,
//             ),
//           ),
//           Text(
//             DateFormat('EEE, dd MMMM yyyy', 'id_ID').format(widget.carDate),
//             style: blackTextStyle.copyWith(
//               fontSize: 14,
//               fontWeight: bold,
//             ),
//           ),
//           SizedBox(height: defaultMargin),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Kota Asal",
//                     style: subTitleTextStyle.copyWith(fontSize: 14),
//                   ),
//                   Text(
//                     widget.carFrom,
//                     style: blackTextStyle.copyWith(
//                       fontSize: 14,
//                       fontWeight: bold,
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Kota Tujuan",
//                     style: subTitleTextStyle.copyWith(fontSize: 14),
//                   ),
//                   Text(
//                     widget.carTo,
//                     style: blackTextStyle.copyWith(
//                       fontSize: 14,
//                       fontWeight: bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderDetails() {
//     return Container(
//       margin: EdgeInsets.only(top: defaultMargin),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Detail Pesanan",
//             style: blackTextStyle.copyWith(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: defaultMargin),
//           _buildPhoneInput(),
//           _buildTimePicker(),
//           _buildPassengerPicker(),
//           _buildLocationPicker(
//             title: "Pilih Lokasi Jemput",
//             selectedLocation: _selectedLocationPick,
//             onTap: () async {
//               final selectedLocation = await Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => const PickLocations(),
//                 ),
//               );
//               if (selectedLocation != null) {
//                 setState(() {
//                   _selectedLocationPick = selectedLocation;
//                 });
//               }
//             },
//           ),
//           _buildLocationPicker(
//             title: "Pilih Lokasi Drop-off",
//             selectedLocation: _selectedLocationDrop,
//             onTap: () async {
//               final selectedLocation = await Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => const PickDrop(),
//                 ),
//               );
//               if (selectedLocation != null) {
//                 setState(() {
//                   _selectedLocationDrop = selectedLocation;
//                 });
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPhoneInput() {
//     return Container(
//         child: OutlineBorderTextFormField(
//       tempTextEditingController: _phoneController,
//       labelText: "Nomor Telepon",
//       keyboardType: TextInputType.phone,
//       validation: (value) {},
//       autofocus: false,
//       textInputAction: TextInputAction.next,
//       inputFormatters: [],
//       checkOfErrorOnFocusChange: false,
//       autocorrect: false,
//       obscureText: false,
//       validator: (value) {},
//       myFocusNode: FocusNode(),
//     ));
//   }

//   Widget _buildTimePicker() {
//     return GestureDetector(
//       onTap: () {
//         _showTimePicker();
//       },
//       child: _buildPickerContainer(
//         title: "Pilih Waktu",
//         value: selectedTime,
//       ),
//     );
//   }

//   Widget _buildPassengerPicker() {
//     return GestureDetector(
//       onTap: () {
//         _showPassengerPicker();
//       },
//       child: _buildPickerContainer(
//         title: "Pilih Jumlah Penumpang",
//         value: selectedPassengers,
//       ),
//     );
//   }

//   Widget _buildLocationPicker({
//     required String title,
//     required String selectedLocation,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: _buildPickerContainer(
//         title: title,
//         value: selectedLocation.isEmpty ? 'Pilih Lokasi' : selectedLocation,
//       ),
//     );
//   }

//   Widget _buildPickerContainer({
//     required String title,
//     required String value,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(top: defaultMargin),
//       decoration: BoxDecoration(
//         color: kWhiteColor,
//         borderRadius: BorderRadius.circular(defaultRadius),
//         border: Border.all(color: kDivider, width: 1.0),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: subTitleTextStyle.copyWith(fontSize: 14),
//             ),
//             Text(
//               value,
//               style: blackTextStyle.copyWith(
//                 fontSize: 14,
//                 fontWeight: bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomBar(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: defaultMargin),
//       decoration: BoxDecoration(
//         color: kWhiteColor,
//         border: Border(
//           top: BorderSide(color: kDivider, width: 1.0),
//         ),
//       ),
//       child: Center(
//         child: CustomButton(
//           title: "Konfirmasi Pesanan",
//           onPressed: () {
//             _confirmOrder(context);
//           },
//         ),
//       ),
//     );
//   }

//   Future<void> _showTimePicker() async {
//     final result = await showDialog(
//       context: context,
//       builder: (context) {
//         String tempTime = selectedTime;
//         return AlertDialog(
//           title: const Text("Pilih Waktu"),
//           content: _buildTimeOptions((newTime) {
//             tempTime = newTime;
//           }),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, null);
//               },
//               child: const Text("Batal"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, tempTime);
//               },
//               child: const Text("Pilih"),
//             ),
//           ],
//         );
//       },
//     );

//     if (result != null) {
//       setState(() {
//         selectedTime = result;
//       });
//       await saveData();
//     }
//   }

//   Widget _buildTimeOptions(ValueChanged<String> onChanged) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: ['Pagi', 'Siang', 'Sore', 'Malam'].map((time) {
//         return RadioListTile<String>(
//           title: Text(time),
//           value: time,
//           groupValue: selectedTime,
//           onChanged: (value) {
//             if (value != null) {
//               setState(() {
//                 selectedTime = value;
//               });
//               onChanged(value);
//             }
//           },
//         );
//       }).toList(),
//     );
//   }

//   Future<void> _showPassengerPicker() async {
//     final result = await showDialog(
//       context: context,
//       builder: (context) {
//         String tempPassengers = selectedPassengers;
//         return AlertDialog(
//           title: const Text("Pilih Jumlah Penumpang"),
//           content: _buildPassengerOptions((newPassengers) {
//             tempPassengers = newPassengers;
//           }),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, null);
//               },
//               child: const Text("Batal"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, tempPassengers);
//               },
//               child: const Text("Pilih"),
//             ),
//           ],
//         );
//       },
//     );

//     if (result != null) {
//       setState(() {
//         selectedPassengers = result;
//       });
//       await saveData();
//     }
//   }

//   Widget _buildPassengerOptions(ValueChanged<String> onChanged) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: ['1 Orang', '2 Orang', '3 Orang', '4 Orang'].map((passenger) {
//         return RadioListTile<String>(
//           title: Text(passenger),
//           value: passenger,
//           groupValue: selectedPassengers,
//           onChanged: (value) {
//             if (value != null) {
//               setState(() {
//                 selectedPassengers = value;
//               });
//               onChanged(value);
//             }
//           },
//         );
//       }).toList(),
//     );
//   }

//   void _confirmOrder(BuildContext context) {
//     if (_phoneController.text.isEmpty) {
//       _showFlushbar(context, "Nomor telepon harus diisi.");
//     } else if (_selectedLocationPick.isEmpty || _selectedLocationDrop.isEmpty) {
//       _showFlushbar(context, "Lokasi jemput dan drop-off harus dipilih.");
//     } else {
//       // Proceed to the next page or confirm the order
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DetailBookingPage(
//             carModel: widget.car,
//             selectedDate: selectedDate,
//             selectedTime: selectedTime,
//             selectedPassengers: int.parse(
//                 RegExp(r'\d+').firstMatch(selectedPassengers)?.group(0) ??
//                     '1'), // Extracts digits and falls back to '1' if none found
//             selectedLocationPick: _selectedLocationPick,
//             selectedLocationDrop: _selectedLocationDrop,

//             specialRequests: _specialRequestsController.text.isEmpty
//                 ? 'Tidak ada permintaan khusus'
//                 : _specialRequestsController.text,
//             phone_number: int.parse(_phoneController.text),
//           ),
//         ),
//       );
//     }
//   }

//   void _showFlushbar(BuildContext context, String message) {
//     Flushbar(
//       message: message,
//       duration: const Duration(seconds: 3),
//       margin: const EdgeInsets.all(8),
//       borderRadius: BorderRadius.circular(8),
//     ).show(context);
//   }
// }
