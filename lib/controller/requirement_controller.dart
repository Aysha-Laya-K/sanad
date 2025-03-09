import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/model/searchcontentlocation_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';


class RequirementController extends GetxController {
  // TextEditingControllers for form fields
  TextEditingController titleController = TextEditingController();
  TextEditingController slugController = TextEditingController();
  TextEditingController requirementDetailsController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  // FocusNodes for form fields


  // Rx variables to track focus and input states
 // New Rx variable for phone number input
  RxList<Location> locations = <Location>[].obs;
  var loading = true.obs;
  var requirementId = 0.obs;

  // Selected location
  RxString selectedLocation = ''.obs;
  var selectedLocationId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations();




    // Listen to focus changes for title field

  }

 /* void setSelectedLocationFromId(int locationId) {
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
  }*/

  void onLocationChanged(String? newValue, List<Location> locations) {
    if (newValue != null) {
      selectedLocation.value = newValue;
      // Find the selected location object and store its ID
      var selectedLocationObj = locations.firstWhere((location) => location.name == newValue);
      selectedLocationId.value = selectedLocationObj.id;
    }
  }


  Future<void> fetchLocations({int limit = 10, int offset = 0}) async {
    loading.value = true;
    final response = await http.get(
      Uri.parse('https://project.artisans.qa/realestate/api/locations?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Location> locationList = (data['locations'] as List)
          .map((json) => Location.fromJson(json))
          .toList();
      locations.value = locationList;
      print("success");
    } else {
      print("failed");
      throw Exception('Failed to load locations');

    }
  }

  // Method to handle form submission
  void submitRequirement(BuildContext context) async {
    // Unfocus all fields explicitly

    FocusScope.of(context).unfocus();
    // Check if the token is present
    final token = await UserTypeManager.getToken();
    if (token == null || token.isEmpty) {
      // Show a snackbar message indicating that login is required
      Get.snackbar(
        'Error',
        'Login is required to submit requirements',
        snackPosition: SnackPosition.TOP,
      );

      // Navigate to the login page
      Get.toNamed(AppRoutes.loginView);
      return;
    }

    // Validate form fields
    if (titleController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a title',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }



    if (selectedLocation.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a location',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (requirementDetailsController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your requirements',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Print the selected location ID
    print("Selected Location ID: ${selectedLocationId.value}");

    // If all fields are valid, proceed with API call
    try {
      final response = await http.post(
        Uri.parse('https://project.artisans.qa/realestate/api/user/save-requirement'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'title': titleController.text,
          'location': selectedLocationId.value.toString(), // Pass the location ID
          'description': requirementDetailsController.text,
        },
      );

      if (response.statusCode == 200) {
        print('API Response: ${response.body}');
        // Show success message
        Get.snackbar(
          'Success',
          'Your requirements have been submitted successfully!',
          snackPosition: SnackPosition.TOP,
        );

        // Clear form fields after submission

        titleController.clear();
        phoneNumberController.clear();
        requirementDetailsController.clear();
        selectedLocation.value = '';
        selectedLocationId.value = 0;
        // Reset the location ID
      } else {
        // Handle API error
        Get.snackbar(
          'Error',
          'Failed to submit requirements. Please try again.',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // Handle network or other errors
      Get.snackbar(
        'Error',
        'An error occurred. Please check your connection and try again.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}