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

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: defaultMargin * 6),
              padding: EdgeInsets.all(defaultMargin),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(
                    color: kPrimaryColor,
                    size: 25.0,
                  ),
                  SizedBox(height: defaultMargin),
                  Center(
                    child: Text(
                      "Mohon tunggu...",
                      style: blackTextStyle.copyWith(
                        fontSize: 14, // Body Medium
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      "Sedang memuat data...",
                      textAlign: TextAlign.center,
                      style: subTitleTextStyle.copyWith(
                        fontSize: 14, // Body Medium
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true; // Set loading to true
    });
    _showLoadingDialog(); // Show loading dialog
    final supabase = SupabaseAuth.Supabase.instance.client;
    const webClientId =
        "519541244574-823pseok23v1d3nvigtr16js3a3v5a9o.apps.googleusercontent.com";
    final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      _hideLoadingDialog();
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
      _hideLoadingDialog();
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
        _hideLoadingDialog();
        setState(() {
          _isLoading = false; // Set loading to false if sign-in fails
        });
        _showError('Login Supabase gagal');
        return;
      }

      _hideLoadingDialog();
      Navigator.pushReplacementNamed(context, '/wrapper');
    } catch (e) {
      _hideLoadingDialog();
      setState(() {
        _isLoading = false; // Set loading to false if sign-in fails
      });
      _showError('Login gagal: ${e.toString()}');
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
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildIcon(imageHeight),
                        SizedBox(height: defaultMargin * 2),
                        _buildTitle(),
                        SizedBox(height: defaultMargin * 2),
                        _buildTagline(),
                        SizedBox(height: defaultMargin * 2),
                        _buildSocialSignInButtons(),
                        SizedBox(height: defaultMargin * 2),
                        _buildSignInTextButton(),
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
      'Cadeira',
      style: blackTextStyle.copyWith(
        fontSize: 24, // Adjust the font size to match the design
        fontWeight: bold,
      ),
    );
  }

  Widget _buildTagline() {
    return Text(
      "Sewa Mobil Kini Lebih Mudah dan Praktis. Temukan Mobil Impian Anda untuk Perjalanan yang Nyaman dan Aman. \nDaftar Sekarang!",
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
          onPressed: _handleGoogleSignIn,
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
