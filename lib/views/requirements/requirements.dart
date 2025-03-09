import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_button.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_textfield.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/requirement_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/searchcontentlocation_model.dart';

class RequirementView extends StatelessWidget {
  RequirementView({super.key});

  RequirementController requirementController = Get.put(RequirementController());

  @override
  Widget build(BuildContext context) {
   /* final arguments = Get.arguments;

    if (arguments != null) {
      print('Navigated with needId: ${arguments['needId']}');
      print('Passed locationId: ${arguments['locationId']}');

      requirementController.titleController.text = arguments['title'];
      requirementController.requirementDetailsController.text = arguments['description'];
      int locationId = arguments['locationId'] ?? 0;

      if (locationId > 0) {
        requirementController.setSelectedLocationFromId(locationId);
      } else {
        print('locationId is 0, resetting dropdown');
        requirementController.selectedLocation.value = ''; // Reset dropdown
        requirementController.selectedLocationId.value = 0;
      }
    } else {
      // Clear fields when no arguments are passed
      requirementController.titleController.clear();
      requirementController.requirementDetailsController.clear();
      requirementController.selectedLocation.value = '';
      requirementController.selectedLocationId.value = 0;
    }*/

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildRequirementFields(context),
      bottomNavigationBar: buildButton(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.whiteColor,
      scrolledUnderElevation: AppSize.appSize0,
      centerTitle: true,
      title: Text(
        "Requirement Form",
        style: AppStyle.heading3SemiBold(color: AppColor.textColor),
      ),
    );
  }

  Widget buildRequirementFields(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      child: Column(
        children: [
         TextFormField(
            controller: requirementController.titleController,
            decoration: InputDecoration(
              hintText: "Enter Title",
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
          // Add the phone number input field with static country code
          /*Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSize.appSize12, vertical: AppSize.appSize16),
                decoration: BoxDecoration(

                  border: Border.all(
                    color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint7),
                  ),
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                ),
                child: Text(
                  "+974",
                  style: AppStyle.heading4Regular(color: Colors.grey),
                ),
              ),
              const SizedBox(width: AppSize.appSize8),
              Expanded(
                child:  TextFormField(
                  controller: requirementController.phoneNumberController,
                  decoration: InputDecoration(
                    hintText: "Enter Phone Number",
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

                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ).paddingOnly(top: AppSize.appSize16),*/
      Obx(
            () => DropdownButtonFormField<String>(
          value: requirementController.selectedLocation.value.isEmpty
              ? null
              : requirementController.selectedLocation.value,
          onChanged: (String? newValue) {
            requirementController.onLocationChanged(newValue, requirementController.locations);
          },
          items: requirementController.locations.map<DropdownMenuItem<String>>((Location location) {
            return DropdownMenuItem<String>(
              value: location.name,
              child: Text(
                location.name,
                style: AppStyle.heading4Regular(color: AppColor.textColor),
              ),
            );
          }).toList(),
          dropdownColor: AppColor.whiteColor,
          decoration: InputDecoration(
            hintText: "Select Location",
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSize.appSize16,
              vertical: AppSize.appSize12,
            ),
            isDense: true,
          ),
          icon: GestureDetector(
            onTap: () {
              if (requirementController.selectedLocation.value.isNotEmpty) {
                requirementController.selectedLocation.value = ''; // Clear selection
              }
            },
            child: Icon(
              requirementController.selectedLocation.value.isEmpty
                  ? Icons.arrow_drop_down // Default dropdown icon
                  : Icons.close, // Close icon when a location is selected
              color: AppColor.primaryColor,
            ),
          ),
          onTap: () {
            if (requirementController.selectedLocation.value.isNotEmpty) {
              return; // Prevent the dropdown from opening
            }
          },
        ),
      ).paddingOnly(top: AppSize.appSize16),
          TextFormField(
            controller: requirementController.requirementDetailsController,
            cursorColor: AppColor.primaryColor,
            style: AppStyle.heading4Regular(color: AppColor.textColor),
            maxLines: AppSize.size3,
            decoration: InputDecoration(
              hintText: "Enter your requirements",
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

  Widget buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CommonButton(
        onPressed: () {
          requirementController.submitRequirement(context);
        },
        backgroundColor: AppColor.primaryColor,
        child: Text(
          "Submit",
          style: AppStyle.heading5Medium(color: AppColor.whiteColor),
        ),
      ).paddingOnly(
        left: AppSize.appSize16, right: AppSize.appSize16,
        bottom: AppSize.appSize26, top: AppSize.appSize10,
      ),
    );
  }
}