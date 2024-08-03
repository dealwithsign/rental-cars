// blocs/navigations/pages_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pages_event.dart';
part 'pages_state.dart';

class PagesBloc extends Bloc<PagesEvent, PagesState> {
  PagesBloc() : super(const PageLoaded(0)) {
    // Change this line
    on<PageTapped>((event, emit) {
      emit(PageLoaded(event.index));
    });
  }
}
