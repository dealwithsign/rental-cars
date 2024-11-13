// presentation/widgets/confirmationbottomsheet_widget.dart
import 'package:flutter/material.dart';

import '../../utils/fonts.dart';
import 'button_widget.dart';

class PickRentalTypeBottomSheet extends StatelessWidget {
  final VoidCallback onContinueWithDriver;
  final VoidCallback onContinueWithoutDriver;

  const PickRentalTypeBottomSheet({
    super.key,
    required this.onContinueWithDriver,
    required this.onContinueWithoutDriver,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.28,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultRadius),
          topRight: Radius.circular(defaultRadius),
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center children vertically
            children: [
              SizedBox(height: defaultMargin),
              Text(
                'Pilih Tipe Rental',
                textAlign: TextAlign.center, // Center text horizontally
                style: titleTextStyle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: defaultMargin / 2),
              Text(
                'Pilih tipe rental yang sesuai dengan kebutuhan anda',
                textAlign: TextAlign.center, // Center text horizontally
                style: subTitleTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: defaultMargin / 2),
              Expanded(
                // Make the buttons fill the available space
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      title: "Dengan Sopir",
                      onPressed: onContinueWithDriver,
                    ),
                    SizedBox(height: defaultMargin),
                    CustomButton(
                      title: "Lepas Kunci",
                      onPressed: onContinueWithoutDriver,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showPickRentalTypeBottomSheet(BuildContext context,
    VoidCallback onContinueWithDriver, VoidCallback onContinueWithoutDriver) {
  showModalBottomSheet(
    backgroundColor: kWhiteColor,
    context: context,
    builder: (BuildContext context) {
      return PickRentalTypeBottomSheet(
        onContinueWithDriver: onContinueWithDriver,
        onContinueWithoutDriver: onContinueWithoutDriver,
      );
    },
  );
}
