import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_button.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_textfield.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/req_update_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/searchcontentlocation_model.dart';

class UpdateRequirementView extends StatefulWidget {
  UpdateRequirementView({Key? key}) : super(key: key);

  @override
  _UpdateRequirementViewState createState() => _UpdateRequirementViewState();
}

class _UpdateRequirementViewState extends State<UpdateRequirementView> {
  final RequirementUpdateController requirementupdateController = Get.put(RequirementUpdateController());

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;

    if (arguments != null) {
      print('Navigated with reqId: ${arguments['requirementId']}');
      print('Passed locationId: ${arguments['locationId']}');

      // Only set the initial values if they haven't been set yet
      if (requirementupdateController.titleController.text.isEmpty) {
        requirementupdateController.titleController.text = arguments['title'];
        requirementupdateController.requirementDetailsController.text = arguments['description'];
        int locationId = arguments['locationId'] ?? 0;

        // Ensure locations are fetched before setting the selected location
        requirementupdateController.fetchLocations().then((_) {
          if (locationId > 0) {
            requirementupdateController.setSelectedLocationFromId(locationId);
          } else {
            print('locationId is 0, resetting dropdown');
            requirementupdateController.selectedLocation.value = ''; // Reset dropdown
            requirementupdateController.selectedLocationId.value = 0;
          }
        });
      }
    } else {
      // Clear fields when no arguments are passed
      requirementupdateController.titleController.clear();
      requirementupdateController.requirementDetailsController.clear();
      requirementupdateController.selectedLocation.value = '';
      requirementupdateController.selectedLocationId.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        "Update Requirement",
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
          // Title TextField
          TextFormField(
            controller: requirementupdateController.titleController,
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

          // Location Dropdown
          Obx(
                () => DropdownButtonFormField<String>(
              value: requirementupdateController.selectedLocation.value.isEmpty
                  ? null
                  : requirementupdateController.selectedLocation.value,
              onChanged: (String? newValue) {
                requirementupdateController.onLocationChanged(newValue, requirementupdateController.locations);
              },
              items: requirementupdateController.locations.map<DropdownMenuItem<String>>((Location location) {
                return DropdownMenuItem<String>(
                  value: location.name,
                  child: Text(
                    location.name,
                    style: AppStyle.heading4Regular(color: AppColor.textColor),
                  ),
                );
              }).toList(),
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
                  if (requirementupdateController.selectedLocation.value.isNotEmpty) {
                    requirementupdateController.selectedLocation.value = ''; // Clear selection
                  }
                },
                child: Icon(
                  requirementupdateController.selectedLocation.value.isEmpty
                      ? Icons.arrow_drop_down // Default dropdown icon
                      : Icons.close, // Close icon when a location is selected
                  color: AppColor.primaryColor,
                ),
              ),
            ),
          ).paddingOnly(top: AppSize.appSize16),

          // Description TextField
          TextFormField(
            controller: requirementupdateController.requirementDetailsController,
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
        onPressed: () async {
          // Get the current values from the controllers
          final title = requirementupdateController.titleController.text;
          final description = requirementupdateController.requirementDetailsController.text;
          final locationId = requirementupdateController.selectedLocationId.value;
          final arguments = Get.arguments;
          final requirementId = arguments['requirementId'];

          // Call the API to update the requirement
          await requirementupdateController.updateRequirement(
            requirementId, // Pass the requirement ID
            title,
            description,
            locationId,
          );
        },
        backgroundColor: AppColor.primaryColor,
        child: Text(
          "Update",
          style: AppStyle.heading5Medium(color: AppColor.whiteColor),
        ),
      ).paddingOnly(
        left: AppSize.appSize16, right: AppSize.appSize16,
        bottom: AppSize.appSize26, top: AppSize.appSize10,
      ),
    );
  }
}