// blocs/bookings/booking_event.dart

import '../../data/models/cars_model.dart';

abstract class BookingEvent {}

class FetchBookingsEvent extends BookingEvent {
  final String userId;
  FetchBookingsEvent(this.userId);
}

class CreatePaymentUrl extends BookingEvent {
  final token;
  final redirectUrl;
  final String orderId;
  final String userId;
  final String userName;
  final String cityTo;
  final String cityFrom;
  final String carName;
  final DateTime carDate;
  final String seletedTime;
  final int selectedPassengers;
  final String ownerCar;
  final String selectedLocationPick;
  final String selectedLocationDrop;
  final String carId;
  final int totalPayment;
  final String specialRequest;
  final String departureTime;

  CreatePaymentUrl({
    required this.token,
    required this.redirectUrl,
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.cityTo,
    required this.cityFrom,
    required this.carName,
    required this.carDate,
    required this.seletedTime,
    required this.selectedPassengers,
    required this.ownerCar,
    required this.selectedLocationPick,
    required this.selectedLocationDrop,
    required this.carId,
    required this.totalPayment,
    required this.specialRequest,
    required this.departureTime,
  });
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
  final bool isPayment;
  final String specialRequest;

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
    required this.isPayment,
    required this.specialRequest,
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
        isPayment,
        specialRequest,
      ];
}

// update seat cars event
class UpdateSeatCarsEvent extends BookingEvent {
  final String carId;
  final int carSeats;

  UpdateSeatCarsEvent({
    required this.carId,
    required this.carSeats,
  });
}
