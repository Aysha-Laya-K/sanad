import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/model/customerneeds_model.dart';


class CustomerNeedsController extends GetxController {
  // RxList to store customer needs
  RxList<CustomerNeed> customerNeeds = <CustomerNeed>[].obs;
  var loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomerNeeds();
  }
  Future<void> fetchCustomerNeeds() async {
    loading.value = true;
    final response = await http.get(
        Uri.parse('https://project.artisans.qa/realestate/api/requirements'));

    if (response.statusCode == 200) {
      final apiResponse = CustomerneedsModel.fromJson(json.decode(response.body));
      customerNeeds.value = apiResponse.data;
    } else {
      throw Exception('Failed to load data');
    }
    loading.value = false;
  }


}