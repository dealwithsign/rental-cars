// presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/cars/cars_bloc.dart';
import '../../blocs/cars/cars_event.dart';
import '../../blocs/cars/cars_state.dart';
import '../../data/services/cars_services.dart';
import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';
import '../widgets/clip_path_widget.dart';

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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  kappBar,
                  kappBar,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                          SizedBox(height: defaultMargin),
                          Text(
                            'Rental Mobil Online ',
                            style: whiteTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Sewa mobil cukup di genggaman Anda \nkapan saja dan di mana saja.',
                            style: whiteTextStyle.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: defaultMargin),
                    _buildSearchTicket(),
                    SizedBox(height: defaultMargin),
                    Container(
                      color: kWhiteColor,
                      child: buildBody(),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
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
                  SizedBox(height: defaultMargin),
                  _buildHowToBePartners(),
                  SizedBox(height: defaultMargin * 2),
                  _buildOtherInformations(),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: defaultMargin * 8,
                    ),
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

  Widget _buildHowToBePartners() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/partnerPage');
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: kTransparentColor,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          side: BorderSide(
            color: kTransparentColor,
            width: 1.0,
          ),
        ),
        child: SizedBox(
          height: 110,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: const Color(0xffF1F3F4),
                  padding: EdgeInsets.all(defaultMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Daftarkan mobil Anda ke aplikasi kami & raih lebih banyak pelanggan.',
                        style: blackTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: bold,
                        ),
                      ),
                      SizedBox(height: defaultMargin),
                      Text(
                        'Cek disini →',
                        style: subTitleTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: double.infinity,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1612345642327-e79b84fd94f6?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTicket() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
      child: Card(
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultMargin / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mengapa sewa mobil di Aplikasi?',
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
            ),
          ),
          SizedBox(height: defaultMargin),
          _buildInfoRow(
            'Pilihan Tiket Lengkap',
            'Temukan tiket untuk berbagai jenis sewa mobil dan destinasi lewat aplikasi.',
            FontAwesomeIcons.ticket,
          ),
          SizedBox(height: defaultMargin),
          _buildInfoRow(
            'Beli Tiket Lebih Awal',
            'Dengan Aplikasi, kamu bisa pesan tiket lebih awal dan tidak kehabisan tiket.',
            FontAwesomeIcons.clock,
          ),
          SizedBox(height: defaultMargin),
          _buildInfoRow(
            'Beragam Metode Pembayaran',
            'Pilih metode pembayaran yang kamu inginkan, mulai dari transfer bank, scan QRIS, hingga pembayaran di minimarket terdekat.',
            FontAwesomeIcons.creditCard,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: kBackgroundColor,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(defaultMargin), // Adjust padding as needed
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
