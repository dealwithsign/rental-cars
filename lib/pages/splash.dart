import 'package:flutter/material.dart';
import 'dart:async';

import 'package:rents_cars_app/pages/auth/sign_in.dart';
import 'package:rents_cars_app/pages/wrapper.dart';
import 'package:rents_cars_app/utils/widgets/button.dart';

import '../utils/fonts/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Timer(
  //     const Duration(seconds: 3),
  //     () => Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (_) => const SignInPage()),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double topMargin = screenSize.height * 0.05;
    final double imageHeight = screenSize.height * 0.5;
    final double fontSizeTitle = screenSize.width * 0.05;
    final double fontSizeSubtitle = screenSize.width * 0.04;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kWhiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                color: kWhiteColor,
                width: double.infinity,
                child: Image.network(
                  'https://images.unsplash.com/photo-1518658840494-8694e43e8bce?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  fit: BoxFit.cover,
                  height: imageHeight,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(top: topMargin),
                color: kWhiteColor,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find Your Best Rental Space.',
                        style: blackTextStyle.copyWith(
                          fontSize: fontSizeTitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Join now and lets find you \na new rental space.",
                        style:
                            blackTextStyle.copyWith(fontSize: fontSizeSubtitle),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(
                    left: defaultMargin,
                    right: defaultMargin,
                    bottom: defaultMargin,
                  ),
                  child: CustomButton(
                    title: "Get Started",
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WrapperAuth(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
