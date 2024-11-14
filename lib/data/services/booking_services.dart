// data/services/booking_services.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/bookings_model.dart';
import '../models/cars_model.dart';

class BookingServices {
  final supabase = Supabase.instance.client;

  Future<bool> saveBookingData({
    required CarsModels carModel,
    required String id,
    required DateTime selectedDate,
    required String selectedTime,
    required int selectedPassengers,
    required String selectedLocationPick,
    required String selectedLocationDrop,
    required String carFrom,
    required String carTo,
    required DateTime carDate,
    required String userId,
    required String userName,
    required String userPhone,
    required String userEmail,
    required int totalPayment,
    required bool isPayment,
  }) async {
    try {
      // var uuid = Uuid();
      // String bookingId = uuid.v1().replaceAll('-', '').substring(0, 8);
      String formattedUserPhone =
          userPhone.startsWith('0') ? userPhone : '0$userPhone';

      // Prepare the data for insertion
      final bookingData = {
        'id': id,
        'car_id': carModel.id,
        'car_name': carModel.carName,
        'selected_date': selectedDate.toIso8601String(),
        'selected_time': selectedTime,
        'selected_passengers': selectedPassengers,
        'selected_location_pick': selectedLocationPick,
        'selected_location_drop': selectedLocationDrop,
        'car_from': carFrom,
        'car_to': carTo,
        'car_date': carDate.toIso8601String(),
        'user_id': userId,
        'user_name': userName,
        'user_phone': formattedUserPhone,
        'user_email': userEmail,
        'is_payment': carModel.isPayment,
        'total_payment': totalPayment,
        'created_at': DateTime.now().toIso8601String(),
        // Consider adding user-related information if necessary
      };

      // Insert the booking data into the database
      final res = await supabase.from('bookings').insert(bookingData);
      print(res);
      // Log success or handle response
      print("Booking saved successfully: $res");

      return true; // Indicate success
    } catch (e) {
      // Log or handle specific errors more granularly if needed
      print("Error saving booking data: $e");
      return false; // Indicate failure
    }
  }

  Future<List<BookingModels>> getUserBookings(String userId) async {
    List<BookingModels> bookings = [];
    try {
      final res = await supabase
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      print("Database response: $res"); // Print the raw response

      if (res.isNotEmpty) {
        for (var row in res as List) {
          print("Row data: $row"); // Print each row's data
          BookingModels booking = BookingModels.fromJson(row);
          print(
              "Parsed booking model: $booking"); // Print the parsed BookingModels object
          bookings.add(booking);
        }
      } else {
        print("No bookings found for user ID: $userId");
      }
    } catch (e) {
      print("Error fetching user bookings: $e");
    }
    return bookings;
  }

  // save token

  Future<void> createPaymentUrl({
    required String token,
    required String redirectUrl,
    required String userId,
    required String orderId,
    required String carId,
    required String userName,
    required String cityTo,
    required String cityFrom,
    required String carName,
    required DateTime carDate,
    required int selectedPassengers,
    required String selectedTime,
    required String ownerCar,
    required String selectedLocationPick,
    required String selectedLocationDrop,
    required int totalPayment,
    required String specialRequest,
    required String departureTime,
    required String userPhoneNumber,
    required String userEmail,
  }) async {
    try {
      final response = await supabase.from('tickets').insert({
        'id': token,
        'payment_links': redirectUrl,
        'user_id': userId, // Add this line
        'booking_id': orderId, // And this line
        'is_paid': false,
        'user_name': userName,
        'city_to': cityTo,
        'city_from': cityFrom,
        'car_name': carName,
        'car_date': carDate.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        'selected_passengers': selectedPassengers,
        'selected_date': selectedTime,
        'owner_car': ownerCar,
        'selected_location_pick': selectedLocationPick,
        'selected_location_drop': selectedLocationDrop,
        'car_id': carId,
        'total_payment': totalPayment,
        'departure_time': departureTime,
        'user_phone': userPhoneNumber,
        'user_email': userEmail,

        'special_request': specialRequest.isEmpty
            ? 'Tidak ada permintaan khusus'
            : specialRequest,
      });
      print("Payment saved successfully: $response");
    } catch (e) {
      print("Error saving token: $e)");
    }
  }

  // update transaction status with token and is_paid
  Future<void> updateOrderStatus(String id, bool status) async {
    try {
      final response = await supabase
          .from('tickets')
          .update({'is_paid': status}).eq('id', id);

      // Check if response is null
      if (response == null) {
        print('No response received from the server.');
        return;
      }

      // Log the entire response for debugging
      print('Response: ${response.data}');
      print('Error: ${response.error}');

      if (response.error != null) {
        throw Exception(
            'Failed to update order status: ${response.error!.message}');
      }

      print('Order status updated successfully');
    } catch (e) {
      print("Error updating order status: $e");
    }
  }

  // update seat in cars
  Future<void> updateCarSeat({
    required String carId,
    required int carSeats,
  }) async {
    try {
      final response = await supabase.from('cars').upsert({
        'id': carId,
        'reserved_seats': carSeats,
        'reserved_at': DateTime.now().toIso8601String()
      }).eq('id', carId);

      // Check if response is null
      if (response == null) {
        print('No response received from the server.');
        return;
      }

      // Log the entire response for debugging
      print('Response: ${response.data}');
      print('Error: ${response.error}');

      if (response.error != null) {
        throw Exception(
            'Failed to update car seat: ${response.error!.message}');
      }

      print('Car seat updated successfully');
    } catch (e) {
      print("Error updating car seat: $e");
    }
  }
}
