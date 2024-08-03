// data/providers/midtrans_provider.dart
import 'package:dio/dio.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/bookings_model.dart';

class MidtransServices {
  final supabase = Supabase.instance.client;
  final dio = Dio();

  // load env
  MidtransServices() {
    dotenv.load();
  }

  // create payment link for orders
  Future<Map<String, dynamic>> createdPaymentUrl(Map<String, dynamic> data,
      List<BookingModels> busTransactionModel, double totalAmount) async {
    final apiUrl = dotenv.env['API_URL_CREATE_PAYMENT']!;

    final response = await dio.post(
      apiUrl,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to create transaction');
    }
  }
}
