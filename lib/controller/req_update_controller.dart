import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/model/searchcontentlocation_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';

class RequirementUpdateController extends GetxController {
  // TextEditingControllers for form fields
  TextEditingController titleController = TextEditingController();
  TextEditingController requirementDetailsController = TextEditingController();

  // Rx variables to track focus and input states
  RxList<Location> locations = <Location>[].obs;
  var loading = true.obs;

  // Selected location
  RxString selectedLocation = ''.obs;
  var selectedLocationId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  @override
  void onClose() {
    titleController.dispose();
    requirementDetailsController.dispose();
    super.onClose();
  }

  void setSelectedLocationFromId(int locationId) {
    if (locationId > 0) { // Only process valid IDs
      var location = locations.firstWhere(
            (loc) => loc.id == locationId,
        orElse: () => Location(
          id: 0,
          name: '',
          slug: '',
          image: '',
          showHomepage: 0,
          serial: 0,
          createdAt: '',
          updatedAt: '',
          countryId: 0,
          totalProperty: 0,
        ),
      );
      if (location.id != 0) {
        selectedLocation.value = location.name;
        selectedLocationId.value = locationId;
      } else {
        print('Location with id $locationId not found');
      }
    } else {
      // Ensure no location is pre-filled when locationId is 0
      selectedLocation.value = '';
      selectedLocationId.value = 0;
      print('locationId is 0, no location selected');
    }
  }

  void onLocationChanged(String? newValue, List<Location> locations) {
    if (newValue != null) {
      selectedLocation.value = newValue;
      // Find the selected location object and store its ID
      var selectedLocationObj = locations.firstWhere((location) =>
      location.name == newValue);
      selectedLocationId.value = selectedLocationObj.id;
    }
  }

  Future<void> updateRequirement(int requirementId, String title, String description, int locationId) async {
    final url = Uri.parse('https://project.artisans.qa/realestate/api/user/update-requirement');
    final token = await UserTypeManager.getToken();

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Replace with your actual token
      },
      body: {
        'requirement_id': requirementId.toString(),
        'title': title,
        'description': description,
        'location': locationId.toString(),
      },
    );
    print('API Response: ${response.body}');

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Requirement updated successfully');
    } else {
      // Handle error
      await Future.delayed(Duration(milliseconds: 200));
      Get.snackbar('Error', 'Failed to update requirement');
    }
  }


  Future<void> fetchLocations({int limit = 10, int offset = 0}) async {
    loading.value = true;
    final response = await http.get(
      Uri.parse(
          'https://project.artisans.qa/realestate/api/locations?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Location> locationList = (data['locations'] as List)
          .map((json) => Location.fromJson(json))
          .toList();
      locations.value = locationList;
      loading.value = false;
      print("success");
    } else {
      print("failed");
      loading.value = false;
      throw Exception('Failed to load locations');
    }
  }
}