// presentation/pages/midtrans_success_page.dart
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';

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
              style: blackTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Order ID: ${widget.orderId.toUpperCase()}',
              style: subTitleTextStyle.copyWith(
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
              Icon(
                FontAwesomeIcons.circleCheck,
                color: kSuccessColor,
                size: MediaQuery.of(context).size.width * 0.20,
              ),
              SizedBox(height: defaultMargin),
              Text(
                'Pembayaran Berhasil',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: bold,
                ),
              ),
              SizedBox(height: defaultMargin * 2),
              Text(
                'Terima kasih! Pembayaran kamu sudah diterima',
                style: blackTextStyle.copyWith(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Silakan cek email untuk detail pesanan',
                style: blackTextStyle.copyWith(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: defaultMargin * 2),
              Padding(
                padding: EdgeInsets.only(
                  left: defaultMargin,
                  right: defaultMargin,
                ),
                child: CustomButton(
                  title: 'Kembali ke Beranda',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/main',
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
