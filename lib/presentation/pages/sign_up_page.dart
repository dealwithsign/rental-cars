// presentation/pages/sign_up_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/blocs/auth/auth_bloc.dart';
import 'package:rents_cars_app/blocs/auth/auth_event.dart';
import 'package:rents_cars_app/presentation/pages/terms_conditions.dart';
import 'package:rents_cars_app/presentation/pages/wrapper_auth_page.dart';
import 'package:rents_cars_app/utils/fonts.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:rents_cars_app/presentation/widgets/input_widget.dart';

import '../widgets/flushbar_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
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
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              _navigateTo(const WrapperAuth());
            } else if (state is AuthFailure) {
              showErrorFlushbar(
                context,
                "Pendaftaran Gagal",
                "Maaf, email atau nomor telepon ini sudah terdaftar",
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: defaultMargin * 2),
                    _buildForm(),
                    SizedBox(height: defaultMargin * 2),
                    _buildTermsText(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Buat Akun",
          style: titleTextStyle.copyWith(
            fontSize: 24,
            fontWeight: bold,
          ),
        ),
        SizedBox(height: defaultMargin / 2),
        Text(
          "Buat akun sekarang dan pesan tiket \nperjalanan dengan mudah!",
          style: blackTextStyle.copyWith(
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          OutlineBorderTextFormField(
            labelText: 'Nama',
            autofocus: false,
            tempTextEditingController: _nameController,
            myFocusNode: _nameFocusNode,
            inputFormatters: const [],
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validation: (value) => null,
            checkOfErrorOnFocusChange: true,
            validator: (value) {
              return value!.isEmpty ? 'Name tidak boleh kosong' : null;
            },
          ),
          SizedBox(height: defaultMargin),
          OutlineBorderTextFormField(
            labelText: 'Email',
            autofocus: false,
            tempTextEditingController: _emailController,
            myFocusNode: _emailFocusNode,
            inputFormatters: const [],
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validation: (value) => null,
            checkOfErrorOnFocusChange: true,
            validator: (value) {
              return value!.isEmpty ? 'Email tidak boleh kosong' : null;
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
            validation: (value) => null,
            checkOfErrorOnFocusChange: true,
            obscureText: true,
            validator: (value) {
              return value!.isEmpty ? 'Password tidak boleh kosong' : null;
            },
          ),
          SizedBox(height: defaultMargin),
          OutlineBorderTextFormField(
            labelText: 'Nomor WhatsApp',
            autofocus: false,
            tempTextEditingController: _phoneNumberController,
            myFocusNode: _phoneNumberFocusNode,
            inputFormatters: const [],
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            validation: (value) => null,
            checkOfErrorOnFocusChange: true,
            validator: (value) {
              return value!.isEmpty ? 'Phone Number tidak boleh kosong' : null;
            },
          ),
          Container(
            margin: EdgeInsets.only(top: defaultMargin * 2),
            child: CustomButton(
              title: "Buat Akun",
              onPressed: _handleSignUp,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSignUp() {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) {
      showErrorFlushbar(
        context,
        "Pendaftaran Gagal",
        "Silakan lengkapi informasi yang diperlukan sebelum melanjutkan",
      );
    } else {
      context.read<AuthBloc>().add(
            SignUpRequested(
              _emailController.text,
              _passwordController.text,
              _nameController.text,
              _phoneNumberController.text,
            ),
          );
    }
  }

  Widget _buildTermsText() {
    return Center(
      child: Text.rich(
        TextSpan(
          text: "Dengan membuat akun, Anda menyetujui ",
          style: subTitleTextStyle.copyWith(
            fontSize: 13,
          ),
          children: [
            TextSpan(
              text: "\nSyarat dan Ketentuan",
              style: subTitleTextStyle.copyWith(
                fontSize: 13,
                color: const Color(0xff087443),
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _navigateTo(const TermsAndConditions());
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
      ),
    );
  }
}
