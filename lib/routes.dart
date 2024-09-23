// routes.dart
import 'package:flutter/material.dart';
import 'package:rents_cars_app/presentation/pages/forgot_password.dart';

import 'data/models/ticket_model.dart';
import 'data/models/touristdestination_model.dart';
import 'presentation/pages/be_apartner.dart';
import 'presentation/pages/car_detail_page.dart';
import 'presentation/pages/ticket_cancle_page.dart';
import 'presentation/pages/ticket_success_page.dart';
import 'presentation/pages/car_form_page.dart';
import 'presentation/pages/car_list_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/midtrans_page.dart';
import 'presentation/pages/navigation_page.dart';
import 'presentation/pages/sign_in_page.dart';
import 'presentation/pages/sign_up_page.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/terms_conditions.dart';
import 'presentation/pages/ticket_page.dart';
import 'presentation/pages/ticket_pending_page.dart';
import 'presentation/pages/touristdestination_detail_page.dart';
import 'presentation/pages/update_password.dart';
import 'presentation/pages/verify_otp.dart';
import 'presentation/pages/wrapper_auth_page.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/': (context) => const WrapperAuth(),
    '/main': (context) => const NavigationScreen(),
    '/wrapper': (context) => const WrapperAuth(),
    '/home': (context) => const HomeScreen(),
    '/signIn': (context) => const SignInPage(),
    '/signUp': (context) => const SignUpPage(),
    '/forgotPassword': (context) => const ForgotPassword(),
    '/verifyOTP': (context) => const VerifyOTP(),
    '/resetPassword': (context) => const UpdatePassword(),
    '/splashPage': (context) => const SplashScreen(),
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
    // '/carDetailPage': (context) {
    //   final args =
    //       ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //   return CarDetailsScreen(
    //     car: args['car'],
    //     carFrom: args['carFrom'],
    //     carTo: args['carTo'],
    //     carDate: args['carDate'],
    //   );
    // },
    // '/bookWithDriver': (context) {
    //   final args =
    //       ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //   return BookWithDriverPage(
    //     car: args['car'],
    //     carFrom: args['carFrom'],
    //     carTo: args['carTo'],
    //     carDate: args['carDate'],
    //   );
    // },

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
    '/term-conditions': (context) => const TermsAndConditions(),
    '/tiketPending': (context) => TicketPendingPage(
          ticket: ModalRoute.of(context)!.settings.arguments as TicketModels,
        ),

    '/ticketCancle': (context) => TicketCancelPage(
          ticket: ModalRoute.of(context)!.settings.arguments as TicketModels,
        ),

    // destinations
    '/touristDestinationDetailPage': (context) {
      final destination =
          ModalRoute.of(context)!.settings.arguments as TouristdestinationModel;
      return TouristdestinationDetailPage(destination: destination);
    },

    // midtrans payment
  };
}
