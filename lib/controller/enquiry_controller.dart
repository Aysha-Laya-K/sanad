import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';

class EnquiryController extends GetxController {
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

  RxBool isSelectFeedbackExpanded = false.obs;
  RxInt isSelectFeedback = (-1).obs;

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

  Future<void> submitEnquiry(BuildContext context, int propertyId) async {
    final token = await UserTypeManager.getToken(); // Fetch token

    if (token == null) {
      // Token is null, show login required message and navigate to login page
      Get.snackbar(
        'Login Required',
        'Please log in to submit the enquiry.',
        snackPosition: SnackPosition.TOP,
      );
      Get.toNamed(AppRoutes.loginView); // Navigate to login page
      return;
    }

    // Prepare the API request data
    final enquiryData = {
      'property_id': propertyId,
      'name': fullNameController.text,
      'phone': phoneNumberController.text,
      'email': emailController.text,
      'comment': aboutFeedbackController.text,
    };

    try {
      // Call the API
      final response = await http.post(
        Uri.parse('https://project.artisans.qa/realestate/api/user/booking'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(enquiryData),
      );
      print('API Response: ${response.body}');

      // Parse the response
      final responseData = jsonDecode(response.body);

      if (responseData['status'] == true) {
        Get.back(result: propertyId);
        // If the response status is true, show success message
        Get.snackbar(
          'Success',
          'Your enquiry has been submitted successfully.',
          snackPosition: SnackPosition.TOP,
        );
        //Get.back(result: propertyId);
      } else {
        // If the response status is error, show error message with details
        final errors = responseData['errors'];
        String errorMessage = responseData['message'];

        if (errors != null) {
          // Concatenate errors if present
          errorMessage += '\n' + errors.entries.map((e) => '${e.key}: ${e.value.join(', ')}').join('\n');
        }

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.TOP,

        );
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      Get.snackbar(
        'Error',
        'An error occurred. Please try again later.',
        snackPosition: SnackPosition.TOP,

      );
    }
  }




  void toggleSelectFeedbackExpansion() {
    isSelectFeedbackExpanded.value = !isSelectFeedbackExpanded.value;
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