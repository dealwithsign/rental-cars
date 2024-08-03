// presentation/pages/car_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../../blocs/cars/cars_bloc.dart';
import '../../blocs/cars/cars_state.dart';
import '../../data/models/cars_model.dart';
import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';

class CarDetailsScreen extends StatefulWidget {
  final CarsModels car;
  final String carFrom;
  final String carTo;
  final DateTime carDate;

  const CarDetailsScreen({
    super.key,
    required this.car,
    required this.carFrom,
    required this.carTo,
    required this.carDate,
  });

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          if (state is CarsLoading) {
            return Center(
              child: SpinKitThreeBounce(
                color: kPrimaryColor,
                size: 25.0,
              ),
            );
          } else if (state is CarsSuccess) {
            final fetchedCar =
                state.cars.firstWhere((c) => c.id == widget.car.id);
            return _buildCarDetails(fetchedCar);
          } else if (state is CarsError) {
            return const Center(
                child: Text('Terjadi kesalahan saat memuat data'));
          } else {
            return const Center(child: Text('Data tidak tersedia'));
          }
        },
      ),
    );
  }

  Widget _buildCarDetails(CarsModels fetchedCar) {
    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: kWhiteColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                LineIcons.angleLeft,
                color: kPrimaryColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.carFrom} - ${widget.carTo}',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat('EEEE, d MMM', 'id_ID').format(widget.carDate),
                  style: blackTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildCarImage(fetchedCar),
            ),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildCarInfo(fetchedCar),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarImage(CarsModels fetchedCar) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(),
          child: ClipRRect(
            child: Image.network(fetchedCar.carLogo, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  Widget _buildCarInfo(CarsModels fetchedCar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: defaultMargin),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Text(
            fetchedCar.carName,
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Text(
            'Dioperasikan oleh ${fetchedCar.ownerCar}',
            style: subTitleTextStyle.copyWith(
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(height: defaultMargin),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Row(
            children: [
              Row(
                children: [
                  FaIcon(
                    LineIcons.suitcase,
                    size: 20,
                    color: kPrimaryColor,
                  ),
                  SizedBox(width: defaultMargin),
                  Text(
                    '${fetchedCar.availableSeats} bagasi',
                    style: subTitleTextStyle.copyWith(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(width: defaultMargin),
              Row(
                children: [
                  FaIcon(
                    LineIcons.userFriends,
                    size: 20,
                    color: kPrimaryColor,
                  ),
                  SizedBox(width: defaultMargin),
                  Text(
                    '${fetchedCar.availableSeats} kursi',
                    style: subTitleTextStyle.copyWith(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: defaultMargin),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Text(
            fetchedCar.carDesc,
            style: blackTextStyle.copyWith(
              fontSize: 15,
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
          child: Text(
            "Reviews",
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: _buildUsersReview(),
        ),
        SizedBox(height: defaultMargin),
        Divider(
          color: kBackgroundColor,
          thickness: 5,
        ),
        SizedBox(height: defaultMargin),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Text(
            "Layanan Rental",
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFacilityRow(fetchedCar.facility1),
              _buildFacilityRow(fetchedCar.facility2),
              _buildFacilityRow(fetchedCar.facility3),
              _buildFacilityRow(fetchedCar.facility4),
            ],
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
          child: Text(
            "Lokasi Rental",
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: _buildLocations(fetchedCar),
        ),
        SizedBox(height: defaultMargin * 2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: _buildBottomBar(),
        ),
      ],
    );
  }

  Widget _buildCarDetailsRow(IconData icon, String text) {
    return Container(
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(
          defaultRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            FaIcon(
              icon,
              size: 15,
              color: kIcon,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: subTitleTextStyle.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityRow(String facility) {
    return Container(
      padding: EdgeInsets.all(defaultMargin),
      margin: EdgeInsets.only(bottom: defaultMargin / 2),
      decoration: BoxDecoration(
        border: Border.all(color: kDivider),
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Row(
        children: [
          Icon(
            LineIcons.checkCircleAlt,
            size: 20,
            color: kPrimaryColor,
          ),
          SizedBox(width: defaultMargin),
          Text(
            facility,
            style: blackTextStyle.copyWith(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: defaultMargin),
      decoration: BoxDecoration(
        color: kWhiteColor,
        border: Border(top: BorderSide(color: kBackgroundColor, width: 2.5)),
      ),
      child: CustomButton(
        title: 'Lanjut ke Form Pemesanan',
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/bookWithDriver',
            arguments: {
              'car': widget.car,
              'carFrom': widget.carFrom,
              'carTo': widget.carTo,
              'carDate': widget.carDate,
            },
          );
        },
      ),
    );
  }

  Widget _buildLocations(CarsModels car) {
    Set<Marker> markers = {
      Marker(
        markerId: MarkerId(car.id.toString()),
        position: LatLng(car.latitude, car.longitude),
        infoWindow: InfoWindow(
          snippet: car.ownerCar,
          title: car.carName,
        ),
      ),
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(defaultRadius),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        color: kBackgroundColor,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(car.latitude, car.longitude),
            zoom: 14,
          ),
          markers: markers,
        ),
      ),
    );
  }

  Widget _buildUsersReview() {
    List<Map<String, String>> reviews = [
      {
        "rating": "5.0",
        "date": "15 Juli 1824",
        "review": "Excellent service and car quality.",
        "user": "Braiyen Massora",
      },
      {
        "rating": "4.5",
        "date": "12 Juli 1824",
        "review": "Very good experience, but could be improved.",
        "user": "Jhon Wick",
      },
      {
        "rating": "4.0",
        "date": "10 Juli 1824",
        "review": "Good car, but the pickup process was slow.",
        "user": "John Travolta",
      },
      // Add more reviews as needed
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            margin: EdgeInsets.only(right: defaultMargin),
            padding: EdgeInsets.all(defaultMargin),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(defaultRadius),
              border: Border.all(color: kDivider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${review["rating"]}',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: defaultMargin),
                    Icon(
                      LineIcons.starAlt,
                      color: kIcon,
                      size: 15,
                    ),
                  ],
                ),
                SizedBox(height: defaultMargin),
                Text(
                  review["user"]!,
                  style: blackTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  review["date"]!,
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    review["review"]!,
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
