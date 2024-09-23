// presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/blocs/tourist_destination/tourist_destination_bloc.dart';
import 'package:rents_cars_app/blocs/tourist_destination/tourist_destination_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/cars/cars_bloc.dart';
import '../../blocs/cars/cars_event.dart';
import '../../blocs/cars/cars_state.dart';
import '../../blocs/tourist_destination/tourist_destination_event.dart';
import '../../data/services/cars_services.dart';
import '../../utils/fonts.dart';
import '../widgets/button_widget.dart';
import '../widgets/clip_path_widget.dart';
import 'be_apartner.dart';
import 'car_list_page.dart';
import 'touristdestination_detail_page.dart';

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
    context.read<TouristDestinationBloc>().add(FetchTouristDestinationEvent());

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  final CarsServices getSchedule = CarsServices();
  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0.0,
        title: Text(
          'Lalan',
          style: titleWhiteTextStyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xff018053),
                Color(0xff018053),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: ClipPathClass(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xff018053),
                          Color(0xff018053),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
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
                            'Beli Tiket Mobil Antar Kota',
                            style: buttonColor.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Pesan tiketmu kapan saja dan di mana saja',
                            style: buttonColor.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: defaultMargin),
                    _buildSearchTicket(),
                    SizedBox(height: defaultMargin),
                    Divider(
                      color: kBackgroundColor,
                      thickness: 5,
                    ),
                    Container(
                      color: kWhiteColor,
                      child: buildBody(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        SizedBox(height: defaultMargin / 2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: _buildHowToBePartners(),
        ),
        SizedBox(height: defaultMargin),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: defaultMargin),
              Text(
                "Destinasi Liburan Pilihan",
                style: titleTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: defaultMargin / 2),
              Text(
                "Temukan inpirasi liburan dengan destinasi \nmenarik di Tana Toraja",
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: defaultMargin),
              _buildOtherInformations(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: defaultMargin * 4,
          ),
        ),
      ],
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListCarPage(
                        carFrom: selectedFrom,
                        carTo: selectedTo,
                        carDate: selectedDate,
                        fetchedDataCar: const [],
                      ),
                    ),
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
                SizedBox(height: defaultMargin / 2),
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
                    style: titleTextStyle.copyWith(
                      fontSize: 18,
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
                              'Semua titik di lokasi ini',
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
                          style: titleTextStyle.copyWith(
                            fontSize: 18,
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
                  SizedBox(height: defaultMargin / 2),
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

  Widget _buildInfoItem(
      String title,
      String description,
      IconData icon,
      Color iconColor,
      List<Color> gradientColors // New parameter for gradient colors
      ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: kWhiteColor,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        side: BorderSide(
          color: kDivider,
          width: 1.0,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                gradientColors, // Use the gradient colors passed to the method
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            SizedBox(height: defaultMargin),
            Text(
              title,
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: defaultMargin / 2),
            Text(
              description,
              style: subTitleTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherInformations() {
    return BlocBuilder<TouristDestinationBloc, TouristDestinationState>(
      builder: (context, state) {
        if (state is TouristDestinationLoading) {
          return Skeletonizer(
            enabled: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: defaultMargin / 2),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      color: kWhiteColor,
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(defaultRadius),
                        side: BorderSide(
                          color: kDivider,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.6,
                            color: kBackgroundColor,
                          ),
                          Padding(
                            padding: EdgeInsets.all(defaultMargin),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 10,
                                  width: 100,
                                  color: kBackgroundColor,
                                ),
                                SizedBox(height: defaultMargin / 2),
                                Container(
                                  height: 10,
                                  width: 200,
                                  color: kBackgroundColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is TouristDestinationSuccess) {
          final touristDestination = state.touristDestination;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: touristDestination.map((destination) {
                    return Padding(
                      padding: EdgeInsets.only(right: defaultMargin / 2),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TouristdestinationDetailPage(
                                destination: destination,
                              ),
                            ),
                          );
                        },
                        child: _buildInfoTravel(
                          destination.name,
                          destination.location,
                          destination.imageUrl,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: defaultMargin * 2,
                ),
              ),
            ],
          );
        } else if (state is TouristDestinationError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildInfoTravel(
    String title,
    String location,
    String imageUrl, // New parameter for image URL
  ) {
    return SizedBox(
      height: 230,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: kWhiteColor,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          side: BorderSide(
            color: kDivider,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: titleTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    location,
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowToBePartners() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HowToBePartner()),
        );
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
        child: Stack(
          children: [
            // Background image
            // https://images.unsplash.com/photo-1612345642327-e79b84fd94f6?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.14,
              width: double.infinity,
              child: Image.network(
                'https://images.unsplash.com/photo-1600320254374-ce2d293c324e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                fit: BoxFit.cover,
              ),
            ),
            // Semi-transparent overlay with custom colors
            Container(
              height: MediaQuery.of(context).size.height * 0.14,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // const Color(0xff018053), // Overlay dengan warna hijau
                    kPrimaryColor,
                    kPrimaryColor.withOpacity(0.5), // Transparan
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
            ),
            // Text content
            Padding(
              padding: EdgeInsets.all(defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Daftarkan mobilmu ke aplikasi kami dan raih \nlebih banyak pelanggan',
                    style: buttonColor.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: defaultMargin),
                  Text(
                    'Cek disini →',
                    style: buttonColor.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
