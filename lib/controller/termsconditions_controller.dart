import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchTermsConditions() async {
  final response = await http.get(Uri.parse('https://project.artisans.qa/realestate/api/terms-and-conditions'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['terms_conditions'];
  } else {
    throw Exception('Failed to load');
  }
}
