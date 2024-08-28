// presentation/pages/touristdestination_detail_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/models/touristdestination_model.dart';
import '../../utils/fonts.dart';

class TouristdestinationDetailPage extends StatefulWidget {
  final TouristdestinationModel destination;

  const TouristdestinationDetailPage({super.key, required this.destination});

  @override
  State<TouristdestinationDetailPage> createState() =>
      _TouristdestinationDetailPageState();
}

class _TouristdestinationDetailPageState
    extends State<TouristdestinationDetailPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;

    return Scaffold(
      body: Skeletonizer(
        enabled: isLoading,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: kWhiteColor,
              surfaceTintColor: kWhiteColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  LineIcons.angleLeft,
                  color: kWhiteColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              expandedHeight: MediaQuery.of(context).size.height * 0.3,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  destination.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: defaultMargin),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: DestinationTitle(destination.name),
                      ),
                      SizedBox(height: defaultMargin),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: DestinationDescription(destination.description),
                      ),
                      SizedBox(height: defaultMargin),
                      Divider(
                        color: kBackgroundColor,
                        thickness: 5,
                      ),
                      SizedBox(height: defaultMargin),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: DestinationLocationCard(
                          title: "Lokasi",
                          message: destination.location,
                          icon: FontAwesomeIcons.locationDot,
                        ),
                      ),
                      SizedBox(height: defaultMargin),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: DestinationLocationCard(
                          title: "Katagori",
                          message: destination.category,
                          icon: FontAwesomeIcons.landmark,
                        ),
                      ),
                      SizedBox(height: defaultMargin),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: DestinationLocationCard(
                          title: "Jam Operasional",
                          message: destination.operatingHours,
                          icon: FontAwesomeIcons.clock,
                        ),
                      ),
                      SizedBox(height: defaultMargin),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: DestinationLocationCard(
                          title: "Harga Tiket",
                          message: destination.ticketPrice,
                          icon: FontAwesomeIcons.ticketAlt,
                        ),
                      ),
                      SizedBox(height: defaultMargin),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: DestinationLocationCard(
                          title: "Rating",
                          message: destination.rating,
                          icon: FontAwesomeIcons.star,
                        ),
                      ),
                      SizedBox(height: defaultMargin),
                      Divider(
                        color: kBackgroundColor,
                        thickness: 5,
                      ),
                      SizedBox(height: defaultMargin),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
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
                                'Untuk pemesanan tiket atau informasi lainnya, silakan hubungi melalui email atau nomor di bawah ini',
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
                                        destination.email?.isNotEmpty == true
                                            ? destination.email!
                                            : 'Belum ada email terdaftar',
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
                                        destination.phoneNumber?.isNotEmpty ==
                                                true
                                            ? destination.phoneNumber!
                                            : 'Belum ada nomor telepon terdaftar',
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
                      SizedBox(height: defaultMargin),
                      Padding(
                        padding: EdgeInsets.only(bottom: defaultMargin * 2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DestinationTitle extends StatelessWidget {
  final String title;

  const DestinationTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: titleTextStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class DestinationLocation extends StatelessWidget {
  final String location;

  const DestinationLocation(this.location, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.mapMarkerAlt,
          color: descGrey,
          size: 15,
        ),
        SizedBox(width: defaultMargin / 2),
        Text(
          location,
          style: subTitleTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class DestinationSectionTitle extends StatelessWidget {
  final String title;

  const DestinationSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: titleTextStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class DestinationLocationCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const DestinationLocationCard({
    required this.title,
    required this.icon,
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: const Color(0xff018053),
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

class DestinationDescription extends StatelessWidget {
  final String description;

  const DestinationDescription(this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: blackTextStyle.copyWith(
        fontSize: 14,
      ),
    );
  }
}

class DestinationCategory extends StatelessWidget {
  final String category;

  const DestinationCategory(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      category,
      style: blackTextStyle.copyWith(
        fontSize: 14,
      ),
    );
  }
}