// presentation/pages/forgot_password.dart
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/blocs/auth/auth_bloc.dart';
import 'package:rents_cars_app/blocs/auth/auth_event.dart';

import 'package:rents_cars_app/utils/fonts.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:rents_cars_app/presentation/widgets/input_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _navigateTo(String routeName, {required String email}) {
    Navigator.pushNamed(context, routeName, arguments: email);
  }

  void _onSignInButtonPressed() async {
    if (_emailController.text.isEmpty) {
      // Show Flushbar if email is not entered
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: const Duration(seconds: 5),
        backgroundColor: kPrimaryColor,
        titleText: Text(
          "Reset Password Gagal",
          style: buttonColor.copyWith(
            fontSize: 14, // Body Medium
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          "Email tidak boleh kosong",
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
      try {
        BlocProvider.of<AuthBloc>(context).add(
          ResetPasswordRequested(_emailController.text),
        );
        _navigateTo('/verifyOTP', email: _emailController.text);
      } catch (e) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          duration: const Duration(seconds: 5),
          backgroundColor: kPrimaryColor,
          titleText: Text(
            "Reset Password Gagal",
            style: buttonColor.copyWith(
              fontSize: 14, // Body Medium
              fontWeight: FontWeight.bold,
            ),
          ),
          messageText: Text(
            "Gagal mengirim email reset password: $e",
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                        "Lupa Password",
                        style: titleTextStyle.copyWith(
                          fontSize: 24, // Body Large
                          fontWeight: bold,
                        ),
                      ),
                      SizedBox(
                        height: defaultMargin / 2,
                      ),
                      Text(
                        "Masukkan email yang terdaftar \nuntuk mendapatkan link reset password.",
                        style: blackTextStyle.copyWith(
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
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          } else if (!value.contains('@')) {
                            return 'Email harus mengandung @';
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: defaultMargin * 2,
                        ),
                        child: CustomButton(
                          title: "Kirim Kode",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _onSignInButtonPressed();
                            }
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
    );
  }
}
