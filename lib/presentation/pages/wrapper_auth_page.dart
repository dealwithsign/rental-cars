// presentation/pages/wrapper_auth_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:rents_cars_app/utils/fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WrapperAuth extends StatefulWidget {
  const WrapperAuth({super.key});

  @override
  State<WrapperAuth> createState() => _WrapperAuthState();
}

class _WrapperAuthState extends State<WrapperAuth> {
  late final SupabaseClient supabase;

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
    if (mounted) {
      checkUser();
    }
  }

  void _navigateTo(String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  void checkUser() {
    final user = supabase.auth.currentUser;
    print(user?.id);

    final authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      print('event: $event, session: $session');
    });
    if (user == null) {
      _navigateTo('/signIn');
    } else {
      _navigateTo('/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking login status
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: kWhiteColor,
      home: Scaffold(
        backgroundColor: kWhiteColor,
        body: Center(
          child: SpinKitThreeBounce(
            color: kPrimaryColor,
            size: 25.0,
          ),
        ),
      ),
    );
  }
}