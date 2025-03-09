import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/bottom_bar_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/profile_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/translation_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/profile/widgets/delete_account_bottom_sheet.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/profile/widgets/finding_us_helpful_bottom_sheet.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/profile/widgets/logout_bottom_sheet.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/saved/saved_properties_view.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  ProfileController profileController = Get.put(ProfileController());
  TranslationController translationController =
      Get.put(TranslationController());


  @override
  Widget build(BuildContext context) {
    profileController.checkTokenAndFetchProfile();


    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildProfile(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.whiteColor,
      scrolledUnderElevation: AppSize.appSize0,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSize.appSize16),
        child: GestureDetector(
          onTap: () {
            BottomBarController bottomBarController =
                Get.put(BottomBarController());
            bottomBarController.pageController.jumpToPage(AppSize.size0);
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      title: Obx(() => Text(
            translationController.translate(AppString.profile),
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          )),
    );
  }

  Widget buildProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
               /* CircleAvatar(
                  radius: AppSize.appSize30, // Adjust size as needed
                  backgroundColor: AppColor.primaryColor, // Set the background color
                  child: Icon(
                    Icons.person, // Replace with the icon of your choice
                    size: AppSize.appSize30, // Adjust icon size as needed
                    color: AppColor.whiteColor, // Icon color (white in this case)
                  ),
                ).paddingOnly(right: AppSize.appSize18),*/
                /*Image.asset(
                  "assets/images/checkbox.png",
                  // "assets/images/checkbox.png",
                  width: AppSize.appSize68,
                ).paddingOnly(right: AppSize.appSize16),*/
                /*Obx(() => Text(
                      translationController.translate(AppString.francisZieme),
                      style: AppStyle.heading3Medium(color: AppColor.textColor),
                    )),*/


                Obx(() {
                  final user = profileController.userProfile.value;
                  final userImage = user?.image;

                  return CircleAvatar(
                    radius: AppSize.appSize30, // Adjust size as needed
                    backgroundColor: AppColor.primaryColor, // Set the background color
                    child: userImage != null && userImage.isNotEmpty
                        ? ClipOval(
                      child: Image.network(
                        userImage,
                        width: AppSize.appSize60, // Adjust width as needed
                        height: AppSize.appSize60, // Adjust height as needed
                        fit: BoxFit.cover, // Ensure the image covers the circle
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // If image is loaded, return the image
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.whiteColor),
                              ),
                            );
                          }
                        },
                      ),
                    )
                        : Icon(
                      Icons.person, // Default icon if no image
                      size: AppSize.appSize30, // Adjust icon size as needed
                      color: AppColor.whiteColor, // Icon color (white in this case)
                    ),
                  );
                }).paddingOnly(right: AppSize.appSize18),




                Obx(() {
                  final user = profileController.userProfile.value;
                  final greetingName = user?.name ?? 'Customer'; // Default to 'Francis' if null
                  return Text(
                    greetingName,
                    style: AppStyle.heading3Medium(color: AppColor.textColor),
                  );
                }),
              ],
            ),
            Obx(() => profileController.isLoggedIn.value
                ? GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.editProfileView)?.then((_) {
                  // Refresh profile data after editing
                  profileController.checkTokenAndFetchProfile();
                });


              },
              child: Text(
                translationController.translate(AppString.editProfile),
                style: AppStyle.heading5Medium(color: AppColor.primaryColor),
              ),
            )
                : Container()),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: AppSize.appSize36),
          itemCount: profileController.profileOptionImageList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                String titleKey = profileController.profileOptionTitleList[index];
                if (titleKey == AppString.viewResponses) {
                  Get.toNamed(AppRoutes.responsesView);
                } else if (titleKey == AppString.languages) {
                  Get.toNamed(AppRoutes.languagesView);// Handle languages
                } else if (titleKey == AppString.shareFeedback) {
                  Get.toNamed(AppRoutes.feedbackView);
                } else if (titleKey == AppString.areYouFindingUsHelpful) {
                  findingUsHelpfulBottomSheet(context);
                } else if (titleKey == AppString.login1) {
                  Get.toNamed(AppRoutes.loginView);
                }
                else if (titleKey == AppString.save1) {
                  Get.toNamed(AppRoutes.savedPropertiesView);
                }
                else if (titleKey == AppString.myneeds) {
                  Get.toNamed(AppRoutes.myNeeds);
                }

                else if (titleKey == AppString.logout) {
                  logoutBottomSheet(context);
                } else if (titleKey == AppString.deleteAccount) {
                  deleteAccountBottomSheet(context);
                }
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        profileController.profileOptionImageList[index],
                        width: AppSize.appSize20,
                      ).paddingOnly(right: AppSize.appSize12),
                      Obx(() => Text(
                            translationController.translate(profileController
                                .profileOptionTitleList[index]),
                            style: AppStyle.heading5Regular(
                                color: AppColor.textColor),
                          )),
                    ],
                  ),
                  if (index <
                      profileController.profileOptionImageList.length -
                          AppSize.size1) ...[
                    Divider(
                      color: AppColor.descriptionColor
                          .withOpacity(AppSize.appSizePoint4),
                      height: AppSize.appSize0,
                      thickness: AppSize.appSizePoint7,
                    ).paddingOnly(
                        top: AppSize.appSize16, bottom: AppSize.appSize26),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    ).paddingOnly(
      top: AppSize.appSize10,
      left: AppSize.appSize16,
      right: AppSize.appSize16,
    );
  }
}
