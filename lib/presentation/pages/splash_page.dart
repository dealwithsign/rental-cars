// presentation/pages/splash_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rents_cars_app/presentation/pages/sign_in_page.dart';
import 'package:rents_cars_app/presentation/pages/sign_up_page.dart';
import 'package:rents_cars_app/presentation/pages/terms_conditions.dart';
import 'package:rents_cars_app/presentation/pages/wrapper_auth_page.dart';
import 'package:rents_cars_app/presentation/widgets/button_sub_primary.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
// Make sure this is imported for AuthState
import '../../utils/fonts.dart';
import 'google_sign_phone_number.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Helper method to navigate and replace the screen
  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Use pushReplacement to replace the current screen with the wrapper
  void _navigateGoogleSignInSignUp(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _handleSignInWithEmail() {
    _navigateTo(const SignInPage());
  }

  void _handleSignUpWithEmail() {
    _navigateTo(const SignUpPage());
  }

  void _handleGoogleSignIn() async {
    context.read<AuthBloc>().add(SignInSignUpWithGoogleRequested());
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
                      SizedBox(height: defaultMargin),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: _buildEmailSignUp(),
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
          image: AssetImage('assets/images/x.jpg'), // Use AssetImage
          fit: BoxFit.cover, // Fills the entire container without distortion
        ),
      ),
      child: Container(),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Selamat datang di Lalan',
      style: titleTextStyle.copyWith(
        fontSize: 20, // Adjust the font size to match the design
        fontWeight: bold,
      ),
    );
  }

  Widget _buildTagline() {
    return Text(
      "Pesan Tiket Online, Mudah & Nyaman!",
      textAlign: TextAlign.center,
      style: blackTextStyle.copyWith(
        fontSize: 15, // Adjust the font size to match the design
      ),
    );
  }

  Widget _buildEmailSignUp() {
    return Column(
      children: [
        CustomButton(
          title: "Lanjutkan dengan Email",
          onPressed: _handleSignUpWithEmail,
        ),
      ],
    );
  }

  Widget _buildSocialSignInButtons() {
    // BlocListener to listen for AuthState changes
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Check if the user has a specific phone number or no phone number
          final phoneNumber = state.user!.phone_number.toString();
          print('phone number: $phoneNumber');
          if (phoneNumber == "81234567890" || phoneNumber.isEmpty) {
            // Navigate to GoogleSignPhoneNumber if the phone number is "081234567890" or empty
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GoogleSignPhoneNumber(),
              ),
            );
          } else {
            // Navigate to WrapperAuth if the phone number is different
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WrapperAuth(),
              ),
            );
          }
        } else if (state is AuthFailure) {
          // Display SnackBar for failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ), // Ensure AuthFailure contains errorMessage
          );
        }
      },
      child: Column(
        children: [
          SubPrimaryButton(
            title: "Lanjutkan dengan Google",
            onPressed: _handleGoogleSignIn,
            icon: FontAwesomeIcons.google,
          ),
        ],
      ),
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
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _navigateTo(const SignInPage());
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
                _navigateTo(const TermsAndConditions());
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
