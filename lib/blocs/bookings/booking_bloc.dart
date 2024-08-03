// blocs/bookings/booking_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:rents_cars_app/blocs/bookings/booking_event.dart';

import '../../data/models/bookings_model.dart';
import '../../data/services/booking_services.dart';

part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingServices bookingServices;
  BookingBloc(this.bookingServices) : super(BookingLoading()) {
    on<CreateBookingEvent>(
      (event, emit) async {
        emit(BookingLoading());
        try {
          final bookings = await bookingServices.saveBookingData(
            id: event.id,
            carModel: event.carModel,
            selectedDate: event.selectedDate,
            selectedTime: event.selectedTime,
            selectedPassengers: event.selectedPassengers,
            selectedLocationPick: event.selectedLocationPick,
            selectedLocationDrop: event.selectedLocationDrop,
            carFrom: event.carFrom,
            carTo: event.carTo,
            carDate: event.carDate,
            userId: event.userId,
            userName: event.userName,
            userPhone: event.userPhone,
            userEmail: event.userEmail,
            isPayment: event.isPayment,
            totalPayment: event.totalPayment,
          );

          emit(BookingSuccess(bookings as List<BookingModels>));
        } catch (e) {
          emit(BookingError(e.toString()));
        }
      },
    );
    on<FetchBookingsEvent>(
      (event, emit) async {
        emit(BookingLoading());
        try {
          final bookings = await bookingServices.getUserBookings(event.userId);
          emit(BookingSuccess(bookings));
        } catch (e) {
          emit(BookingError(e.toString()));
        }
      },
    );
    on<CreatePaymentUrl>(
      (event, emit) async {
        emit(BookingLoading());
        try {
          final paymentUrl = await bookingServices.createPaymentUrl(
            token: event.token,
            redirectUrl: event.redirectUrl,
            orderId: event.orderId,
            userId: event.userId,
            userName: event.userName,
            cityFrom: event.cityFrom,
            cityTo: event.cityTo,
            carName: event.carName,
            carDate: event.carDate,
            selectedTime: event.seletedTime,
            selectedPassengers: event.selectedPassengers,
            ownerCar: event.ownerCar,
            selectedLocationPick: event.selectedLocationPick,
            selectedLocationDrop: event.selectedLocationDrop,
            carId: event.carId,
            totalPayment: event.totalPayment,
          );
          emit(BookingSuccess(paymentUrl as List<BookingModels>));
        } catch (e) {
          emit(BookingError(e.toString()));
        }
      },
    );
    on<UpdateSeatCarsEvent>(
      (event, emit) async {
        emit(BookingLoading());
        try {
          final bookings = await bookingServices.updateCarSeat(
            carId: event.carId,
            carSeats: event.carSeats,
          );
          emit(BookingSuccess(bookings as List<BookingModels>));
        } catch (e) {
          emit(BookingError(e.toString()));
        }
      },
    );
  }
}
