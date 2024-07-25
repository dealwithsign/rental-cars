import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:rents_cars_app/bloc/auth/bloc/auth_bloc.dart';
import 'package:rents_cars_app/bloc/bookings/bloc/booking_bloc.dart';
import 'package:rents_cars_app/bloc/cars/bloc/cars_bloc.dart';
import 'package:rents_cars_app/bloc/tickets/bloc/tickets_bloc.dart';
import 'package:rents_cars_app/models/ticket.dart';
import 'package:rents_cars_app/pages/auth/sign_in.dart';
import 'package:rents_cars_app/pages/screens/home.dart';
import 'package:rents_cars_app/pages/screens/midtrans/midtrans_page.dart';
import 'package:rents_cars_app/pages/splash.dart';
import 'package:rents_cars_app/pages/wrapper.dart';
import 'package:rents_cars_app/services/bookings/booking_services.dart';
import 'package:rents_cars_app/services/ticket/ticket.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/src/messages/id_messages.dart' as id_messages;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/cars.dart';
import 'pages/accounts/edit_accounts.dart';
import 'pages/auth/sign_up.dart';
import 'bloc/navigations/bloc/pages_bloc.dart';
import 'pages/navigations/navigation.dart';
import 'pages/screens/book_with_driver.dart';
import 'pages/screens/cars_details.dart';
import 'pages/screens/cars_payment.dart';
import 'pages/screens/detail_ticket.dart';
import 'pages/screens/erros/list_cars_scheduled_404.dart';
import 'pages/screens/list_cars_scheduled.dart';
import 'services/cars/cars_services.dart';
import 'services/users/auth_services.dart';
import 'utils/fonts/constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Supabase.initialize(
    url: "https://bevwigjpkmsmfyixvwvb.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJldndpZ2pwa21zbWZ5aXh2d3ZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTU3MDMxNzcsImV4cCI6MjAxMTI3OTE3N30.J_gdbB7xOjKmPeKj3702hMO_1uTkkpXUFUgXSz-y_n4",
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

// Deklarasi nama-nama rute aplikasi
Map<String, WidgetBuilder> getRoutes() {
  return {
    '/': (context) => const SplashScreen(),
    '/main': (context) => NavigationScreen(),
    // '/main': (context) => const WrapperAuth(),
    '/home': (context) => const HomeScreen(),
    '/signIn': (context) => const SignInPage(),
    '/signUp': (context) => const SignUpPage(),

    // cars
    '/listCarSchedule': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      return ListCarPage(
        carFrom: args['fetchedData'],
        carTo: args['cityFrom'],
        carDate: args['cityDestinations'],
        fetchedDataCar: [],
      );
    },
    '/listCarDetails': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return CarDetailsScreen(
        car: args['car'],
        carFrom: args['carFrom'],
        carTo: args['carTo'],
        carDate: args['carDate'],
      );
    },
    '/bookWithDriver': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return BookWithDriverPage(
        car: args['car'],
        carFrom: args['carFrom'],
        carTo: args['carTo'],
        carDate: args['carDate'],
      );
    },
    // payment
    '/carsPayment': (context) => const CarsPayment(),
    '/payment-page': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return MidtransPayment(
        redirectUrl: args['redirectUrl'],
        token: args['token'],
      );
    },
    // tickets
    '/ticket-detail': (context) => TicketDetailScreen(
        ticket: ModalRoute.of(context)!.settings.arguments as TicketModels),
    // accounts
    '/editAccounts': (context) => const EditAccounts(),
  };
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
