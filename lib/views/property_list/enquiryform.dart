import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_button.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_textfield.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/enquiry_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/feedback_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';

class EnquiryForm extends StatelessWidget {
  EnquiryForm({super.key});

  EnquiryController enquiryController = Get.put(EnquiryController());
  final int propertyId = Get.arguments ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(propertyId),
      body: buildFeedbackFields(context,propertyId),
      bottomNavigationBar: buildButton(context,propertyId),
    );
  }

  AppBar buildAppBar(propertyId) {
    return AppBar(
      backgroundColor: AppColor.whiteColor,
      scrolledUnderElevation: AppSize.appSize0,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSize.appSize16),
        child: GestureDetector(
          onTap: () {
            Get.back(result: propertyId);
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      title: Text(
       "Enquiry Form",
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildFeedbackFields(BuildContext context, propertyId) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      child: Column(
        children: [

          Obx(() => AnimatedContainer(
            duration: const Duration(seconds: AppSize.size1),
            curve: Curves.fastEaseInToSlowEaseOut,
            margin: EdgeInsets.only(
              top: enquiryController.isSelectFeedbackExpanded.value
                  ? AppSize.appSize16
                  : AppSize.appSize0,
            ),
            height:enquiryController.isSelectFeedbackExpanded.value
                ? null
                : AppSize.appSize0,
            child: enquiryController.isSelectFeedbackExpanded.value
                ? GestureDetector(
              onTap: () {
                // editProfileController.toggleWhatAreYouHereExpansion();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                  top: AppSize.appSize16,
                  bottom: AppSize.appSize6,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(AppSize.appSize12),
                  color: AppColor.whiteColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: AppSize.appSizePoint1,
                      blurRadius: AppSize.appSize2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(enquiryController.selectFeedbackList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        enquiryController.updateSelectFeedback(index);
                        enquiryController.toggleSelectFeedbackExpansion();
                      },
                      child: Text(
                        enquiryController.selectFeedbackList[index],
                        style: AppStyle.heading5Regular(
                          color: enquiryController.isSelectFeedback.value == index
                              ? AppColor.primaryColor
                              : AppColor.textColor,
                        ),
                      ).paddingOnly(left: AppSize.appSize10).paddingOnly(bottom: AppSize.appSize16),
                    );
                  }),
                ),
              ),
            ) : const SizedBox.shrink(),
          )),

          Obx(() => CommonTextField(
            controller: enquiryController.fullNameController,
            focusNode:enquiryController.focusNode,
            hasFocus: enquiryController.hasFullNameFocus.value,
            hasInput: enquiryController.hasFullNameInput.value,
            hintText: AppString.fullName,
            labelText: AppString.fullName,
          )).paddingOnly(top: AppSize.appSize16),
          Obx(() => CommonTextField(
            controller:enquiryController.phoneNumberController,
            focusNode: enquiryController.phoneNumberFocusNode,
            hasFocus: enquiryController.hasPhoneNumberFocus.value,
            hasInput:enquiryController.hasPhoneNumberInput.value,
            hintText: AppString.phoneNumber,
            labelText: AppString.phoneNumber,
            keyboardType: TextInputType.phone,
          )).paddingOnly(top: AppSize.appSize16),
          Obx(() => CommonTextField(
            controller: enquiryController.emailController,
            focusNode:enquiryController.emailFocusNode,
            hasFocus: enquiryController.hasEmailFocus.value,
            hasInput: enquiryController.hasEmailInput.value,
            hintText: AppString.emailAddress,
            labelText: AppString.emailAddress,
            keyboardType: TextInputType.emailAddress,
          )).paddingOnly(top: AppSize.appSize16),
          TextFormField(
            controller: enquiryController.aboutFeedbackController,
            cursorColor: AppColor.primaryColor,
            style: AppStyle.heading4Regular(color: AppColor.textColor),
            maxLines: AppSize.size3,
            decoration: InputDecoration(
              hintText: AppString.type,
              hintStyle: AppStyle.heading4Regular(color: AppColor.descriptionColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                borderSide: BorderSide(
                  color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint7),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                borderSide: BorderSide(
                  color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint7),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                borderSide: const BorderSide(
                  color: AppColor.primaryColor,
                ),
              ),
            ),
          ).paddingOnly(top: AppSize.appSize16),

        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16, right: AppSize.appSize16,
      ),
    );
  }

  Widget buildButton(BuildContext context,propertyId) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CommonButton(
        onPressed: () {

          enquiryController.submitEnquiry(context, propertyId);

        },
        backgroundColor: AppColor.primaryColor,
        child: Text(
          AppString.submitButton,
          style: AppStyle.heading5Medium(color: AppColor.whiteColor),
        ),
      ).paddingOnly(
        left: AppSize.appSize16, right: AppSize.appSize16,
        bottom: AppSize.appSize26, top: AppSize.appSize10,
      ),
    );
  }
}
