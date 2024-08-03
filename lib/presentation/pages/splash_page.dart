// presentation/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rents_cars_app/presentation/pages/sign_in_page.dart';
import 'package:rents_cars_app/presentation/pages/sign_up_page.dart';
import 'package:rents_cars_app/presentation/pages/wrapper_auth_page.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:rents_cars_app/presentation/widgets/button_cancle_widget.dart';
import '../../utils/fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double imageHeight = screenSize.height * 0.2;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kWhiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                LineIcons.mapSigns,
                size: imageHeight,
                color: kPrimaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                'x',
                style: blackTextStyle.copyWith(
                  fontSize: 24, // H1
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: defaultMargin),
              Text(
                'Aplikasi yang buat hidupmu lebih nyaman. Siap bantu kebutuhanmu, kapan pun, di mana pun.',
                style: blackTextStyle.copyWith(
                  fontSize: 16, // Body Large
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                title: "Masuk",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SignInPage(),
                    ),
                  );
                },
              ),
              SizedBox(height: defaultMargin),
              CustomButtonCancel(
                title: "Belum punya akun? Daftar",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const WrapperAuth(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Dengan masuk atau mendaftar, kamu menyetujui Ketentuan layanan dan Kebijakan privasi.',
                style: subTitleTextStyle.copyWith(
                  fontSize: 12, // Body Small
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
