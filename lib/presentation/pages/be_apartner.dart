// presentation/pages/be_apartner.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: _buildAppBar(),
        body: Skeletonizer(
          enabled: isLoading,
          child: _buildBody(),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      title: Text(
        'Cara Pemesanan Tiket',
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
                          'Ayo Mulai',
                          style: titleTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: bold,
                          ),
                        ),
                        SizedBox(height: defaultMargin),
                        _buildHowToRegisterAsPartner(
                          'Pilih rincian perjalanan',
                          'Masukkan tempat keberangkatan, tujuan, tanggal perjalanan dan kemudian klik Cari',
                          Iconsax.document,
                        ),
                        SizedBox(height: defaultMargin),
                        _buildHowToRegisterAsPartner(
                          'Pilih mobil dan masukkan data diri',
                          'Pilih mobil dan isi rincian penumpang dan klik Pembayaran',
                          Iconsax.message,
                        ),
                        SizedBox(height: defaultMargin),
                        _buildHowToRegisterAsPartner(
                          'Cara Pembayaran yang Mudah',
                          'Pembayaran dapat dilakukan melalui transfer ATM, Internet banking, Alfamart, kartu Kredit/Debit, Mandiri Clickpay, Bca Clickpay dll',
                          Iconsax.clipboard,
                        ),
                      ],
                    ),
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
                  child: _buildFaq(),
                ),
                SizedBox(height: defaultMargin),
                Divider(
                  color: kBackgroundColor,
                  thickness: 5,
                ),
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
                          Iconsax.receipt,
                        ),
                      ],
                    ),
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
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Punya pertanyaan?',
                          style: titleTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: bold,
                          ),
                        ),
                        SizedBox(height: defaultMargin),
                        Text(
                          'Untuk informasi lengkap, silakan hubungi kami \nmelalui Email atau Whatsapp.',
                          style: subTitleTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: regular,
                          ),
                        ),
                        SizedBox(height: defaultMargin),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.message,
                                  color: kPrimaryColor,
                                  size: 20,
                                ),
                                SizedBox(width: defaultMargin),
                                Text(
                                  'helpmelalan@gmail.com',
                                  style: subTitleTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: defaultMargin / 2),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.call,
                                  color: kPrimaryColor,
                                  size: 20,
                                ),
                                SizedBox(width: defaultMargin),
                                Text(
                                  '+6282134400200',
                                  style: subTitleTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: defaultMargin * 2),
                Container(
                  padding: EdgeInsets.symmetric(vertical: defaultMargin),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    border: Border(
                      top: BorderSide(color: kBackgroundColor, width: 2.5),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: CustomButton(
                      title: "Daftar Jadi Mitra",
                      onPressed: () async {
                        const url = 'https://forms.gle/vbhUEs6pdgSs2ntK6';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
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
              Container(
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  shape: BoxShape.circle,
                ),
                padding:
                    EdgeInsets.all(defaultMargin), // Adjust padding as needed
                child: Icon(
                  icon,
                  color: kPrimaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: defaultMargin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
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
          'Pesan tiket bis anda dengan harga terbaik dan tanpa biaya tambahan.',
          Iconsax.car,
        ),
        SizedBox(height: defaultMargin),
        _buildHowToRegisterAsPartner(
          'Pembayaran mudah dan aman',
          'Bayar tiket online anda dengan cara yang aman dan nyaman',
          Iconsax.activity,
        ),
        SizedBox(height: defaultMargin),
        _buildHowToRegisterAsPartner(
          'Titik penjemputan lebih praktis',
          'Pilih titik penjemputan yang lebih dekat dengan lokasi dan tujuan anda',
          Iconsax.wallet,
        ),
      ],
    );
  }
}
