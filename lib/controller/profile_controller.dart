import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/model/profile_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';

class ProfileController extends GetxController {
  RxInt selectEmoji = (-1).obs;
  RxBool isLoggedIn = false.obs;
  RxList<String> profileOptionImageList = <String>[].obs;
  RxList<String> profileOptionTitleList = <String>[].obs;
  Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  RxBool isLoading = false.obs;

  void updateEmoji(int index) {
    selectEmoji.value = index;
    sendFeedback(index + 1);
  }
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    checkTokenAndFetchProfile();
  }


  Future<void> checkTokenAndFetchProfile() async {
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


  Future<void> sendFeedback(int rating) async {
    final String apiUrl = "https://project.artisans.qa/realestate/api/app-feedback?rating=$rating";
    print("Sending feedback with rating: $rating");

    try {
      final response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print("Feedback submitted successfully: ${response.body}");
      } else {
        print("Failed to submit feedback: ${response.body}");
      }
    } catch (e) {
      print("Error submitting feedback: $e");
    }
  }

  Future<void> checkLoginStatus() async {
    String? token = await UserTypeManager.getToken();
    isLoggedIn.value = token != null;
    buildProfileOptions();
  }

  void buildProfileOptions() {
    profileOptionImageList.clear();
    profileOptionTitleList.clear();

    // Common options for all users
    profileOptionImageList.addAll([
      //Assets.images.profileOption1.path,
      //Assets.images.profileOption2.path,
      Assets.images.profileOption4.path,
      Assets.images.profileOption5.path,
    ]);
    profileOptionTitleList.addAll([
      //AppString.viewResponses,
     // AppString.languages,
      AppString.shareFeedback,
      AppString.areYouFindingUsHelpful,
    ]);

    // Conditional options based on login status
    if (isLoggedIn.value) {
      profileOptionImageList.addAll([
        Assets.images.save.path,
        Assets.images.needs.path,
        Assets.images.profileOption6.path,
        Assets.images.delete.path,
      ]);
      profileOptionTitleList.addAll([
        AppString.save1,
        AppString.myneeds,
        AppString.logout,
        AppString.deleteAccount,
      ]);
    } else {
      profileOptionImageList.add(Assets.images.profileOption6.path);
      profileOptionTitleList.add(AppString.login1);
    }
  }


  RxList<String> findingUsImageList = [
    Assets.images.poor.path,
    Assets.images.neutral.path,
    Assets.images.good.path,
    Assets.images.excellent.path,
  ].obs;

  RxList<String> findingUsTitleList = [
    AppString.poor,
    AppString.neutral,
    AppString.good,
    AppString.excellent,
  ].obs;
}
