// blocs/navigations/pages_state.dart
part of 'pages_bloc.dart';

abstract class PagesState extends Equatable {
  const PagesState();

  @override
  List<Object> get props => [];
}

class PagesInitial extends PagesState {}

class PageLoading extends PagesState {}

class PageLoaded extends PagesState {
  final int currentIndex;

  const PageLoaded(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}
