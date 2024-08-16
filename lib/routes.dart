// routes.dart
import 'package:flutter/material.dart';

import 'data/models/ticket_model.dart';
import 'presentation/pages/be_apartner.dart';
import 'presentation/pages/car_detail_page.dart';
import 'presentation/pages/car_detail_ticket.dart';
import 'presentation/pages/car_form_page.dart';
import 'presentation/pages/car_list_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/midtrans_page.dart';
import 'presentation/pages/navigation_page.dart';
import 'presentation/pages/sign_in_page.dart';
import 'presentation/pages/sign_up_page.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/ticket_page.dart';
import 'presentation/pages/wrapper_auth_page.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/': (context) => const SplashScreen(),
    '/main': (context) => const NavigationScreen(),
    '/wrapper': (context) => const WrapperAuth(),
    '/home': (context) => const HomeScreen(),
    '/signIn': (context) => const SignInPage(),
    '/signUp': (context) => const SignUpPage(),
    // cars
    '/carListPage': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      return ListCarPage(
        carFrom: args['carFrom'],
        carTo: args['carTo'],
        carDate: args['carDate'],
        fetchedDataCar: const [],
      );
    },
    '/carDetailPage': (context) {
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

    '/payment-page': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return MidtransPayment(
        redirectUrl: args['redirectUrl'],
        token: args['token'],
      );
    },

    '/ticket-detail': (context) => TicketDetailScreen(
          ticket: ModalRoute.of(context)!.settings.arguments as TicketModels,
        ),

    '/ticket-page': (context) => const TicketScreen(),
    '/partner-page': (context) => const HowToBePartner(),
  };
}
