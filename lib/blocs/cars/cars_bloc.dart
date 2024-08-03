// blocs/cars/cars_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rents_cars_app/blocs/cars/cars_state.dart';

import '../../data/services/cars_services.dart';

import 'cars_event.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final CarsServices carsServices;

  CarBloc(this.carsServices) : super(CarsLoading()) {
    on<FetchCarsEvent>((event, emit) async {
      emit(CarsLoading());
      try {
        final cars = await carsServices.getAllCars();
        print(cars);
        emit(CarsSuccess(cars));
      } catch (e) {
        emit(CarsError(e.toString()));
      }
    });
    on<FetchCarsScheduleEvent>((event, emit) async {
      emit(CarsLoading());
      try {
        final cars = await carsServices.getScheduleData(
          carFrom: event.carFrom,
          carTo: event.carTo,
          carDate: DateTime.parse(event.carDate),
        );
        print(cars);
        emit(CarsSuccess(cars));
      } catch (e) {
        emit(CarsError(e.toString()));
      }
    });
  }
}
