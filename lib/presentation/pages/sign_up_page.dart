// presentation/pages/sign_up_page.dart
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/blocs/auth/auth_bloc.dart';
import 'package:rents_cars_app/blocs/auth/auth_event.dart';

import 'package:rents_cars_app/utils/fonts.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:rents_cars_app/presentation/widgets/input_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as SupabaseAuth;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(text: "Users");
  final _phoneNumberController = TextEditingController(text: "081234567890");
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final bool _isLoading = false;

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
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
                        fontSize: 14,
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
                        fontSize: 14,
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
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _onSignUpButtonPressed() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // Show Flushbar if email or password is not entered
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: const Duration(seconds: 5),
        backgroundColor: kPrimaryColor,
        titleText: Text(
          "Daftar Gagal",
          style: whiteTextStyle.copyWith(
            fontSize: 14,
            fontWeight: bold,
          ),
        ),
        messageText: Text(
          "Email atau password tidak boleh kosong",
          style: whiteTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
        margin: EdgeInsets.only(
          left: defaultMargin,
          right: defaultMargin,
          bottom: defaultMargin,
        ),
        borderRadius: BorderRadius.circular(defaultRadius),
      ).show(context);
    } else {
      _showLoadingDialog(); // Show loading dialog
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _phoneNumberController.text,
        ),
      );
    }
  }

  Future<void> _handleGoogleSignUp() async {
    _showLoadingDialog(); // Show loading dialog
    final supabase = SupabaseAuth.Supabase.instance.client;
    const webClientId =
        "519541244574-823pseok23v1d3nvigtr16js3a3v5a9o.apps.googleusercontent.com";
    final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      _hideLoadingDialog(); // Hide loading dialog if sign-in fails
      throw Exception('Login dengan Google gagal');
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      _hideLoadingDialog(); // Hide loading dialog if tokens are null
      throw Exception('Tidak ditemukan access token atau ID token');
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
        _hideLoadingDialog(); // Hide loading dialog if sign-in fails
        throw Exception('Login Supabase gagal');
      }

      final String googleUserUID = user.id;
      print('Google User UID from auth: $googleUserUID');

      final response = await supabase
          .from('users')
          .select()
          .eq('id', googleUserUID)
          .single();

      if (response.isEmpty) {
        await supabase.from('users').insert({
          'id': googleUserUID,
          'email': googleUser.email,
          'username': googleUser.displayName,
          'url_profile': googleUser.photoUrl,
          'created_at': DateTime.now().toIso8601String(),
          'last_sign_in': DateTime.now().toIso8601String(),
          'provider': 'Sign Up by Google',
        });
      } else {
        await supabase
            .from('users')
            .update({'last_sign_in': DateTime.now().toIso8601String()}).eq(
          'id',
          googleUserUID,
        );
      }
      _hideLoadingDialog(); // Hide loading dialog on success
      Navigator.pushReplacementNamed(context, '/wrapper');
    } on SupabaseAuth.PostgrestException catch (e) {
      final SupabaseAuth.AuthResponse res =
          await supabase.auth.signInWithIdToken(
        provider: SupabaseAuth.OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      final user = res.user;
      if (e.code == 'PGRST116') {
        final String googleUserUID = user!.id;
        print('Google User UID from auth: $googleUserUID');
        await supabase.from('users').insert(
          {
            'id': googleUserUID,
            'email': googleUser.email,
            'username': googleUser.displayName,
            'url_profile': googleUser.photoUrl,
            'created_at': DateTime.now().toIso8601String(),
            'last_sign_in': DateTime.now().toIso8601String(),
            'provider': 'google',
          },
        );

        _hideLoadingDialog(); // Hide loading dialog on success
        Navigator.pushReplacementNamed(context, '/wrapper');
      } else {
        _hideLoadingDialog(); // Hide loading dialog on failure
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            _hideLoadingDialog(); // Hide loading dialog on success
            Navigator.pushReplacementNamed(context, '/wrapper');
          } else if (state is AuthFailure) {
            _hideLoadingDialog(); // Hide loading dialog on failure
            if (state.error.contains('422')) {
              Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.FLOATING,
                duration: const Duration(seconds: 5),
                backgroundColor: const Color(0xff171616),
                titleText: Text(
                  "Daftar Gagal",
                  style: whiteTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: bold,
                  ),
                ),
                messageText: Text(
                  "Email sudah terdaftar atau lanjutkan dengan akun Google.",
                  style: whiteTextStyle.copyWith(
                    fontSize: 14,
                  ),
                ),
                margin: EdgeInsets.only(
                  left: defaultMargin,
                  right: defaultMargin,
                  bottom: defaultMargin,
                ),
                borderRadius: BorderRadius.circular(defaultRadius),
              ).show(context);
            }
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: defaultMargin * 4,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daftar",
                        style: blackTextStyle.copyWith(
                          fontSize: 24, // Body Large
                          fontWeight: bold,
                        ),
                      ),
                      SizedBox(
                        height: defaultMargin / 2,
                      ),
                      Text(
                        "Daftar dengan email dan password \natau menggunakan akun Google",
                        style: subTitleTextStyle.copyWith(
                          fontSize: 15, // Body Large
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: defaultMargin * 2,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      OutlineBorderTextFormField(
                        labelText: 'Email',
                        autofocus: false,
                        tempTextEditingController: _emailController,
                        myFocusNode: _emailFocusNode,
                        inputFormatters: const [],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validation: (value) {
                          return null;
                        },
                        checkOfErrorOnFocusChange: true,
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: defaultMargin),
                      OutlineBorderTextFormField(
                        labelText: 'Password',
                        autofocus: false,
                        tempTextEditingController: _passwordController,
                        myFocusNode: _passwordFocusNode,
                        inputFormatters: const [],
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validation: (value) {
                          return null;
                        },
                        checkOfErrorOnFocusChange: true,
                        obscureText: true,
                        validator: (value) {
                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: defaultMargin * 2,
                        ),
                        child: _isLoading
                            ? SpinKitThreeBounce(
                                color: kPrimaryColor,
                                size: 25.0,
                              )
                            : CustomButton(
                                title: "Daftar",
                                onPressed: _onSignUpButtonPressed,
                              ),
                      ),
                      SizedBox(
                        height: defaultMargin,
                      ),
                      Center(
                        child: Text(
                          "atau",
                          style: subTitleTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: defaultMargin,
                      ),
                      Center(
                        child: Container(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null // Disable button when loading
                                : _handleGoogleSignUp,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: kButtonColor,
                              backgroundColor: Colors.white, // Text color
                              side: BorderSide(
                                  color: kButtonColor), // Border color
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(defaultRadius),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google.png',
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Google",
                                  style: blackTextStyle.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
