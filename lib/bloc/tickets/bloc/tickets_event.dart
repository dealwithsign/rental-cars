part of 'tickets_bloc.dart';

abstract class TicketsEvent {}

class FetchTransactionsUserEvent extends TicketsEvent {
  final String userId;
  FetchTransactionsUserEvent(this.userId);
}
