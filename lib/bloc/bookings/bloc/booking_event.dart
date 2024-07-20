import 'package:rents_cars_app/models/cars.dart';

abstract class BookingEvent {}

class FetchBookingsEvent extends BookingEvent {
  final String userId;
  FetchBookingsEvent(this.userId);
}

class CreateBookingEvent extends BookingEvent {
  final String id;
  final CarsModels carModel;
  final DateTime selectedDate;
  final String selectedTime;
  final int selectedPassengers;
  final String selectedLocationPick;
  final String selectedLocationDrop;
  final String carFrom;
  final String carTo;
  final DateTime carDate;
  final String userId;
  final String userName;
  final String userPhone;
  final String userEmail;
  final int totalPayment;

  CreateBookingEvent({
    required this.carModel,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedPassengers,
    required this.selectedLocationPick,
    required this.selectedLocationDrop,
    required this.carFrom,
    required this.carTo,
    required this.carDate,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.totalPayment,
    required this.id,
  });

  List<Object> get props => [
        id,
        carModel,
        selectedDate,
        selectedTime,
        selectedPassengers,
        selectedLocationPick,
        selectedLocationDrop,
        carFrom,
        carTo,
        carDate,
        userId,
        userName,
        userPhone,
        userEmail,
        totalPayment,
      ];
}
