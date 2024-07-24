import 'package:rents_cars_app/models/ticket.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketServices {
  final supabase = Supabase.instance.client;

  Future<List<TicketModels>> getUserTickets(String userId) async {
    List<TicketModels> tickets = [];
    try {
      final res = await supabase
          .from("payments")
          .select()
          .eq("user_id", userId)
          .order("created_at", ascending: false);
      print("Data Ticket: $res");
      if (res.isNotEmpty) {
        for (var row in res as List) {
          print("Row data: $row");
          TicketModels ticket = TicketModels.fromJson(row);
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
}
