import '../../../models/cars.dart';

abstract class CarState {}

class CarInitial extends CarState {}

class CarsLoading extends CarState {}

class CarsSuccess extends CarState {
  final List<CarsModels> cars;
  CarsSuccess(this.cars);
}

class CarsError extends CarState {
  final String message;
  CarsError(this.message);
}
