abstract class CarEvent {}

class FetchCarsEvent extends CarEvent {}

class LoadCars extends CarEvent {}

class FetchCarsScheduleEvent extends CarEvent {
  final String carFrom;
  final String carTo;
  final String carDate;

  FetchCarsScheduleEvent({
    required this.carFrom,
    required this.carTo,
    required this.carDate,
  });
}
