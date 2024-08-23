// presentation/pages/be_apartner.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
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
        'Mulai Menjadi Mitra',
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
          LineIcons.angleLeft,
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
                          'Daftar sebagai Mitra',
                          'Daftarkan diri Anda sebagai mitra dengan mengisi formulir yang telah disediakan.',
                          FontAwesomeIcons.print,
                        ),
                        SizedBox(height: defaultMargin),
                        _buildHowToRegisterAsPartner(
                          'Mari Berdiskusi',
                          'Eksplorasi segala kemungkinan & tentukan bentuk kemitraan yang paling sesuai dengan kebutuhan Anda.',
                          FontAwesomeIcons.comments,
                        ),
                        SizedBox(height: defaultMargin),
                        _buildHowToRegisterAsPartner(
                          'Buat program kemitraan',
                          'Finalisasi & tandatangani kesepakatan kemitraan, sehingga kami bisa mulai membuat programnya.',
                          FontAwesomeIcons.handshake,
                        ),
                        SizedBox(height: defaultMargin),
                        _buildHowToRegisterAsPartner(
                          'Program kemitraan sudah tayang!',
                          'Selamat! Anda telah resmi menjadi mitra kami. Kami akan membantu Anda dalam membangun bisnis Anda.',
                          FontAwesomeIcons.circleCheck,
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
                          'Pasang Iklan',
                          style: titleTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: bold,
                          ),
                        ),
                        SizedBox(height: defaultMargin),
                        _buildHowToRegisterAsPartner(
                          'Beriklan di NgeRental Kanda',
                          'Daftarkan diri Anda sebagai mitra dengan mengisi formulir yang telah disediakan.',
                          FontAwesomeIcons.rectangleAd,
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
                          'Bisnis Anda tidak ada dalam pilihan kategori di atas? Mau berdiskusi dengan tim kami? Atau Anda lebih memilih untuk langsung mengajukan proposal kemitraan? Segera kirim email ke:',
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
                                  FontAwesomeIcons.envelopeOpen,
                                  color: kPrimaryColor,
                                  size: 20,
                                ),
                                SizedBox(width: defaultMargin),
                                Text(
                                  'dealwithsign@gmail.com',
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
                                  FontAwesomeIcons.whatsapp,
                                  color: kPrimaryColor,
                                  size: 20,
                                ),
                                SizedBox(width: defaultMargin),
                                Text(
                                  '+62 812 3456 7890',
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
                // SizedBox(height: defaultMargin * 2),
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: defaultMargin),
                //   decoration: BoxDecoration(
                //     color: kWhiteColor,
                //     border: Border(
                //         top: BorderSide(color: kBackgroundColor, width: 2.5)),
                //   ),
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                //     child: CustomButton(
                //       title: "Daftar Jadi Mitra",
                //       onPressed: () {},
                //     ),
                //   ),
                // ),
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
                  color: kappBar,
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
}
