// presentation/pages/car_detail_page.dart

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../../blocs/cars/cars_bloc.dart';
import '../../blocs/cars/cars_state.dart';
import '../../data/models/cars_model.dart';
import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';
import 'car_form_page.dart';

class CarDetailsScreen extends StatefulWidget {
  final CarsModels car;
  final String carFrom;
  final String carTo;
  final DateTime carDate;
  final int availableSeats;

  const CarDetailsScreen({
    super.key,
    required this.car,
    required this.carFrom,
    required this.carTo,
    required this.carDate,
    required this.availableSeats,
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: kWhiteColor,
      home: Scaffold(
        backgroundColor: kWhiteColor,
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
                Iconsax.arrow_left_2,
                color: kPrimaryColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // title: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       '${widget.carFrom} - ${widget.carTo}',
            //       style: blackTextStyle.copyWith(
            //         fontSize: 18,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     const SizedBox(height: 5),
            //     Text(
            //       DateFormat('EEEE, d MMMM yyyy', 'id_ID')
            //           .format(widget.carDate),
            //       style: blackTextStyle.copyWith(
            //         fontSize: 15,
            //         fontWeight: FontWeight.normal,
            //       ),
            //     ),
            //   ],
            // ),
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
            style: titleTextStyle.copyWith(
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
          child: Text(
            fetchedCar.carDesc,
            style: blackTextStyle.copyWith(
              fontSize: 14,
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
            "Fasilitas",
            style: titleTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: defaultMargin),
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
            "Lokasi ",
            style: titleTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: defaultMargin),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: _buildLocations(fetchedCar),
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
            "Syarat & Ketentuan",
            style: titleTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: defaultMargin),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: _buildTermsText(),
        ),
        SizedBox(height: defaultMargin * 2),
        _buildBottomBar(),
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
          Container(
            decoration: BoxDecoration(
              color: kBackgroundColor,
              shape: BoxShape.circle,
            ),
            padding:
                EdgeInsets.all(defaultMargin / 3), // Adjust padding as needed
            child: Icon(
              Iconsax.task_square,
              color: kPrimaryColor,
              size: 20,
            ),
          ),
          SizedBox(width: defaultMargin),
          Expanded(
            child: Text(
              facility,
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: CustomButton(
          title: 'Lanjut ke Form Pemesanan',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookWithDriverPage(
                  car: widget.car,
                  carFrom: widget.carFrom,
                  carTo: widget.carTo,
                  carDate: widget.carDate,
                  availableSeats: widget.car.availableSeats -
                      widget.car.selectedSeats, // Pass the calculated value
                ),
              ),
            );
          },
        ),
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

  // Widget termAndCondition()
  Widget _buildTermsText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "1. ",
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            SizedBox(width: defaultMargin / 2),
            Expanded(
              child: Text(
                "Penumpang setidaknya 60 menit sebelum keberangkatan sudah mempersiapkan diri. Keterlambatan penumpang dapat menyebabkan tiket dibatalkan secara sepihak dan tidak mendapatkan pengembalian dana.",
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: defaultMargin / 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "2. ",
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            SizedBox(width: defaultMargin / 2),
            Expanded(
              child: Text(
                "Waktu keberangkatan yang tertera di aplikasi adalah waktu lokal di lokasi keberangkatan.",
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: defaultMargin / 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "3. ",
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            SizedBox(width: defaultMargin / 2),
            Expanded(
              child: Text(
                "Ukuran dan berat barang bawaan penumpang tidak boleh melebihi aturan yang di tentukan oleh agen. Penumpang yang membawa barang bawaan melebihi aturan akan dikenakan biaya tambahan.",
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: defaultMargin / 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "4. ",
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            SizedBox(width: defaultMargin / 2),
            Expanded(
              child: Text(
                "Perubahan jadwal keberangkatan tidak dapat di lakukan untuk pemesanan menggunakan aplikasi.",
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: defaultMargin / 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "5. ",
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            SizedBox(width: defaultMargin / 2),
            Expanded(
              child: Text(
                "Penumpang yang membatalkan perjalanan setelah melakukan pembayaran tiket tidak dapat membatalkan atau mengajukan pengembalian dana.",
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: defaultMargin),
                    Icon(
                      FontAwesomeIcons.solidStar,
                      color: kappBar,
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
