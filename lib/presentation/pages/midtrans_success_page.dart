// presentation/pages/midtrans_success_page.dart
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';
import '../widgets/context_menu.dart';

class MidtransSuccess extends StatefulWidget {
  final String orderId;
  const MidtransSuccess({super.key, required this.orderId});

  @override
  State<MidtransSuccess> createState() => _MidtransSuccessState();
}

class _MidtransSuccessState extends State<MidtransSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Pembayaran Berhasil',
              style: titleTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Order ID: ${widget.orderId.toUpperCase()}',
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: kWhiteColor,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ContextMenu(
                title: 'Pembayaran Berhasil',
                message:
                    'Terimakasih atas pesanan anda, \nsilahkan cek email untuk detail pemesanan.',
                imagePath:
                    'assets/images/success_payments.png', // Pass the image path as a string
                kPrimaryColor: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
                subTitleTextStyle: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
