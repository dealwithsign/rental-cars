// presentation/pages/splash_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rents_cars_app/presentation/widgets/button_sub_primary.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as SupabaseAuth;

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
    Navigator.pushNamed(context, routeName);
  }

  void _handleSignInWithEmail() {
    _navigateTo('/signIn');
  }

  void _handleSignUpWithEmail() {
    _navigateTo('/signUp');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true; // Set loading to true
    });

    final supabase = SupabaseAuth.Supabase.instance.client;
    const webClientId =
        "519541244574-823pseok23v1d3nvigtr16js3a3v5a9o.apps.googleusercontent.com";
    final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      setState(() {
        _isLoading = false; // Set loading to false if sign-in fails
      });
      _showError('Login dengan Google gagal');
      return;
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      setState(() {
        _isLoading = false; // Set loading to false if tokens are null
      });
      _showError('Tidak ditemukan access token atau ID token');
      return;
    }

    try {
      final SupabaseAuth.AuthResponse res =
          await supabase.auth.signInWithIdToken(
        provider: SupabaseAuth.OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      final user = res.user;
      if (user == null) {
        setState(() {
          _isLoading = false; // Set loading to false if sign-in fails
        });
        _showError('Login Supabase gagal');
        return;
      }

      Navigator.pushReplacementNamed(context, '/wrapper');
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false if sign-in fails
      });
      _showError('Login gagal: ${e.toString()}');
    }
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
                child: Column(
                  children: [
                    _buildImage(MediaQuery.of(context).size.height * 0.5),
                    SizedBox(height: defaultMargin * 2),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                      child: _buildTitle(),
                    ),
                    SizedBox(height: defaultMargin),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                      child: _buildTagline(),
                    ),
                    SizedBox(height: defaultMargin * 2),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                      child: _buildSocialSignInButtons(),
                    ),
                    SizedBox(height: defaultMargin * 2),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                      child: _buildSignInTextButton(),
                    ),
                  ],
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
            'https://images.unsplash.com/photo-1676134690893-c6264a00e883?q=80&w=2115&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          ),
          fit: BoxFit.cover, // Fills the entire container without distortion
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent, // Start with transparent
              Colors.white.withOpacity(
                0.0,
              ), // Gradually change to white with some opacity
              kWhiteColor // Fully white at the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Selamat datang di Gojek !',
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
        // SubPrimaryButton(
        //   title: "Lanjutkan dengan Google",
        //   icon: FontAwesomeIcons.google,
        //   onPressed: _handleGoogleSignIn,
        // ),
        // SizedBox(height: defaultMargin),
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
              color: const Color(0xff087443), // Link color
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
