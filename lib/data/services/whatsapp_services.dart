// data/services/whatsapp_services.dart
import 'dart:io';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class WhatsappServices {
  // manually added
  Future<void> sendWhatsAppMessage({
    required String contact,
    String message = '',
  }) async {
    final androidUrl = "whatsapp://send?phone=$contact&text=$message";
    final iosUrl =
        "https://wa.me/$contact?text=${Uri.encodeComponent(message)}";
    final webUrl =
        'https://api.whatsapp.com/send/?phone=$contact&text=${Uri.encodeComponent(message)}';

    try {
      if (await canLaunchUrl(Uri.parse(androidUrl)) ||
          await canLaunchUrl(Uri.parse(iosUrl))) {
        if (Platform.isIOS) {
          await launchUrl(Uri.parse(iosUrl));
        } else {
          await launchUrl(Uri.parse(androidUrl));
        }
      } else {
        // Fallback to web version if WhatsApp isn't installed
        await launchUrl(Uri.parse(webUrl),
            mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
      // Handle the error, maybe show a dialog to the user
    }
  }
  // send invoice to whatsapp customer and owner cars
  
}
