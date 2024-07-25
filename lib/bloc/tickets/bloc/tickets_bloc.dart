import 'package:bloc/bloc.dart';
import 'package:rents_cars_app/services/ticket/ticket.dart';

import '../../../models/ticket.dart';

part 'tickets_event.dart';
part 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final TicketServices ticketServices;
  TicketsBloc(this.ticketServices) : super(TicketsLoading()) {
    on<FetchTransactionsUserEvent>((event, emit) async {
      emit(TicketsLoading());
      try {
        final tickets = await ticketServices.getUserTickets(event.userId);
        emit(TicketsSuccess(tickets));
      } catch (e) {
        emit(TicketsError(e.toString()));
      }
    });
  }
}
