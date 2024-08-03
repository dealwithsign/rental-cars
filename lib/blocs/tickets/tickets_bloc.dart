// blocs/tickets/tickets_bloc.dart
import 'package:bloc/bloc.dart';

import 'package:rents_cars_app/data/services/ticket_services.dart';

import '../../data/models/ticket_model.dart';

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
