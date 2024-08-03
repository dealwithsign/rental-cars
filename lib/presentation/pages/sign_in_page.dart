// presentation/pages/sign_in_page.dart
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

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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

  void _onSignInButtonPressed() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // Show Flushbar if email or password is not entered
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: const Duration(seconds: 5),
        backgroundColor: kPrimaryColor,
        titleText: Text(
          "Login Gagal",
          style: whiteTextStyle.copyWith(
            fontSize: 14, // Body Medium
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          "Email atau password tidak boleh kosong",
          style: whiteTextStyle.copyWith(
            fontSize: 14, // Body Medium
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
      setState(() {
        _isLoading = true; // Set loading to true
      });
      _showLoadingDialog(); // Show loading dialog
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(
          _emailController.text,
          _passwordController.text,
        ),
      );
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
      throw Exception('Login dengan Google gagal');
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      _hideLoadingDialog();
      setState(() {
        _isLoading = false; // Set loading to false if tokens are null
      });
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
        _hideLoadingDialog();
        setState(() {
          _isLoading = false; // Set loading to false if sign-in fails
        });
        throw Exception('Login Supabase gagal');
      }

      _hideLoadingDialog();
      Navigator.pushReplacementNamed(context, '/wrapper');
    } catch (e) {
      _hideLoadingDialog();
      setState(() {
        _isLoading = false; // Set loading to false if sign-in fails
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              LineIcons.angleLeft,
              color: kPrimaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Masuk',
            style: blackTextStyle.copyWith(
              fontSize: 24, // H5
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              _hideLoadingDialog();
              setState(() {
                _isLoading = false; // Set loading to false on success
              });
              Navigator.pushReplacementNamed(context, '/wrapper');
            } else if (state is AuthFailure) {
              _hideLoadingDialog();
              setState(() {
                _isLoading = false; // Set loading to false on failure
              });
              print(state.error);
              Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.FLOATING,
                duration: const Duration(seconds: 5),
                backgroundColor: const Color(0xff171616),
                titleText: Text(
                  "Login Gagal",
                  style: whiteTextStyle.copyWith(
                    fontSize: 14, // Body Medium
                    fontWeight: FontWeight.bold,
                  ),
                ),
                messageText: Text(
                  "Email dan password salah atau lanjutkan dengan akun Google.",
                  style: whiteTextStyle.copyWith(
                    fontSize: 14, // Body Medium
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
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Masuk dengan email dan password atau \nmasuk dengan akun Google.",
                      style: blackTextStyle.copyWith(
                        fontSize: 16, // Body Large
                      ),
                    ),
                  ),
                  SizedBox(
                    height: defaultMargin,
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
                        SizedBox(
                          height: defaultMargin,
                        ),
                        OutlineBorderTextFormField(
                          labelText: 'Password',
                          autofocus: false,
                          tempTextEditingController: _passwordController,
                          myFocusNode: _passwordFocusNode,
                          inputFormatters: const [],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
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
                          child: CustomButton(
                            title: "Masuk",
                            onPressed: _onSignInButtonPressed,
                          ),
                        ),
                        SizedBox(
                          height: defaultMargin,
                        ),
                        Center(
                          child: Text(
                            "atau",
                            style: subTitleTextStyle.copyWith(
                              fontSize: 14, // Body Medium
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
                                  ? null
                                  : _handleGoogleSignIn, // Disable button when loading
                              style: ElevatedButton.styleFrom(
                                foregroundColor: kPrimaryColor,
                                backgroundColor: Colors.white, // Text color
                                side: BorderSide(
                                  color: kPrimaryColor,
                                ), // Border color
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(defaultRadius),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/google.png',
                                      width: 25),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Google",
                                    style: blackTextStyle.copyWith(
                                        fontSize: 14), // Body Medium
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
      ),
    );
  }
}
