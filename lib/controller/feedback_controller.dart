import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackController extends GetxController {
  RxBool hasFullNameFocus = false.obs;
  RxBool hasFullNameInput = false.obs;
  RxBool hasPhoneNumberFocus = false.obs;
  RxBool hasPhoneNumberInput = false.obs;
  RxBool hasEmailFocus = false.obs;
  RxBool hasEmailInput = false.obs;
  FocusNode focusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController aboutFeedbackController = TextEditingController();
  TextEditingController selectFeedbackController = TextEditingController();
  RxBool isLoading = false.obs;


  RxBool isSelectFeedbackExpanded = false.obs;
  RxInt isSelectFeedback = (-1).obs;
  RxDouble rating = 0.0.obs;


  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      hasFullNameFocus.value = focusNode.hasFocus;
    });
    phoneNumberFocusNode.addListener(() {
      hasPhoneNumberFocus.value = phoneNumberFocusNode.hasFocus;
    });
    emailFocusNode.addListener(() {
      hasEmailFocus.value = emailFocusNode.hasFocus;
    });
    fullNameController.addListener(() {
      hasFullNameInput.value = fullNameController.text.isNotEmpty;
    });
    phoneNumberController.addListener(() {
      hasPhoneNumberInput.value = phoneNumberController.text.isNotEmpty;
    });
    emailController.addListener(() {
      hasEmailInput.value = emailController.text.isNotEmpty;
    });
  }

  Future<void> submitFeedback() async {
    final String url = "https://project.artisans.qa/realestate/api/app-rating?"
        "rating=${rating.value}&"
        "comment=${Uri.encodeComponent(aboutFeedbackController.text)}&"
        "name=${Uri.encodeComponent(fullNameController.text)}&"
        "phone=${Uri.encodeComponent(phoneNumberController.text)}&"
        "email=${Uri.encodeComponent(emailController.text)}";

    try {
      isLoading.value = true;

      final response = await http.get(Uri.parse(url));

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final responseData = jsonDecode(response.body);
      print("Decoded Response: $responseData");

      if (response.statusCode == 200 && responseData["status"] == true) {
        Get.snackbar("Success", responseData["message"], snackPosition: SnackPosition.TOP);
        await Future.delayed(Duration(seconds: 2)); // Wait before navigating

        print("Navigating back..."); // Debugging
        Navigator.pop(Get.context!); // Ensure it runs
      } else {
        Get.snackbar("Error", responseData["message"], snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Something went wrong!", snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }



  void toggleSelectFeedbackExpansion() {
    isSelectFeedbackExpanded.value = !isSelectFeedbackExpanded.value;
  }
  void updateRating(double newRating) {
    if (rating.value == newRating) {
      rating.value = newRating - 1.0; // Decrease rating
    } else {
      rating.value = newRating;
    }
  }
  void updateSelectFeedback(int index) {
    isSelectFeedback.value = index;
    selectFeedbackController.text = selectFeedbackList[index];
  }

  RxList<String> selectFeedbackList = [
    AppString.iWantReportAProblem,
    AppString.iHaveSuggestions,
    AppString.iWantToComplimentApp,
    AppString.other,
  ].obs;

  @override
  void onClose() {
    focusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    aboutFeedbackController.dispose();
    selectFeedbackController.dispose();
    super.onClose();
  }
}