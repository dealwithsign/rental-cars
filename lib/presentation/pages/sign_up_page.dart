// presentation/pages/sign_up_page.dart
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
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

  void _navigateTo(String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: kWhiteColor,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          surfaceTintColor: kWhiteColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              LineIcons.angleLeft,
              color: kPrimaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
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
                  flushbarPosition: FlushbarPosition.TOP,
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: defaultMargin * 2,
                  ),
                  Center(
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
