import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/login_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/otp_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';

class OtpController extends GetxController {
  TextEditingController pinController = TextEditingController();

  RxString otp = ''.obs;
  RxBool isOTPValid = false.obs;
  RxInt countdown = 60.obs;
  Timer? timer;
  RxBool isLoading = false.obs; // New loading state
  Rx<OtpApiResponse?> otpApiResponse = Rx<OtpApiResponse?>(null); // Store OTP response

  @override
  void onInit() {
    super.onInit();
    startCountdown();
  }

  void validateOTP(String value) {
    otp.value = value;
    isOTPValid.value = otp.value.length == AppSize.size4 && _isNumeric(otp.value);
  }

  bool _isNumeric(String str) {
    return RegExp(r'^[0-9]+$').hasMatch(str);
  }

  void startCountdown() {
    countdown.value = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtp() async {
    String mobileNumber = Get.find<LoginController>().phoneNumber.value;
    String otp = pinController.text.trim();

    if (otp.isEmpty || otp.length < 4) {
      Get.snackbar("Error", "Please enter a valid OTP.");
      return;
    }

    final Uri apiUrl = Uri.parse("https://project.artisans.qa/realestate/api/confirm-otp");

    try {
      isLoading.value = true; // Set loading to true when API call starts
      final response = await http.post(
        apiUrl,
        body: {
          'phone': mobileNumber,
          'otp': otp,
        },
      );

      final responseData = json.decode(response.body);

      print("OTP Verification Response: $responseData");
      isLoading.value = false;

      if (response.statusCode == 200 && responseData['status'] == true) {


        // Parse and store the response data into the OtpApiResponse model
        otpApiResponse.value = OtpApiResponse.fromJson(responseData);

        // Check the message in the response to navigate accordingly
        if (responseData['message'] == 'new user') {


          // Navigate to the registration page for new users
          Get.offAllNamed(AppRoutes.registerView,  arguments: mobileNumber );
        } else if (responseData['message'] == 'already existing user') {


          await UserTypeManager.setUserType('existing');
          String token = responseData['token'] ?? '';


          await SharedPreferences.getInstance().then((prefs) {
            prefs.setString('token', token);
            print('Stored Token: ${otpApiResponse.value!.token}');
          });
          // Navigate to the home page for existing users
          Get.offAllNamed(AppRoutes.bottomBarView);
        }
      } else {
        Get.snackbar("Error", responseData['message'] ?? "Invalid OTP. Try again.");
      }
    } catch (e) {
      isLoading.value = false;
      print("API Error: $e");
      Get.snackbar("Error", "Failed to verify OTP. Please try again.");
    }
  }

  String get formattedCountdown {
    int minutes = countdown.value ~/ 60;
    int seconds = countdown.value % 60;
    return '${_formatTimeComponent(minutes)}:${_formatTimeComponent(seconds)}';
  }

  String _formatTimeComponent(int time) {
    return time < 10 ? '0$time' : '$time';
  }

  @override
  void dispose() {
    super.dispose();
    pinController.clear();
  }
}
