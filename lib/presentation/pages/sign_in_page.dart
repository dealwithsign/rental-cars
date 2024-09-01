// presentation/pages/sign_in_page.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/blocs/auth/auth_bloc.dart';
import 'package:rents_cars_app/blocs/auth/auth_event.dart';
import 'package:rents_cars_app/utils/fonts.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:rents_cars_app/presentation/widgets/input_widget.dart';

import '../widgets/flushbar_widget.dart';

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

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName);
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
              _navigateTo('/wrapper');
            } else if (state is AuthFailure) {
              showErrorFlushbar(
                context,
                "Login Gagal",
                "Email atau password tidak valid",
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
                    _buildForgotPassword(),
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
          "Login",
          style: titleTextStyle.copyWith(
            fontSize: 24,
            fontWeight: bold,
          ),
        ),
        SizedBox(height: defaultMargin / 2),
        Text(
          "Silakan masukan email dan password \nuntuk melanjutkan",
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
            textInputAction: TextInputAction.done,
            validation: (value) => null,
            checkOfErrorOnFocusChange: true,
            obscureText: true,
            validator: (value) {
              return value!.isEmpty ? 'Password tidak boleh kosong' : null;
            },
          ),
          Container(
            margin: EdgeInsets.only(top: defaultMargin * 2),
            child: CustomButton(
              title: "Masuk",
              onPressed: _handleSignIn,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSignIn() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showErrorFlushbar(
        context,
        "Login Gagal",
        "Silakan isi email dan password",
      );
    } else {
      context.read<AuthBloc>().add(
            SignInRequested(
              _emailController.text,
              _passwordController.text,
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
                  _navigateTo('/term-conditions');
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

  Widget _buildForgotPassword() {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/forgotPassword');
        },
        child: Text(
          "Lupa Password",
          style: blackTextStyle.copyWith(
            fontSize: 14,
            fontWeight: bold,
          ),
        ),
      ),
    );
  }
}
