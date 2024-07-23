// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rents_cars_app/utils/fonts/constant.dart';

import '../../../utils/widgets/button.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                'ID Transaksi: ${widget.orderId}',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
              ),
              Text(
                'Terima Kasih!',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Transaksi Anda telah berhasil.',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
