import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';







class RegisterController extends GetxController {
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

  RxInt selectOption = 0.obs;
  RxBool isChecked = false.obs;

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

  void toggleCheckbox() {
    isChecked.toggle();
  }

  Future<void> registerUser( String mobileNumber) async {
    // Check if any of the fields are empty
    if (fullNameController.text.isEmpty || emailController.text.isEmpty || !isChecked.value) {
      // Show a snackbar with an error message
      Get.snackbar(
        'Error',
        'Please fill in all the fields',
        snackPosition: SnackPosition.TOP,
        borderRadius: 10,
      );
      return; // Exit the function if fields are not filled
    }

    final url = 'https://project.artisans.qa/realestate/api/register';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': fullNameController.text,
        'phone':  mobileNumber,
        'email': emailController.text,
        'terms': isChecked.value ? '1' : '0',
      },
    );

    if (response.statusCode == 200) {
      // Handle success
      var data = json.decode(response.body);

      // Parse the response into RegisterApiResponse model
      RegisterApiResponse registerResponse = RegisterApiResponse.fromJson(data);

      print('Registration successful: $registerResponse');
      print("${(response.body)}");


      // Check if the registration is successful (status is true)
      if (registerResponse.status) {
        String token = registerResponse.token ?? '';
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('token', token);
          print('Stored Token: ${registerResponse.token}');
        });
        // You can navigate to the next screen after successful registration
        Get.offAllNamed(AppRoutes.bottomBarView);
      } else {
        // Show the error message from the response
        Get.snackbar(
          'Registration Failed',
          registerResponse.message,
          snackPosition: SnackPosition.TOP,
          borderRadius: 10,
        );
      }
    } else {
      // Handle error
      print('Failed to register: ${response.body}');
      // Show error message if needed
      Get.snackbar(
        'Registration Failed',
        'An error occurred while registering. Please try again.',
        snackPosition: SnackPosition.TOP,
        borderRadius: 10,
      );
    }
  }


  @override
  void onClose() {
    focusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
