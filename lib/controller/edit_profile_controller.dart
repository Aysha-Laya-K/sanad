import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/profile_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileController extends GetxController {
  RxBool hasFullNameFocus = true.obs;
  RxBool hasFullNameInput = true.obs;
  RxBool hasPhoneNumberFocus = true.obs;
  RxBool hasPhoneNumberInput = true.obs;
  RxBool hasPhoneNumber2Focus = false.obs;
  RxBool hasPhoneNumber2Input = false.obs;
  RxBool hasEmailFocus = true.obs;
  RxBool hasEmailInput = true.obs;
  FocusNode focusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode phoneNumber2FocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController phoneNumber2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController whatAreYouHereController = TextEditingController();

  RxBool isWhatAreYouHereExpanded = false.obs;
  RxInt isWhatAreYouHereSelect = 0.obs;
  RxString profileImagePath = ''.obs;
  Rx<Uint8List?> webImage = Rx<Uint8List?>(null);
  RxString profileImage="".obs;
  Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      hasFullNameFocus.value = focusNode.hasFocus;
    });
    phoneNumberFocusNode.addListener(() {
      hasPhoneNumberFocus.value = phoneNumberFocusNode.hasFocus;
    });
    phoneNumber2FocusNode.addListener(() {
      hasPhoneNumber2Focus.value = phoneNumber2FocusNode.hasFocus;
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
    phoneNumber2Controller.addListener(() {
      hasPhoneNumber2Input.value = phoneNumber2Controller.text.isNotEmpty;
    });
    emailController.addListener(() {
      hasEmailInput.value = emailController.text.isNotEmpty;
    });
    _checkTokenAndFetchProfile();
  }

  void toggleWhatAreYouHereExpansion() {
    isWhatAreYouHereExpanded.value = !isWhatAreYouHereExpanded.value;
  }

  void updateWhatAreYouHere(int index) {
    isWhatAreYouHereSelect.value = index;
    whatAreYouHereController.text = whatAreYouHereList[index];
  }
  Future<void> _checkTokenAndFetchProfile() async {
    final token = await UserTypeManager.getToken();
    if (token != null) {
      // If token exists, fetch the profile from the API
      await _fetchProfileData(token);
    } else {
      // If token is null, remain with the default greeting
      userProfile.value = null;
    }
  }

  // API call to fetch user profile
  Future<void> _fetchProfileData(String token) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('https://project.artisans.qa/realestate/api/user/my-profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response and update userProfile
        final profileData = UserProfile.fromJson(jsonDecode(response.body)['user']);
        userProfile.value = profileData;
      } else {
        // Handle API error
        Get.snackbar('Error', 'Failed to fetch profile data');
      }
    } catch (e) {
      // Handle other errors (network issues, etc.)
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }





  Future<void> updateProfileImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image != null)
    {
      if(kIsWeb)
      {
        webImage.value  =await image.readAsBytes();
      }else{
        profileImage.value=image.path;
      }
    }
  }

  RxList<String> whatAreYouHereList = [
    AppString.toBuyProperty,
    AppString.toSellProperty,
    AppString.iAmABroker,
  ].obs;

  @override
  void onClose() {
    focusNode.dispose();
    phoneNumberFocusNode.dispose();
    phoneNumber2FocusNode.dispose();
    emailFocusNode.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    phoneNumber2Controller.dispose();
    emailController.dispose();
    aboutMeController.dispose();
    whatAreYouHereController.dispose();
    super.onClose();
  }
}