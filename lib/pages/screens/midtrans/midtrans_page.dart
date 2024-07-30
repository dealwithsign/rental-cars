import 'package:flutter/material.dart';
import 'package:rents_cars_app/pages/screens/midtrans/midtrans_success.dart';
import 'package:rents_cars_app/services/bookings/booking_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/fonts/constant.dart';

class MidtransPayment extends StatefulWidget {
  final String redirectUrl;
  final String token; // Token adalah ID di database

  const MidtransPayment(
      {Key? key, required this.redirectUrl, required this.token})
      : super(key: key);

  @override
  State<MidtransPayment> createState() => _MidtransPaymentState();
}

class _MidtransPaymentState extends State<MidtransPayment> {
  late WebViewController controller;
  double _loadingProgress = 0;

  // Fungsi untuk mengekstrak Order ID dari URL
  String extractOrderIdFromUrl(String url) {
    var uri = Uri.parse(url);
    // Mengambil parameter 'order_id' atau 'orderId' dari URL
    return uri.queryParameters['order_id'] ??
        uri.queryParameters['orderId'] ??
        '';
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress =
                  progress / 100.0; // Mengupdate progress loading
            });
          },
          onPageStarted: (String url) {
            Uri uri = Uri.parse(url); // Mengurai URL yang sedang dimuat
            String? orderId = uri.queryParameters['order_id'] ??
                uri.queryParameters['orderId'];

            // extract another data from uri
            print('Order ID: $orderId'); // Menampilkan Order ID di konsol
            print('URL: $url'); // Menampilkan URL di konsol

            BookingServices bookingServices = BookingServices();
            if (orderId != null) {
              try {
                // success
                if (url.contains(
                    'status_code=200&transaction_status=settlement')) {
                  print(
                      'Transaction Success'); // Menampilkan pesan sukses transaksi
                  // Menyimpan transaksi ke database dengan ID
                  bookingServices.updateOrderStatus(
                    widget.token,
                    true,
                  ); // Menggunakan token yang diteruskan
                  print('Order ID: $orderId');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MidtransSuccess(
                        orderId: extractOrderIdFromUrl(
                            url), // Mengirim Order ID ke halaman sukses
                      ),
                    ),
                    (Route<dynamic> route) =>
                        false, // Menghapus semua route sebelumnya
                  );
                }
                // pending
                else if (url.contains(
                        'status_code=201&transaction_status=pending') ||
                    url.contains(
                        'status_code=202&transaction_status=pending')) {
                  print('Payment is pending');
                  bookingServices.updateOrderStatus(
                    widget.token,
                    false,
                  );
                  print('Order ID: $orderId');
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MidtransSuccess(
                  //       orderId: extractOrderIdFromUrl(url),
                  //     ),
                  //   ),
                  //   (Route<dynamic> route) => false,
                  // );
                }
                // deny
                else if (url
                    .contains('status_code=400&transaction_status=deny')) {
                  // Handle error payment
                  print('Payment was denied');
                }
              } catch (e) {
                print(
                    'Error updating order status: $e'); // Menampilkan pesan kesalahan jika pembaruan gagal
              }
            }
          },
          onPageFinished: (String url) {
            print(
                'Page finished loading: $url'); // Menampilkan URL setelah selesai memuat
          },
          onHttpError: (HttpResponseError error) {
            print('HTTP error: $error'); // Menampilkan pesan kesalahan HTTP
          },
        ),
      )
      ..loadRequest(
          Uri.parse(widget.redirectUrl)); // Memuat URL untuk pembayaran
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kWhiteColor,
          ),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: Text(
          'Konfirmasi Pembayaran',
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xff3253a2),
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (_loadingProgress < 1.0)
            LinearProgressIndicator(
              value: _loadingProgress, // Menampilkan indikator progress
              backgroundColor: kWhiteColor,
            ),
        ],
      ),
    );
  }
}
