import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rents_cars_app/presentation/pages/sign_up_page.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';

import '../../utils/fonts.dart';
import '../widgets/button_sub_primary.dart';
import 'sign_in_page.dart';
import 'terms_conditions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

// login
  void _navigateToLogin() {
    _navigateTo(const SignInPage());
  }

// register
  void _navigateToRegister() {
    _navigateTo(const SignUpPage());
  }

  // term and condition
  void _navigateToTermsAndConditions() {
    _navigateTo(const TermsAndConditions());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            _buildBackgroundImage(),
            _buildGradientOverlay(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/splash_new.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              kWhiteColor,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildWelcomeText(),
        SizedBox(height: defaultMargin / 2),
        _buildTermsAndPrivacyText(),
        SizedBox(height: defaultMargin * 2),
        _loginAccountButton(),
        SizedBox(height: defaultMargin),
        _buildCreateAccountButton(),
        SizedBox(height: defaultMargin * 2),
        _buildTermsText(),
        SizedBox(height: defaultMargin),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return _buildPaddedText(
      'Selamat Datang di Lalan',
      style: whiteTextStyle.copyWith(
        fontSize: 20,
        fontWeight: bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTermsAndPrivacyText() {
    return _buildPaddedText(
      "Pesan Tiket Online, Mudah & Nyaman!",
      style: blackTextStyle.copyWith(
        fontSize: 15,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCreateAccountButton() {
    return _buildPaddedButton(
      SubPrimaryButton(
        title: "Buat Akun",
        onPressed: _navigateToRegister,
      ),
    );
  }

  Widget _loginAccountButton() {
    return _buildPaddedButton(
      CustomButton(
        title: "Masuk",
        onPressed: _navigateToLogin,
      ),
    );
  }

  Widget _buildTermsText() {
    return Text.rich(
      TextSpan(
        text: "Dengan membuat akun, Anda menyetujui ",
        style: subTitleTextStyle.copyWith(fontSize: 13),
        children: [
          TextSpan(
            text: "\nSyarat dan Ketentuan",
            style: subTitleTextStyle.copyWith(
              fontSize: 13,
              color: const Color(0xff018053),
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _navigateToTermsAndConditions();
              },
          ),
          TextSpan(
            text: ".",
            style: subTitleTextStyle.copyWith(fontSize: 13),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPaddedText(String text,
      {TextStyle? style, TextAlign? textAlign}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }

  Widget _buildPaddedButton(Widget button) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
      child: button,
    );
  }
}
