// presentation/pages/midtrans_success_page.dart
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rents_cars_app/presentation/pages/wrapper_auth_page.dart';

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
              'Transaksi Sukses',
              style: titleTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Order ID: ${widget.orderId.toUpperCase()}',
              style: subTitleTextStyle.copyWith(
                fontSize: 15,
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
              Center(
                child: ContextMenu(
                  title: 'Pembayaran Berhasil',
                  message:
                      'Terima kasih telah melakukan pembayaran.\nSilahkan lihat tiket Anda.',
                  icon: Iconsax.receipt_text,
                  kPrimaryColor: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: bold,
                  ),
                  subTitleTextStyle: subTitleTextStyle.copyWith(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: defaultMargin * 2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                child: CustomButton(
                  title: 'Lihat Tiket',
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WrapperAuth(),
                      ),
                      (Route<dynamic> route) => false,
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
