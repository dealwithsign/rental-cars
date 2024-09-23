// presentation/pages/update_password.dart
import 'package:another_flushbar/flushbar.dart';import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/blocs/auth/auth_bloc.dart';
import 'package:rents_cars_app/blocs/auth/auth_event.dart';
import 'package:rents_cars_app/data/services/authentication_services.dart';
import 'package:rents_cars_app/presentation/pages/wrapper_auth_page.dart';

import 'package:rents_cars_app/utils/fonts.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:rents_cars_app/presentation/widgets/input_widget.dart';

import '../widgets/flushbar_widget.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _onUpdatePasswordButtonPressed() async {
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      // Show Flushbar if password fields are not filled
      showErrorFlushbar(
        context,
        "Update Password Gagal",
        "Password tidak boleh kosong",
      );
    } else if (_newPasswordController.text != _confirmPasswordController.text) {
      // Show Flushbar if passwords do not match
      showErrorFlushbar(
        context,
        "Update Password Gagal",
        "Password tidak cocok",
      );
    } else {
      try {
        // password update event
        AuthServices authServices = AuthServices();
        await authServices.updatePassword(
          newPassword: _newPasswordController.text,
        );
        showErrorFlushbar(
          context,
          "Update Password Berhasil",
          "Password berhasil diperbarui",
        );
        _navigateTo(const WrapperAuth());
      } catch (e) {
        // Show Flushbar if password update fails
        showErrorFlushbar(
          context,
          "Update Password Gagal",
          "Password gagal diperbarui",
        );
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
                        "Buat Password Baru",
                        style: titleTextStyle.copyWith(
                          fontSize: 24, // Body Large
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: defaultMargin / 2,
                      ),
                      Text(
                        "Silakan masukkan kata sandi baru yang berbeda \ndari sebelumnya.",
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
                        labelText: 'Password Baru',
                        obscureText: true,
                        autofocus: false,
                        tempTextEditingController: _newPasswordController,
                        myFocusNode: _newPasswordFocusNode,
                        inputFormatters: const [],
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        validation: (value) {
                          return null;
                        },
                        checkOfErrorOnFocusChange: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: defaultMargin,
                      ),
                      OutlineBorderTextFormField(
                        labelText: 'Konfirmasi Password',
                        obscureText: true,
                        autofocus: false,
                        tempTextEditingController: _confirmPasswordController,
                        myFocusNode: _confirmPasswordFocusNode,
                        inputFormatters: const [],
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        validation: (value) {
                          return null;
                        },
                        checkOfErrorOnFocusChange: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password tidak boleh kosong';
                          } else if (value != _newPasswordController.text) {
                            return 'Password tidak cocok';
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: defaultMargin * 2,
                        ),
                        child: CustomButton(
                          title: "Reset Password",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _onUpdatePasswordButtonPressed();
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
