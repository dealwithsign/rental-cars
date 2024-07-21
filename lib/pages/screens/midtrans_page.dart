import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../utils/fonts/constant.dart';

class MidtransPayment extends StatefulWidget {
  final String token;
  final String redirectUrl;

  const MidtransPayment({
    Key? key,
    required this.token,
    required this.redirectUrl,
  }) : super(key: key);

  @override
  State<MidtransPayment> createState() => _MidtransPaymentState();
}

class _MidtransPaymentState extends State<MidtransPayment> {
  var loadingPercentage = 0;

  String extractOrderIdFromUrl(String url) {
    var uri = Uri.parse(url);
    return uri.queryParameters['booking_id'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.redirectUrl;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff002855),
        bottomOpacity: 0.0,
        elevation: 0.0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(
          color: kWhiteColor,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Metode Pembayaran",
              style: whiteTextStyle.copyWith(
                fontSize: 18,
                fontWeight: bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            InAppWebView(
              initialUrlRequest:
                  URLRequest(url: WebUri(Uri.parse(url).toString())),
              onCloseWindow: (controller) {
                Navigator.pop(context);
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  loadingPercentage = progress;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  loadingPercentage = 100;
                });
              },
              onLoadError: (controller, url, code, message) {
                print("Error loading URL: $url");
                print("Error code: $code");
                print("Error message: $message");
              },
              onLoadStart: (controller, url) {
                String urlString = url.toString();
                print('URL: $urlString');
                // final paymentServices = PaymentServices();

                if (urlString.contains(
                    'status_code=200&transaction_status=settlement')) {
                  print('Payment is success');
                  // paymentServices.updateOrderStatus(
                  //   widget.token,
                  //   true,
                  // );

                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PaymentSuccess(
                  //       orderId: extractOrderIdFromUrl(urlString),
                  //     ),
                  //   ),
                  //   (route) => false,
                  // );
                } else if (urlString.contains(
                        'status_code=201&transaction_status=pending') ||
                    urlString.contains(
                        'status_code=202&transaction_status=pending')) {
                  print('Payment is pending');

                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PaymentUnfinished(
                  //       orderId: extractOrderIdFromUrl(urlString),
                  //     ),
                  //   ),
                  //   (route) => false,
                  // );
                } else if (urlString
                    .contains('status_code=400&transaction_status=deny')) {
                  print('Payment was denied');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
