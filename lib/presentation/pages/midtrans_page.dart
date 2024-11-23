// presentation/pages/midtrans_page.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rents_cars_app/presentation/widgets/button_cancle_widget.dart';
import 'package:rents_cars_app/presentation/widgets/button_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../data/services/booking_services.dart';
import '../../utils/fonts.dart';
import 'midtrans_success_page.dart';
import 'navigation_page.dart';

class MidtransPayment extends StatefulWidget {
  final String redirectUrl;
  final String token;

  const MidtransPayment(
      {super.key, required this.redirectUrl, required this.token});

  @override
  State<MidtransPayment> createState() => _MidtransPaymentState();
}

class _MidtransPaymentState extends State<MidtransPayment> {
  late WebViewController controller;
  double _loadingProgress = 0;

  String extractOrderIdFromUrl(String url) {
    var uri = Uri.parse(url);
    return uri.queryParameters['order_id'] ??
        uri.queryParameters['orderId'] ??
        '';
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(kWhiteColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100.0;
            });
          },
          onPageStarted: (String url) {
            Uri uri = Uri.parse(url);
            String? orderId = uri.queryParameters['order_id'] ??
                uri.queryParameters['orderId'];

            BookingServices bookingServices = BookingServices();
            if (orderId != null) {
              try {
                if (url.contains(
                    'status_code=200&transaction_status=settlement')) {
                  bookingServices.updateOrderStatus(widget.token, true);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MidtransSuccess(
                        orderId: extractOrderIdFromUrl(url),
                      ),
                    ),
                    (Route<dynamic> route) => false,
                  );
                } else if (url.contains(
                        'status_code=201&transaction_status=pending') ||
                    url.contains(
                        'status_code=202&transaction_status=pending')) {
                  bookingServices.updateOrderStatus(widget.token, false);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigationScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                } else if (url
                    .contains('status_code=400&transaction_status=deny')) {
                  print('Payment was denied');
                }
              } catch (e) {
                print('Error updating order status: $e');
              }
            }
          },
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {
            print('HTTP error: $error');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  void _showConfirmationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: kWhiteColor,
      context: context,
      builder: (BuildContext context) {
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultMargin),
                Text(
                  'Batalkan pesanan ini ?',
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: defaultMargin / 2),
                Text(
                  'Pesanan ini akan dibatalkan dan transaksi tiket \ntidak dapat digunakan.',
                  textAlign: TextAlign.center,
                  style: subTitleTextStyle.copyWith(fontSize: 15),
                ),
                SizedBox(height: defaultMargin / 2),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButtonCancel(
                        title: "Batalkan Pesanan",
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NavigationScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                      SizedBox(height: defaultMargin),
                      CustomButton(
                        title: "Pilih Pembayaran",
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: kPrimaryColor),
          onPressed: () => _showConfirmationBottomSheet(context),
        ),
        title: Text(
          'Pilih Pembayaran',
          style: titleTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kWhiteColor, kWhiteColor],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(defaultMargin / 2),
            decoration: BoxDecoration(
              color: kFailedColor,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: kPrimaryColor,
                  size: 20,
                ),
                SizedBox(width: defaultMargin / 2),
                Expanded(
                  child: Text(
                    'Setelah memilih metode pembayaran, Anda tidak dapat mengubah ke metode pembayaran lain.',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (_loadingProgress < 1.0)
                  LinearProgressIndicator(
                    value: _loadingProgress,
                    backgroundColor: kWhiteColor,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
