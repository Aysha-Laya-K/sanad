import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/user_type/user_type_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';

logoutBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    shape: const OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppSize.appSize12),
        topRight: Radius.circular(AppSize.appSize12),
      ),
      borderSide: BorderSide.none,
    ),
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: AppSize.appSize180,
        padding: const EdgeInsets.only(
          top: AppSize.appSize26,
          bottom: AppSize.appSize20,
          left: AppSize.appSize16,
          right: AppSize.appSize16,
        ),
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.appSize12),
            topRight: Radius.circular(AppSize.appSize12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.logout,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Text(
                  AppString.logoutString,
                  style: AppStyle.heading5Regular(
                      color: AppColor.descriptionColor),
                ).paddingOnly(top: AppSize.appSize6),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: AppSize.appSize49,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(AppSize.appSize12),
                      ),
                      child: Center(
                        child: Text(
                          AppString.noButton,
                          style: AppStyle.heading5Medium(
                              color: AppColor.primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.appSize26),
                Expanded(
                  child: GestureDetector(
                    // onTap: () {
                    //   Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             UserTypeScreen()), // New route
                    //     (route) =>
                    //         false, // This will remove all previous routes
                    //   );
                    // },

                    onTap: () {
                      _logoutUser(context);
                    },
                    child: Container(
                      height: AppSize.appSize49,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(AppSize.appSize12),
                      ),
                      child: Center(
                        child: Text(
                          AppString.yesButton,
                          style: AppStyle.heading5Medium(
                              color: AppColor.whiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}


_logoutUser(BuildContext context) async {
  String? token = await UserTypeManager.getToken();
  if (token != null) {
    try {
      final response = await http.post(
        Uri.parse('https://project.artisans.qa/realestate/api/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Successfully logged out
        print('Logout successful: ${response.body}');
        // Clear the token
        await UserTypeManager.removeToken();

        // Optionally verify the token is cleared
        String? clearedToken = await UserTypeManager.getToken();
        print('Cleared Token: $clearedToken');
        Get.snackbar("Success", "Logout Successfully");
        // Navigate to login screen
        Get.offAllNamed(AppRoutes.bottomBarView);
      } else {
        // If the API call fails
        print('Logout failed: ${response.body}');
      }
    } catch (e) {
      // Handle error
      print('Error during logout: $e');
    }
  } else {
    print('Token is null');
  }
}
