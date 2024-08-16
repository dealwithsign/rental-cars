// presentation/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/presentation/pages/sign_in_page.dart';
import 'package:rents_cars_app/presentation/pages/wrapper_auth_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
        seconds: 7,
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

    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      print('event: $event, session: $session');
    });
    if (user == null) {
      _navigateTo('/signUp');
    } else {
      _navigateTo('/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double imageHeight = screenSize.height * 0.10;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kWhiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.a,
                  size: imageHeight,
                  color: const Color(0xff087443),
                ),
                SizedBox(height: defaultMargin),
                Text(
                  'xfy.id',
                  style: blackTextStyle.copyWith(
                    fontSize: 20, // H1
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
