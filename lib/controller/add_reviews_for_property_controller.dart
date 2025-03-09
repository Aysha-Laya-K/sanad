import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';

class AddReviewsForPropertyController extends GetxController {
  TextEditingController writeAReviewController = TextEditingController();
  RxDouble rating = 0.0.obs; // Observable rating value


  Future<void> submitReview(int propertyId) async {
    final token = await UserTypeManager.getToken();

    if (token == null) {
      // Show login required message and navigate to login page
      Get.snackbar(
        'Login Required',
        'Please log in to submit the review.',
        snackPosition: SnackPosition.TOP,
      );
      Get.toNamed(AppRoutes.loginView); // Navigate to login page
      return; // Navigate to login page
    }

    try {
      // If token is not null, send review to the API
      final response = await http.post(
        Uri.parse('https://project.artisans.qa/realestate/api/store-property-review'),
        body: {
          'property_id': propertyId.toString(),
          'rating': rating.value.toString(),
          'review': writeAReviewController.text,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Print the API response for debugging
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        Get.back(result: propertyId);
        // Handle successful response
        Get.snackbar('Success', 'Review submitted successfully!',
            snackPosition: SnackPosition.TOP);
        // Close the review page
      } else {
        // Handle failure response
        Get.snackbar('Error', 'Failed to submit your review.',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      print('Error: $e');
      Get.snackbar('Error', 'An error occurred while submitting the review.',
          snackPosition: SnackPosition.TOP);
    }
  }

  void updateRating(double newRating) {
    if (rating.value == newRating) {
      rating.value = newRating - 1.0; // Decrease rating
    } else {
      rating.value = newRating;
    }
  }


  @override
  void dispose() {
    writeAReviewController.dispose();
    super.dispose();
  }
}

