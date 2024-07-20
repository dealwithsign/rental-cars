import 'package:rents_cars_app/models/bookings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/cars.dart';

class BookingServices {
  final supabase = Supabase.instance.client;

  Future<bool> saveBookingData({
    required CarsModels carModel,
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
  }) async {
    try {
      var uuid = Uuid();
      String bookingId = uuid.v1().replaceAll('-', '').substring(0, 8);
      String formattedUserPhone =
          userPhone.startsWith('0') ? userPhone : '0$userPhone';

      // Prepare the data for insertion
      final bookingData = {
        'id': bookingId,
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
        'isPayment': carModel.isPayment,
        'total_payment': totalPayment,
        'created_at': DateTime.now().toIso8601String(),

        // Consider adding user-related information if necessary
      };

      // Insert the booking data into the database
      final res = await supabase.from('bookings').insert(bookingData);
      print(res);
      // Log success or handle response
      print("Booking saved successfully: $bookingId");

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
  //
}
