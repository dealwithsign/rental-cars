import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rents_cars_app/bloc/auth/bloc/auth_bloc.dart';
import 'package:rents_cars_app/bloc/auth/bloc/auth_event.dart';
import 'package:rents_cars_app/models/users.dart';
import 'package:rents_cars_app/utils/fonts/constant.dart';
import 'package:rents_cars_app/utils/widgets/button.dart';
import 'package:rents_cars_app/utils/widgets/input.dart';
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
  bool _isLoading = false; // Add this line

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onSignInButtonPressed() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // Show Flushbar if email or password is not entered
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: const Duration(seconds: 5),
        backgroundColor: Color(0xff171616),
        titleText: Text(
          "Login Gagal",
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
      setState(() {
        _isLoading = true; // Set loading to true
      });
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
    final supabase = SupabaseAuth.Supabase.instance.client;
    const webClientId =
        "519541244574-823pseok23v1d3nvigtr16js3a3v5a9o.apps.googleusercontent.com";
    final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      setState(() {
        _isLoading = false; // Set loading to false if sign-in fails
      });
      throw Exception('Login dengan Google gagal');
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
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
        setState(() {
          _isLoading = false; // Set loading to false if sign-in fails
        });
        throw Exception('Login Supabase gagal');
      }

      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false if sign-in fails
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Masuk',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            setState(() {
              _isLoading = false; // Set loading to false on success
            });
            Navigator.pushReplacementNamed(context, '/main');
          } else if (state is AuthFailure) {
            setState(() {
              _isLoading = false; // Set loading to false on failure
            });
            print(state.error);
            Flushbar(
              flushbarPosition: FlushbarPosition.BOTTOM,
              flushbarStyle: FlushbarStyle.FLOATING,
              duration: const Duration(seconds: 5),
              backgroundColor: Color(0xff171616),
              titleText: Text(
                "Login Gagal",
                style: whiteTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: bold,
                ),
              ),
              messageText: Text(
                "Email dan password salah atau lanjutkan dengan akun Google.",
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
                      fontSize: 16,
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
                        child: _isLoading
                            ? SpinKitThreeBounce(
                                color: kPrimaryColor,
                                size: 25.0,
                              )
                            : CustomButton(
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
                                ? null
                                : _handleGoogleSignIn, // Disable button when loading
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
                                Image.asset('assets/images/google.png',
                                    width: 25),
                                const SizedBox(width: 8),
                                Text(
                                  "Masuk dengan akun Google",
                                  style: blackTextStyle.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: defaultMargin,
                      ),
                      Center(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Belum punya akun?",
                                style: subTitleTextStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signUp');
                                },
                                child: Text(
                                  "Daftar",
                                  style: blackTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
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
