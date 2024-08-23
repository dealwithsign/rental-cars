// presentation/pages/verify_otp.dart
import 'dart:math';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/utils/fonts.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:rents_cars_app/presentation/widgets/input_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart'; // Import for input formatters

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key});

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  late String _email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  void dispose() {
    _otpFocusNode.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  Future<void> _verifyOTP(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.verifyOTP(
        token: _otpController.text,
        type: OtpType.recovery,
        email: _email,
      );
      _navigateTo('/resetPassword');
    } catch (e) {
      if (e.toString().contains('Token has expired or is invalid') ||
          e.toString().contains('statusCode:403') ||
          e.toString().contains('is invalid')) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          duration: const Duration(seconds: 5),
          backgroundColor: kPrimaryColor,
          titleText: Text(
            "Verifikasi OTP Gagal",
            style: buttonColor.copyWith(
              fontSize: 14, // Body Medium
              fontWeight: FontWeight.bold,
            ),
          ),
          messageText: Text(
            "OTP tidak valid. Silakan coba lagi.",
            style: buttonColor.copyWith(
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
        SpinKitThreeBounce(
          color: kPrimaryColor,
          size: 25,
        );
      }
    }
  }

  void _onVerifyOTPButtonPressed(BuildContext context) {
    if (_otpController.text.isEmpty) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: const Duration(seconds: 5),
        backgroundColor: kPrimaryColor,
        titleText: Text(
          "Verifikasi OTP Gagal",
          style: buttonColor.copyWith(
            fontSize: 14, // Body Medium
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          "OTP tidak boleh kosong",
          style: buttonColor.copyWith(
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
    } else if (_formKey.currentState!.validate()) {
      _verifyOTP(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => Scaffold(
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
          body: SingleChildScrollView(
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
                          "Verifikasi OTP",
                          style: titleTextStyle.copyWith(
                            fontSize: 24, // Body Large
                            fontWeight: bold,
                          ),
                        ),
                        SizedBox(
                          height: defaultMargin / 2,
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                                'Masukkan OTP yang telah dikirim ke ', // Default text
                            style: blackTextStyle.copyWith(
                              fontSize: 15, // Body Large
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: _email, // Email part
                                style: blackTextStyle.copyWith(
                                  fontWeight:
                                      FontWeight.bold, // Make email bold
                                ),
                              ),
                            ],
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
                          labelText: 'OTP',
                          autofocus: false,
                          tempTextEditingController: _otpController,
                          myFocusNode: _otpFocusNode,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                6), // Limit input to 6 characters
                            FilteringTextInputFormatter
                                .digitsOnly, // Allow only digits
                          ],
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          validation: (value) {
                            return null;
                          },
                          checkOfErrorOnFocusChange: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'OTP tidak boleh kosong';
                            } else if (value.length != 6) {
                              return 'OTP harus 6 digit';
                            }
                            return null;
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: defaultMargin * 2,
                          ),
                          child: CustomButton(
                            title: "Verifikasi OTP",
                            onPressed: () {
                              _onVerifyOTPButtonPressed(context);
                            },
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
