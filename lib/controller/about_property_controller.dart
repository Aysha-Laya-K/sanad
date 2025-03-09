import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPropertyController extends GetxController {

  void launchDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+974$phoneNumber');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  Future<void> openWhatsApp(String whatsapp) async {
    final whatsappUrl = Uri.parse('https://wa.me/+974$whatsapp'); // Convert the string to Uri
    await launchUrl(whatsappUrl);  // Launch the URL

  }


}