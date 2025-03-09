import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchPrivacyPolicy() async {
  final response = await http.get(Uri.parse('https://project.artisans.qa/realestate/api/privacy-policy'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['privacyPolicy'];
  } else {
    throw Exception('Failed to load privacy policy');
  }
}
