// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../utils/fonts/constant.dart';

class ListCarsScheduled404 extends StatefulWidget {
  const ListCarsScheduled404({super.key});

  @override
  State<ListCarsScheduled404> createState() => _ListCarsScheduled404State();
}

class _ListCarsScheduled404State extends State<ListCarsScheduled404> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          surfaceTintColor: kWhiteColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Rute tidak ditemukan',
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.error,
                size: 100,
                color: Colors.red,
              ),
              Text(
                '404',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Data Not Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
