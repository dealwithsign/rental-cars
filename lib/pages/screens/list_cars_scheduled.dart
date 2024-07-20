import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rents_cars_app/utils/widgets/button.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:rents_cars_app/pages/screens/cars_details.dart';
import 'package:rents_cars_app/utils/fonts/constant.dart';

import '../../bloc/cars/bloc/cars_bloc.dart';
import '../../bloc/cars/bloc/cars_event.dart';
import '../../bloc/cars/bloc/cars_state.dart';
import '../../models/cars.dart';

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
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.carFrom} - ${widget.carTo}',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            DateFormat('EEEE, d MMM', 'id_ID').format(widget.carDate),
            style: blackTextStyle.copyWith(
              fontSize: 14,
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
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 25.0,
            ),
          );
        } else if (state is CarsSuccess) {
          if (state.cars.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.searchengin,
                    size: 100,
                    color: kIconColor,
                  ),
                  SizedBox(height: defaultMargin),
                  Text(
                    'Tidak Ada Rute Tersedia',
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: bold,
                    ),
                  ),
                  Text(
                    'Rute dan jadwal belum tersedia. Coba cari rute lainnya.',
                    style: subTitleTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: defaultMargin * 2),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: CustomButton(
                      title: "Cari Rute Lainnya",
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
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
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cars
              .map(
                (car) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/listCarDetails',
                        arguments: {
                          'car': car,
                          'carFrom': widget.carFrom,
                          'carTo': widget.carTo,
                          'carDate': widget.carDate,
                        },
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      color: kWhiteColor,
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            car.carLogo,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                  car.carName,
                                  style: blackTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
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
                                              FontAwesomeIcons.peopleGroup,
                                              size: 15,
                                              color: kIcon,
                                            ),
                                            SizedBox(width: defaultMargin),
                                            Text(
                                              '${car.availableSeats} kursi',
                                              style: subTitleTextStyle.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: defaultMargin),
                                    Container(
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
                                              FontAwesomeIcons.suitcaseRolling,
                                              size: 15,
                                              color: kIcon,
                                            ),
                                            SizedBox(width: defaultMargin),
                                            Text(
                                              '${car.availableSeats} bagasi',
                                              style: subTitleTextStyle.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: defaultMargin),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
