// data/services/ticket_services.dart
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/ticket_model.dart';
import '../models/invoices_model.dart';

class TicketServices {
  final supabase = Supabase.instance.client;

  // get user tickets
  Future<List<TicketModels>> getUserTickets(String userId) async {
    List<TicketModels> tickets = [];
    try {
      final res = await supabase
          .from("tickets")
          .select()
          .eq("user_id", userId)
          .order("created_at", ascending: false);
      print("Data Ticket: $res");
      if (res.isNotEmpty) {
        for (var row in res as List) {
          print("Row data: $row");
          TicketModels ticket =
              TicketModels.fromJson(Map<String, dynamic>.from(row));
          print("Parsed ticket model: $ticket");
          tickets.add(ticket);
        }
      } else {
        print("No tickets found for user ID: $userId");
      }
    } catch (e) {
      print("Error fetching user tickets: $e");
    }
    return tickets;
  }

  Future<TicketModels> fetchPaymentDetails(String bookingId) async {
    final response = await http.get(Uri.parse(
        'https://midtrans-fumjwv6jv-dealwithsign.vercel.app/v1/$bookingId/status'));

    if (response.statusCode == 200) {
      return TicketModels.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load payment details');
    }
  }

  Future<void> saveInvoiceToSupabase(InvoicesModel invoice) async {
    final invoiceData = invoice.toJson();
    final response = await supabase.from('invoices').insert(invoiceData);

    if (response.error != null) {
      print('Error saving invoice: ${response.error!.message}');
    } else {
      print('Invoice saved successfully');
      print('Response data: ${response.data}');
    }
  }
}
