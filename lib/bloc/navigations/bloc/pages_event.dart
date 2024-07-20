part of 'pages_bloc.dart';

abstract class PagesEvent extends Equatable {
  const PagesEvent();

  @override
  List<Object> get props => [];
}

class PageTapped extends PagesEvent {
  final int index;

  const PageTapped(this.index);

  @override
  List<Object> get props => [index];
}
