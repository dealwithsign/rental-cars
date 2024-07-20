part of 'booking_bloc.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final List<BookingModels> bookings;
  BookingSuccess(this.bookings);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
