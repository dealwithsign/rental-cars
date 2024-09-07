// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rents_cars_app/blocs/auth/auth_bloc.dart';
import 'package:rents_cars_app/blocs/bookings/booking_bloc.dart';
import 'package:rents_cars_app/blocs/cars/cars_bloc.dart';
import 'package:rents_cars_app/blocs/tickets/tickets_bloc.dart';
import 'package:rents_cars_app/blocs/tourist_destination/tourist_destination_bloc.dart';
import 'package:rents_cars_app/data/services/booking_services.dart';
import 'package:rents_cars_app/data/services/ticket_services.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/src/messages/id_messages.dart' as id_messages;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'blocs/navigations/pages_bloc.dart';
import 'data/services/cars_services.dart';
import 'data/services/authentication_services.dart';
import 'data/services/tourist_destination.dart';
import 'utils/fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes.dart'; // import routes.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env.dev");

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: dotenv.env['supabaseUrl']!,
    anonKey: dotenv.env['supabaseAnonKey']!,
  );
  // Set locale messages untuk timeago
  timeago.setLocaleMessages('id', id_messages.IdMessages());

  // Inisialisasi date formatting untuk 'id_ID'
  await initializeDateFormatting('id_ID');

  // Menjalankan aplikasi Flutter
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            AuthServices(),
          ),
        ),
        BlocProvider<PagesBloc>(
          create: (context) => PagesBloc(),
        ),
        BlocProvider<CarBloc>(
          create: (context) => CarBloc(
            CarsServices(),
          ),
        ),
        BlocProvider<BookingBloc>(
          create: (context) => BookingBloc(
            BookingServices(),
          ),
        ),
        BlocProvider<TicketsBloc>(
          create: (context) => TicketsBloc(
            TicketServices(),
          ),
        ),
        BlocProvider<TouristDestinationBloc>(
          create: (context) => TouristDestinationBloc(
            TouristDestinationServices(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Rents Cars App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: kWhiteColor,
          ),
          scaffoldBackgroundColor: kWhiteColor,
          appBarTheme: AppBarTheme(
            backgroundColor: kWhiteColor,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardColor: kWhiteColor,
          cardTheme: CardTheme(
            color: kWhiteColor,
            shadowColor: kWhiteColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                defaultRadius,
              ),
            ),
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('id', 'ID'),
        ],
        routes: getRoutes(),
      ),
    );
  }
}
