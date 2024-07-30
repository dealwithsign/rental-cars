// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import '../../bloc/tickets/bloc/tickets_bloc.dart';
// import '../../models/ticket.dart';
// import '../../utils/fonts/constant.dart';
// import '../../utils/widgets/button.dart';

// class TicketDetailScreen extends StatefulWidget {
//   final TicketModels ticket;

//   const TicketDetailScreen({Key? key, required this.ticket}) : super(key: key);

//   @override
//   State<TicketDetailScreen> createState() => _TicketDetailScreenState();
// }

// class _TicketDetailScreenState extends State<TicketDetailScreen> {
//   bool isLoading = true;

//   @override
//   void initState() {
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kWhiteColor,
//       appBar: _buildAppBar(context),
//       body: _buildBody(context),
//     );
//   }

//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: kWhiteColor,
//       surfaceTintColor: kWhiteColor,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.black),
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//       ),
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '${widget.ticket.carFrom} - ${widget.ticket.carTo}',
//             style: blackTextStyle.copyWith(
//               fontSize: 16,
//               fontWeight: bold,
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             'Order ID: ${widget.ticket.bookingId.toUpperCase()}',
//             style: subTitleTextStyle.copyWith(
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//       centerTitle: false,
//       elevation: 0,
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return BlocBuilder<TicketsBloc, TicketsState>(
//       builder: (context, state) {
//         if (state is TicketsLoading) {
//           return Center(
//               child: SpinKitThreeBounce(
//             color: kPrimaryColor,
//             size: 25,
//           ));
//         } else if (state is TicketsSuccess) {
//           if (state.tickets.isEmpty) {
//             return Center(
//                 child: Text('Belum ada booking', style: blackTextStyle));
//           }
//           return Skeletonizer(
//             enabled: isLoading,
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: defaultMargin),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: defaultMargin),
//                     child: _buildDetailsTravel(
//                       lokasiJemput: widget.ticket.carFrom,
//                       lokasiTujuan: widget.ticket.carTo,
//                     ),
//                   ),
//                   SizedBox(height: defaultMargin),
//                   Divider(
//                     color: kBackgroundColor,
//                     thickness: 5,
//                   ),
//                   SizedBox(height: defaultMargin),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: defaultMargin),
//                     child: _buildDetailsPrice(),
//                   ),
//                   SizedBox(height: defaultMargin),
//                   Divider(
//                     color: kBackgroundColor,
//                     thickness: 5,
//                   ),
//                   SizedBox(height: defaultMargin),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: defaultMargin),
//                     child: Text(
//                       'Beri Ulasan',
//                       style: blackTextStyle.copyWith(
//                         fontSize: 16,
//                         fontWeight: bold,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: defaultMargin),
//                     child: _buildRatingBar(),
//                   ),
//                   Padding(padding: EdgeInsets.all(defaultMargin)),
//                 ],
//               ),
//             ),
//           );
//         } else if (state is TicketsError) {
//           return Center(
//               child: Text('Error: ${state.message}', style: blackTextStyle));
//         } else {
//           return Container();
//         }
//       },
//     );
//   }

