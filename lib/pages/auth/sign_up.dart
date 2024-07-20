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
  bool _isLoading = false; // Add this line

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _onSignUpButtonPressed() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // Show Flushbar if email or password is not entered
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: const Duration(seconds: 5),
        backgroundColor: Color(0xff171616),
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
      setState(() {
        _isLoading = true; // Set loading to true
      });
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
      Navigator.pushReplacementNamed(context, '/main');
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

        Navigator.pushReplacementNamed(context, '/main');
      } else {
        setState(() {
          _isLoading = false; // Set loading to false if sign-up fails
        });
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar',
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
            if (state.error.contains('422')) {
              Flushbar(
                flushbarPosition: FlushbarPosition.BOTTOM,
                flushbarStyle: FlushbarStyle.FLOATING,
                duration: const Duration(seconds: 5),
                backgroundColor: Color(0xff171616),
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
                Container(
                  child: Text(
                    "Lengkapi informasi di bawah ini atau \ndaftar dengan akun Google.",
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: defaultMargin),
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
                                Image.asset('assets/images/google.png',
                                    width: 25),
                                const SizedBox(width: 8),
                                Text(
                                  "Lanjutkan dengan akun Google",
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
