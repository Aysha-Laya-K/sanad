import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/model/myneeds_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';

class MyNeedsController extends GetxController {
  // RxList to store customer needs
  RxList<MyNeed> myNeeds = <MyNeed>[].obs;
  var loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomerNeeds();
  }

  Future<void> fetchCustomerNeeds() async {
    final token = await UserTypeManager.getToken();
    loading.value = true;

    final response = await http.get(
      Uri.parse(
          'https://project.artisans.qa/realestate/api/user/my-requirements'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final apiResponse = ApiResponse.fromJson(json.decode(response.body));
      myNeeds.value = apiResponse.data;
    } else {
      throw Exception('Failed to load data');
    }

    loading.value = false;
  }
}