//   Widget _buildDetailsTravel({
//     required String lokasiJemput,
//     required String lokasiTujuan,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.ticket.carName,
//           style: blackTextStyle.copyWith(
//             fontSize: 16,
//             fontWeight: bold,
//           ),
//         ),
//         SizedBox(height: defaultMargin),
//         Text(
//           "Dioperasikan oleh ${widget.ticket.ownerCar}",
//           style: blackTextStyle.copyWith(
//             fontSize: 14,
//           ),
//         ),
//         Text(
//           formatIndonesianDate(widget.ticket.carDate),
//           style: blackTextStyle.copyWith(
//             fontSize: 14,
//           ),
//         ),
//         Text(
//           "${widget.ticket.selectedPassengers.toString()} penumpang",
//           style: blackTextStyle.copyWith(
//             fontSize: 14,
//           ),
//         ),
//         // Update this with actual data
//         SizedBox(height: defaultMargin * 2),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: kBackgroundColor,
//                   child: Icon(
//                     FontAwesomeIcons.locationArrow,
//                     color: kIcon,
//                     size: 18,
//                   ),
//                 ),
//                 Container(
//                   width: 2,
//                   height: 50,
//                   color: kBackgroundColor,
//                 ),
//                 CircleAvatar(
//                   backgroundColor: kBackgroundColor,
//                   child: Icon(
//                     FontAwesomeIcons.locationDot,
//                     color: kIcon,
//                     size: 18,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(width: defaultMargin),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.ticket.carFrom,
//                     style: blackTextStyle.copyWith(
//                       fontSize: 14,
//                       fontWeight: bold,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     widget.ticket.selected_location_pick,
//                     style: subTitleTextStyle.copyWith(
//                       fontSize: 14,
//                     ),
//                   ),
//                   SizedBox(height: defaultMargin * 3),
//                   Text(
//                     widget.ticket.carTo,
//                     style: blackTextStyle.copyWith(
//                       fontSize: 14,
//                       fontWeight: bold,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     widget.ticket.selected_location_drop,
//                     style: subTitleTextStyle.copyWith(
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRatingBar() {
//     return Column(
//       children: [
//         SizedBox(height: defaultMargin),
//         RatingBar.builder(
//           initialRating: 3,
//           minRating: 1,
//           direction: Axis.horizontal,
//           allowHalfRating: true,
//           itemCount: 5,
//           itemSize: 30,
//           itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
//           itemBuilder: (context, _) => Icon(
//             FontAwesomeIcons.solidStar,
//             color: kPrimaryColor,
//           ),
//           onRatingUpdate: (rating) {
//             print(rating);
//             // Handle the rating change here
//           },
//         ),
//         SizedBox(height: defaultMargin),
//         Container(
//           decoration: BoxDecoration(
//             color: kWhiteColor,
//             borderRadius: BorderRadius.circular(defaultRadius),
//             border: Border.all(
//               color: kDivider,
//             ),
//           ),
//           child: Padding(
//             padding: EdgeInsets.only(
//               left: defaultMargin,
//             ),
//             child: TextFormField(
//               maxLines: 5,
//               cursorColor: kPrimaryColor,
//               decoration: InputDecoration(
//                 hintText: 'Tulis ulasanmu disini...',
//                 labelStyle: blackTextStyle.copyWith(
//                   fontSize: 14,
//                 ),
//                 border: InputBorder.none,
//                 hintStyle: blackTextStyle.copyWith(
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: defaultMargin),
//         CustomButton(
//           title: "Simpan",
//           onPressed: () {
//             // Handle the save button here
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailsPrice() {
//     // Parse carPrice to int and calculate total car price
//     final int carPrice = 200;
//     final int totalPriceWithoutAdmin = 100;
//     // Assuming adminFee is a constant 50000
//     const int adminFee = 12000;
//     // Calculate total price including admin fee
//     final int totalPrice = totalPriceWithoutAdmin + adminFee;

//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Rincian Pembayaran',
//             style: blackTextStyle.copyWith(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(
//             height: defaultMargin,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Metode Pembayaran',
//                 style: subTitleTextStyle.copyWith(
//                   fontSize: 14,
//                 ),
//               ),
//               Text(
//                 // Calculate the car price and the selected passengers, then format the result
//                 'Rp ${NumberFormat("#,##0", "id_ID").format(totalPriceWithoutAdmin)}',
//                 style: blackTextStyle.copyWith(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Rp ${totalPrice} x ${totalPrice} Orang',
//                 style: subTitleTextStyle.copyWith(
//                   fontSize: 14,
//                 ),
//               ),
//               Text(
//                 // Calculate the car price and the selected passengers, then format the result
//                 'Rp ${NumberFormat("#,##0", "id_ID").format(totalPriceWithoutAdmin)}',
//                 style: blackTextStyle.copyWith(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Biaya Admin',
//                 style: subTitleTextStyle.copyWith(
//                   fontSize: 14,
//                 ),
//               ),
//               Text(
//                 'Rp ${NumberFormat("#,##0", "id_ID").format(adminFee)}',
//                 style: blackTextStyle.copyWith(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           Divider(
//             color: kDivider,
//             thickness: 1,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total Harga',
//                 style: blackTextStyle.copyWith(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 // Format the total price including admin fee
//                 'Rp ${NumberFormat("#,##0", "id_ID").format(totalPrice)}',
//                 style: blackTextStyle.copyWith(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailItem(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '$label:',
//           style: subTitleTextStyle.copyWith(
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           value,
//           style: blackTextStyle.copyWith(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   String formatIndonesianDate(DateTime date) {
//     Intl.defaultLocale = 'id_ID'; // Ensure the locale is set to Indonesian
//     var formatter = DateFormat('EEEE, dd MMMM yyyy');
//     return formatter.format(date);
//   }
// }
