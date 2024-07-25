part of 'tickets_bloc.dart';

abstract class TicketsState {}

class TicketsInitial extends TicketsState {}

class TicketsLoading extends TicketsState {}

class TicketsSuccess extends TicketsState {
  final List<TicketModels> tickets;
  TicketsSuccess(this.tickets);
}

class TicketsError extends TicketsState {
  final String message;
  TicketsError(this.message);
}
