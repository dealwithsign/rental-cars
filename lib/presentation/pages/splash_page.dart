import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rents_cars_app/presentation/widgets/button_sub_primary.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SupabaseClient supabase;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;
  }

  void _navigateTo(String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  void _handleSignInWithEmail() {
    _navigateTo('/signIn');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double imageHeight = screenSize.height * 0.10;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kWhiteColor,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      _buildIcon(imageHeight),
                      SizedBox(height: defaultMargin * 2),
                      _buildTitle(),
                      SizedBox(height: defaultMargin * 2),
                      _buildTagline(),
                      SizedBox(height: defaultMargin * 2),
                      _buildSocialSignInButtons(),
                      SizedBox(height: defaultMargin),
                      _buildSignInTextButton(),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: defaultMargin),
                    child: _buildTermsText(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(double imageHeight) {
    return Icon(
      FontAwesomeIcons.a, // Your custom icon
      size: imageHeight,
      color: const Color(0xff087443),
      semanticLabel: 'App Icon',
    );
  }

  Widget _buildTitle() {
    return Text(
      'Rents Cars',
      style: blackTextStyle.copyWith(
        fontSize: 24, // Adjust the font size to match the design
        fontWeight: bold,
      ),
    );
  }

  Widget _buildTagline() {
    return Text(
      "Sewa Mobil Kini Lebih Mudah dan Praktis, Temukan Mobil Impianmu untuk Perjalanan yang Nyaman dan Aman",
      textAlign: TextAlign.center,
      style: subTitleTextStyle.copyWith(
        fontSize: 14, // Adjust the font size to match the design
      ),
    );
  }

  Widget _buildSocialSignInButtons() {
    return Column(
      children: [
        SubPrimaryButton(
          title: "Lanjutkan dengan Google",
          icon: FontAwesomeIcons.google,
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            // Google sign-in functionality
            // After sign-in, set _isLoading to false
          },
        ),
        SizedBox(height: defaultMargin),
        CustomButton(
          title: "Lanjutkan dengan Email",
          onPressed: _handleSignInWithEmail,
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
              color: const Color(0xff087443),
              decoration: TextDecoration.underline,
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
              color: const Color(0xff087443), // Link color
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _navigateTo('/terms');
              },
          ),
          TextSpan(
            text: " serta ",
            style: subTitleTextStyle.copyWith(
              fontSize: 13,
            ),
          ),
          TextSpan(
            text: "Kebijakan Privasi",
            style: subTitleTextStyle.copyWith(
              fontSize: 13,
              color: const Color(0xff087443), // Link color
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _navigateTo('/privacy');
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
