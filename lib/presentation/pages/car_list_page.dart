// presentation/pages/car_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';

import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../blocs/cars/cars_bloc.dart';

import '../../blocs/cars/cars_event.dart';
import '../../blocs/cars/cars_state.dart';
import '../../data/models/cars_model.dart';
import '../../utils/fonts.dart';

import '../widgets/context_menu.dart';
import 'car_detail_page.dart';

class ListCarPage extends StatefulWidget {
  final List<CarsModels> fetchedDataCar;
  final String carFrom;
  final String carTo;
  final DateTime carDate;

  const ListCarPage({
    super.key,
    required this.carFrom,
    required this.carTo,
    required this.carDate,
    required this.fetchedDataCar,
  });

  @override
  State<ListCarPage> createState() => _ListCarPageState();
}

class _ListCarPageState extends State<ListCarPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<CarBloc>().add(
          FetchCarsScheduleEvent(
            carFrom: widget.carFrom,
            carTo: widget.carTo,
            carDate: widget.carDate.toString(),
          ),
        );

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      leading: IconButton(
        icon: Icon(
          Iconsax.arrow_left_2,
          color: kPrimaryColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.carFrom} - ${widget.carTo}',
            style: titleTextStyle.copyWith(
              fontSize: 16,
              fontWeight: bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(widget.carDate),
            style: blackTextStyle.copyWith(
              fontSize: 15,
              fontWeight: regular,
            ),
          ),
        ],
      ),
      centerTitle: false,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return BlocBuilder<CarBloc, CarState>(
      builder: (context, state) {
        if (state is CarsLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          );
        } else if (state is CarsSuccess) {
          if (state.cars.isEmpty) {
            return Center(
              child: ContextMenu(
                title: 'Jadwal Tidak Ditemukan',
                message:
                    'Tidak ada jadwal untuk pilihanmu \nSilakan cari rute atau waktu yang berbeda',
                imagePath:
                    'assets/images/ticket_no_available.png', // Pass the image path as a string
                kPrimaryColor: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
                subTitleTextStyle: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            );
          }
          return _buildCarList(state.cars);
        } else if (state is CarsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Center(
            child: Container(),
          );
        }
      },
    );
  }

  Widget _buildCarList(List<CarsModels> cars) {
    return Skeletonizer(
      enabled: isLoading,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cars
              .map(
                (car) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailsScreen(
                            car: car,
                            carFrom: widget.carFrom,
                            carTo: widget.carTo,
                            carDate: widget.carDate,
                            availableSeats:
                                car.availableSeats - car.selectedSeats,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Card(
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
                              Image.network(
                                car.carLogo,
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: EdgeInsets.all(defaultMargin),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      car.carName,
                                      style: titleTextStyle.copyWith(
                                        fontSize: 18,
                                        fontWeight: bold,
                                      ),
                                    ),
                                    Text(
                                      'Dioperasikan oleh ${car.ownerCar}',
                                      style: subTitleTextStyle.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: defaultMargin),
                                    Text(
                                      'Sisa ${car.availableSeats - car.selectedSeats} kursi',
                                      style: redTextStyle.copyWith(
                                        fontSize: 14,
                                        fontWeight: bold,
                                      ),
                                    ),
                                    SizedBox(height: defaultMargin),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Mulai dari",
                                          style: subTitleTextStyle.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "Rp. ${NumberFormat('#,##0', 'id_ID').format(int.parse(car.carPrice))} / orang",
                                          style: blackTextStyle.copyWith(
                                            fontSize: 16,
                                            fontWeight: bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: defaultMargin)),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
