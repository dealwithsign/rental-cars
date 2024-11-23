// presentation/pages/be_apartner.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../utils/fonts.dart';

class HowToBePartner extends StatefulWidget {
  const HowToBePartner({super.key});

  @override
  State<HowToBePartner> createState() => _HowToBePartnerState();
}

class _HowToBePartnerState extends State<HowToBePartner> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: _buildAppBar(),
      body: Skeletonizer(
        enabled: isLoading,
        child: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      title: Text(
        'Pesan Tiket Sekarang',
        style: titleTextStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Iconsax.arrow_left_2,
          size: 20,
          color: kPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: defaultMargin),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cara Pesan Tiket',
                          style: titleTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: bold,
                          ),
                        ),
                        SizedBox(height: defaultMargin),
                        _buildHowToRegisterAsPartner(
                          'Pilih rincian perjalanan',
                          'Masukkan tempat keberangkatan, tujuan, tanggal perjalanan dan kemudian klik Cari.',
                          Iconsax.driving,
                        ),
                        SizedBox(height: defaultMargin),
                        _buildHowToRegisterAsPartner(
                          'Pilih mobil dan masukkan data diri',
                          'Pilih mobil dan isi rincian penumpang dan klik Pembayaran.',
                          Iconsax.personalcard,
                        ),
                        SizedBox(height: defaultMargin),
                        _buildHowToRegisterAsPartner(
                          'Pilih Pembayaran',
                          'Pembayaran dapat dilakukan melalui transfer ATM, Virtual Account dan E-Wallet.',
                          Iconsax.card,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: defaultMargin),
                const Divider(color: Color(0XFFEBEBEB), thickness: 1),
                SizedBox(height: defaultMargin),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: _buildFaq(),
                ),
                SizedBox(height: defaultMargin),
                const Divider(color: Color(0XFFEBEBEB), thickness: 1),
                SizedBox(height: defaultMargin),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pasang Iklan',
                          style: titleTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: bold,
                          ),
                        ),
                        SizedBox(height: defaultMargin),
                        _buildHowToRegisterAsPartner(
                          'Beriklan di Lalan',
                          'Punya bisnis lainnya? Pasang iklan di Lalan untuk menjangkau lebih banyak pelanggan.',
                          Iconsax.status_up,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: defaultMargin * 2),
        ),
      ],
    );
  }

  Widget _buildHowToRegisterAsPartner(
    String title,
    String message,
    IconData icon,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: kPrimaryColor,
                size: 20,
              ),
              SizedBox(width: defaultMargin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: titleTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: bold,
                      ),
                    ),
                    SizedBox(
                      height: defaultMargin / 2,
                    ),
                    Text(
                      message,
                      style: subTitleTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: regular,
                      ),
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

  Widget _buildFaq() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kelebihan Layanan Kami',
          style: titleTextStyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
        SizedBox(height: defaultMargin),
        _buildHowToRegisterAsPartner(
          'Biaya final ',
          'Pesan tiket mobil antar kota dengan harga terbaik dan tanpa biaya tambahan.',
          Iconsax.dollar_square,
        ),
        SizedBox(height: defaultMargin),
        _buildHowToRegisterAsPartner(
          'Pembayaran mudah dan aman',
          'Bayar tiket online anda dengan cara yang aman dan nyaman.',
          Iconsax.wallet,
        ),
        SizedBox(height: defaultMargin),
        _buildHowToRegisterAsPartner(
          'Titik penjemputan dan tujuan',
          'Pilih titik penjemputan dan tujuan yang sesuai dengan kebutuhan anda.',
          Iconsax.location_tick,
        ),
      ],
    );
  }
}
