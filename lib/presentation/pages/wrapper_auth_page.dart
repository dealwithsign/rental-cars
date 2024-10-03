// presentation/pages/wrapper_auth_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rents_cars_app/presentation/pages/splash_page.dart';
import 'package:rents_cars_app/utils/fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'navigation_page.dart';

class WrapperAuth extends StatefulWidget {
  const WrapperAuth({super.key});

  @override
  State<WrapperAuth> createState() => _WrapperAuthState();
}

class _WrapperAuthState extends State<WrapperAuth> {
  late final SupabaseClient supabase;
  static const Duration loginCheckDelay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;
    _initiateLoginCheck();
  }

  Future<void> _initiateLoginCheck() async {
    await Future.delayed(loginCheckDelay);
    if (mounted) {
      _checkUserStatus();
    }
  }

  void _navigateTo(Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  void _checkUserStatus() {
    final user = supabase.auth.currentUser;
    print(user?.id);

    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      print('event: $event, session: $session');
    });

    if (user == null) {
      _navigateTo(const SplashScreen());
    } else {
      _navigateTo(const NavigationScreen());
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SpinKitThreeBounce(
        color: kPrimaryColor,
        size: 25.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking login status
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: kWhiteColor,
      home: Scaffold(
        backgroundColor: kWhiteColor,
        body: _buildLoadingIndicator(),
      ),
    );
  }
}
