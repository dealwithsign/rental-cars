import 'package:bloc/bloc.dart';
import 'package:rents_cars_app/services/bookings/booking_services.dart';

import '../../../models/bookings.dart';
import 'booking_event.dart';

part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingServices bookingServices;
  BookingBloc(this.bookingServices) : super(BookingLoading()) {
    on<CreateBookingEvent>(
      (event, emit) async {
        emit(BookingLoading());
        try {
          final bookings = await bookingServices.saveBookingData(
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
              totalPayment: event.totalPayment);

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
  }
}
