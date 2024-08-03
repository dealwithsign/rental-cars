// presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/blocs/auth/auth_bloc.dart';
import 'package:rents_cars_app/blocs/cars/cars_bloc.dart';
import 'package:rents_cars_app/blocs/cars/cars_state.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../../blocs/auth/auth_event.dart';

import '../../blocs/cars/cars_event.dart';
import '../../data/models/cars_model.dart';
import '../../data/services/cars_services.dart';
import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';
import 'car_list_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFrom = 'Toraja';
  String selectedTo = 'Makassar';
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetCurrentUserRequested());
    context.read<CarBloc>().add(FetchCarsEvent());

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  final CarsServices getSchedule = CarsServices();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Logo",
          style: whiteTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                kappBar,
                kappBar,
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: [
            ClipPath(
              clipper: ClipPathClass(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      kappBar,
                      kappBar,
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang',
                        style: whiteTextStyle.copyWith(
                          fontWeight: bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Pesan Mobil Sewa-mu Sekarang!',
                        style: whiteTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: defaultMargin),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: _buildSearchTicket(),
                ),
                SizedBox(height: defaultMargin),
                Divider(
                  color: kDivider,
                  thickness: 5,
                ),
                SizedBox(height: defaultMargin),
                buildBody(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return BlocBuilder<CarBloc, CarState>(
      builder: (context, state) {
        if (state is CarsLoading) {
          return Center(
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 25.0,
            ),
          );
        } else if (state is CarsSuccess) {
          return Skeletonizer(
            enabled: isLoading,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Column(
                children: [
                  // buildPartnerRental(state.cars),
                  // SizedBox(height: defaultMargin * 2),
                  _buildOtherInformations(),
                  Padding(
                    padding: EdgeInsets.only(bottom: defaultMargin * 6),
                  ),
                ],
              ),
            ),
          );
        } else if (state is CarsError) {
          return const Center(
            child: Text('Failed to fetch data'),
          );
        }
        return Container();
      },
    );
  }

  Widget buildPartnerRental(List<CarsModels> cars) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Partner Rental',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
        SizedBox(height: defaultMargin),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cars.map((car) {
              return Card(
                clipBehavior: Clip.antiAlias,
                color: kWhiteColor,
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultRadius),
                  side: BorderSide(
                    color: kDivider,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(car.carLogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car.ownerCar,
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            car.carDesc.length > 18
                                ? '${car.carDesc.substring(0, 18)}...'
                                : car.carDesc,
                            style: subTitleTextStyle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                LineIcons.starAlt,
                                size: 15,
                                color: descGrey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "5.2",
                                style: subTitleTextStyle.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTicket() {
    return Card(
      color: kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        side: BorderSide(
          color: kDivider,
          width: 1.0,
        ),
      ),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          children: [
            _buildCityPicker('Pilih Kota Asal', selectedFrom, (String city) {
              setState(() {
                selectedFrom = city;
              });
            }),
            SizedBox(height: defaultMargin),
            _buildCityPicker('Pilih Kota Tujuan', selectedTo, (String city) {
              setState(() {
                selectedTo = city;
              });
            }),
            SizedBox(height: defaultMargin),
            _buildDatePicker('Pilih Tanggal Jemput', selectedDate,
                (DateTime date) {
              setState(() {
                selectedDate = date;
              });
            }),
            SizedBox(height: defaultMargin * 2),
            CustomButton(
              title: "Cari Mobil",
              onPressed: () async {
                context.read<CarBloc>().add(
                      FetchCarsScheduleEvent(
                        carFrom: selectedFrom,
                        carTo: selectedTo,
                        carDate: selectedDate.toString(),
                      ),
                    );
                Navigator.pushNamed(
                  context,
                  '/carListPage',
                  arguments: {
                    'carFrom': selectedFrom,
                    'carTo': selectedTo,
                    'carDate': selectedDate,
                    'fetchedDataCar': const [],
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityPicker(
      String label, String selectedCity, Function(String) onCitySelected) {
    return GestureDetector(
      onTap: () => _showCitySelectionModal(context, onCitySelected),
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(defaultRadius),
          border: Border.all(
            color: kDivider,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(width: defaultMargin),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: subTitleTextStyle.copyWith(
                    fontSize: 14,
                  ),
                ),
                Text(
                  selectedCity,
                  style: blackTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCitySelectionModal(
      BuildContext context, Function(String) onCitySelected) {
    showModalBottomSheet(
      backgroundColor: kWhiteColor,
      context: context,
      builder: (BuildContext context) {
        List<String> cities = ['Toraja', 'Makassar', 'Morowali'];
        return Container(
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(defaultRadius),
              topRight: Radius.circular(defaultRadius),
            ),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                56.0 -
                MediaQuery.of(context).padding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(defaultMargin),
                  child: Text(
                    "Pilih Kota",
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cities[index],
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: bold,
                              ),
                            ),
                            Text(
                              'Semua terminal / titik keberangkatan di lokasi ini',
                              style: subTitleTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: bold,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          onCitySelected(cities[index]);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDatePicker(
      String label, DateTime selectedDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
          backgroundColor: kWhiteColor,
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(defaultRadius),
                  topRight: Radius.circular(defaultRadius),
                ),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    56.0 -
                    MediaQuery.of(context).padding.top,
                child: Theme(
                  data: ThemeData(
                    colorScheme: ColorScheme.light(
                      primary: kPrimaryColor,
                      onPrimary: Colors.white,
                      surface: kPrimaryColor,
                      onSurface: descGrey,
                    ),
                    dialogBackgroundColor: kWhiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(defaultMargin),
                        child: Text(
                          label,
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CalendarDatePicker(
                          initialDate: selectedDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2100),
                          onDateChanged: (DateTime value) {
                            onDateSelected(value);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(defaultRadius),
          border: Border.all(
            color: kDivider,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(width: defaultMargin),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    DateFormat('EEE, dd MMMM yyyy', 'id_ID')
                        .format(selectedDate),
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherInformations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lebih Hemat',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
        SizedBox(height: defaultMargin),
        _buildInfoRow(
          'Pilihan Tiket Lengkap',
          'Temukan tiket untuk berbagai jenis sewa mobil dan destinasi lewat aplikasi.',
          FontAwesomeIcons.car,
        ),
        SizedBox(height: defaultMargin),
        _buildInfoRow(
          'Bebas Antre',
          'Ngak perlu antre di terminal. Kamu bisa pesan mobil dari mana saja, kapan pun kamu mau.',
          FontAwesomeIcons.clock,
        ),
        SizedBox(height: defaultMargin),
        _buildInfoRow(
          'Beli Tiket Lebih Awal',
          'Dengan Aplikasi, kamu bisa pesan tiket lebih awal dan tidak kehabisan tiket.',
          FontAwesomeIcons.ticket,
        ),
        SizedBox(height: defaultMargin),
        _buildInfoRow(
          'Beragam Metode Pembayaran',
          'Pilih metode pembayaran yang kamu inginkan, mulai dari transfer bank, scan QRIS, hingga pembayaran di minimarket terdekat.',
          FontAwesomeIcons.creditCard,
        ),
        SizedBox(height: defaultMargin),
      ],
    );
  }

  Widget _buildInfoRow(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: kBackgroundColor,
          child: Icon(
            icon,
            color: kappBar,
            size: 25,
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
                  fontSize: 15,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
