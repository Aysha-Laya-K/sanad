import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';

class LoginController extends GetxController {
  RxBool hasFocus = false.obs;
  RxBool hasInput = false.obs;
  FocusNode focusNode = FocusNode();
  TextEditingController mobileController = TextEditingController();
  var phoneNumber = ''.obs;


  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      hasFocus.value = focusNode.hasFocus;
    });
    mobileController.addListener(() {
      hasInput.value = mobileController.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    focusNode.dispose();
    mobileController.dispose();
    super.onClose();
  }

  Future<void> sendMobileNumber() async {
    final String mobileNumber = mobileController.text.trim();
    if (mobileNumber.isEmpty) {
      Get.snackbar("Error", "Please enter a valid mobile number");
      return;
    }

    final Uri apiUrl = Uri.parse("https://project.artisans.qa/realestate/api/sent-mobile-number");
    try {
      final response = await http.post(
        apiUrl,
        body: {'phone': mobileNumber},
      );

      final responseData = json.decode(response.body);
      print("API Response: $responseData");

      if (response.statusCode == 200 && responseData['status'] == true) {

        Get.snackbar("Success", responseData['message']);
        phoneNumber.value = mobileNumber;
        print("Stored Mobile Number: ${phoneNumber.value}");
        Get.toNamed(AppRoutes.otpView);
      } else {
        Get.snackbar("Error", responseData['message'] ?? "Something went wrong");
      }
    } catch (e) {
      print("API Error: $e");
      Get.snackbar("Error", "Failed to send OTP. Please try again.");
    }
  }





}
