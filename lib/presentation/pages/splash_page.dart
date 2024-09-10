// presentation/pages/splash_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:rents_cars_app/presentation/widgets/button_sub_primary.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../utils/fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as SupabaseAuth;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SupabaseClient supabase;
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;
  }

  void _navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  void _navigateGoogleSignInSignUp(String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  void _handleSignInWithEmail() {
    _navigateTo('/signIn');
  }

  void _handleSignUpWithEmail() {
    _navigateTo('/signUp');
  }

  void _handleGoogleSignIn() async {
    context.read<AuthBloc>().add(SignInSignUpWithGoogleRequested());
    _navigateGoogleSignInSignUp('/wrapper');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kWhiteColor,
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildImage(MediaQuery.of(context).size.height * 0.5),
                      SizedBox(height: defaultMargin * 2),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: _buildTitle(),
                      ),
                      SizedBox(height: defaultMargin / 2),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: _buildTagline(),
                      ),
                      SizedBox(height: defaultMargin * 2),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: _buildSocialSignInButtons(),
                      ),
                      SizedBox(height: defaultMargin * 2),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: _buildSignInTextButton(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: defaultMargin),
                child: _buildTermsText(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(double imageHeight) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height *
          0.5, // Covers 50% of the screen height
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1475782944331-0ea8c9089a6a?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          ),
          fit: BoxFit.cover, // Fills the entire container without distortion
        ),
      ),
      child: Container(),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Selamat datang di Melotrip',
      style: titleTextStyle.copyWith(
        fontSize: 20, // Adjust the font size to match the design
        fontWeight: bold,
      ),
    );
  }

  Widget _buildTagline() {
    return Text(
      "Aplikasi yang buat hidupmu lebih mudah. Siap bantu kebutuhan transportasi kamu!",
      textAlign: TextAlign.center,
      style: blackTextStyle.copyWith(
        fontSize: 15, // Adjust the font size to match the design
      ),
    );
  }

  Widget _buildSocialSignInButtons() {
    return Column(
      children: [
        SubPrimaryButton(
          title: "Lanjutkan dengan Google",
          onPressed: _handleGoogleSignIn,
          icon: FontAwesomeIcons.google,
        ),
        SizedBox(height: defaultMargin),
        CustomButton(
          title: "Lanjutkan dengan Email",
          onPressed: _handleSignUpWithEmail,
        ),
      ],
    );
  }

  Widget _buildSignInTextButton() {
    return Text.rich(
      TextSpan(
        text: "Sudah memiliki akun? ",
        style: blackTextStyle.copyWith(
          fontSize: 14, // Adjust the font size to match the design
        ),
        children: [
          TextSpan(
            text: "Masuk",
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: bold,
              // color: const Color(0xff087443),
              // decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _navigateTo('/signIn');
              },
          ),
        ],
      ),
    );
  }

  Widget _buildTermsText() {
    return Text.rich(
      TextSpan(
        text: "Dengan membuat akun, Anda menyetujui ",
        style: subTitleTextStyle.copyWith(
          fontSize: 13, // Adjust the font size to match the design
        ),
        children: [
          TextSpan(
            text: "\nSyarat dan Ketentuan",
            style: subTitleTextStyle.copyWith(
              fontSize: 13,
              color: const Color(
                0xff018053,
              ),
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _navigateTo('/term-conditions');
              },
          ),
          TextSpan(
            text: ".",
            style: subTitleTextStyle.copyWith(
              fontSize: 13,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
