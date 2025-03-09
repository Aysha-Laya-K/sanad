import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_rich_text.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/bottom_bar_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/property_list_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/text_segment_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/widget/filter_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/search_filter_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/propertytype_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/property__model.dart';

class PropertyListView extends StatelessWidget {
  PropertyListView({super.key});

  PropertyListController propertyListController =
  Get.put(PropertyListController());
  final SearchFilterController searchFilterController = Get.put(SearchFilterController());


  @override
  Widget build(BuildContext context) {


    final PropertyResponse response = Get.arguments;
    propertyListController.isPropertyLiked.value =
    List<bool>.generate(response.data.length, (index) => false);


    // Print the received response in the terminal
    print("Received Property Response: ${response.message}");
    print("Total Properties: ${response.data.length}");
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildPropertyList(context, response),
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
            Get.back();
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      /*actions: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
                Get.back();
                Future.delayed(
                  const Duration(milliseconds: AppSize.size400),
                      () {
                    BottomBarController bottomBarController =
                    Get.put(BottomBarController());
                    bottomBarController.pageController
                        .jumpToPage(AppSize.size3);
                  },
                );
              },
              child: Image.asset(
                Assets.images.save.path,
                width: AppSize.appSize24,
                color: AppColor.descriptionColor,
              ).paddingOnly(right: AppSize.appSize26),
            ),
            GestureDetector(
              onTap: () {
                Share.share(AppString.appName);
              },
              child: Image.asset(
                Assets.images.share.path,
                width: AppSize.appSize24,
              ),
            ),
          ],
        ).paddingOnly(right: AppSize.appSize16),
      ],*/
    );
  }

  Widget buildPropertyList(BuildContext context, PropertyResponse response) {
    bool isDataEmpty = response.data.isEmpty;



    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.appSize12),
              color: AppColor.whiteColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: AppSize.appSizePoint1,
                  blurRadius: AppSize.appSize2,
                ),
              ],
            ),
            child: TextFormField(
              controller: propertyListController.searchController,
              cursorColor: AppColor.primaryColor,
              style: AppStyle.heading4Regular(color: AppColor.textColor),
              readOnly: true,
              onTap: () {
                Get.toNamed(AppRoutes.searchView);


              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  top: AppSize.appSize16,
                  bottom: AppSize.appSize16,
                ),
                hintText: AppString.searchPropertyText,
                hintStyle:
                AppStyle.heading4Regular(color: AppColor.descriptionColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    left: AppSize.appSize16,
                    right: AppSize.appSize16,
                  ),
                  child: Image.asset(
                    Assets.images.search.path,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  maxWidth: AppSize.appSize51,
                ),
              ),
            ),
          ),*/
          isDataEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSize.appSize150),
              child: Text(
                "No property found",
                style: AppStyle.heading5Regular(
                    color: AppColor.descriptionColor),
              ),
            ),
          )


          :ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: response.data.length,
            itemBuilder: (context, index) {
              final property = response.data[index]; // Fetching property details

              return GestureDetector(
                onTap: () {
                  final int propertyId =response.data[index].id;
                  /*print('Tapped on property with ID: $propertyId');

                  // Wait for the API call to finish before proceeding
                  await fetchPropertyDetails(propertyId);

                  // Print the property details that will be passed to the next view
                  print('Passing property details: ${propertyDetails.value?.property?.title}');

                  Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyDetails.value);*/



                  print('Tapped on property with ID: $propertyId');
                  // await propertyController.fetchPropertyDetails(propertyId); // Fetch details
                  //Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyController.propertyDetails.value);
                  Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyId);
                },

                child: Container(
                  padding: const EdgeInsets.all(AppSize.appSize10),
                  margin: const EdgeInsets.only(bottom: AppSize.appSize16),
                  decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(AppSize.appSize12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            response.data[index].thumbnailImage,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child; // Image loaded
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ?? 1)
                                        : null
                                        : null,
                                  ),
                                ); // Loading indicator while the image loads
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error); // Fallback for when the image fails to load
                            },
                          ),

                          Positioned(
                            right: AppSize.appSize6,
                            top: AppSize.appSize6,
                            child: GestureDetector(
                              onTap: () {
                                propertyListController.isPropertyLiked[index] =
                                !propertyListController.isPropertyLiked[index];
                              },
                              child: Container(
                                width: AppSize.appSize32,
                                height: AppSize.appSize32,
                                decoration: BoxDecoration(
                                  color: AppColor.whiteColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(AppSize.appSize6),
                                ),
                                child: Center(
                                  child: Obx(() => Icon(
                                    propertyListController.isPropertyLiked[index]
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Colors.grey,
                                    size: AppSize.appSize24,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: AppSize.appSize16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              response.data[index].title, // Dynamic title
                              style: AppStyle.heading5SemiBold(
                                  color: AppColor.textColor),
                            ),
                            Text(
                              response.data[index].slug, // Dynamic title
                              style: AppStyle.heading5SemiBold(
                                  color: AppColor.textColor),
                            ),
                            Text(
                              response.data[index].address, // Dynamic address
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ).paddingOnly(top: AppSize.appSize6),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: AppSize.appSize16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "QAR ${response.data[index].price}", // Dynamic price
                              style: AppStyle.heading5Medium(
                                  color: AppColor.primaryColor),
                            ),
                            Row(
                              children: [
                                Text(
                                  response.data[index].totalRating.toString(), // Dynamic rating
                                  style: AppStyle.heading5Medium(
                                      color: AppColor.primaryColor),
                                ).paddingOnly(right: AppSize.appSize6),
                                Icon(Icons.star, color: Colors.amber, size: AppSize.appSize18),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: AppColor.descriptionColor.withOpacity(0.3),
                        height: AppSize.appSize0,
                      ).paddingOnly(top: AppSize.appSize16, bottom: AppSize.appSize16),

                      Row(

                        children: [
                          // Bathroom Container
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSize.appSize6,
                              horizontal: AppSize.appSize14,
                            ),
                            margin:
                            const EdgeInsets.only(right: AppSize.appSize16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSize.appSize12),
                              border: Border.all(
                                color: AppColor.primaryColor,
                                width: AppSize.appSizePoint50,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.bathtub, color: AppColor.primaryColor, size: AppSize.appSize18),
                                SizedBox(width: 6),
                                Text(
                                  response.data[index].totalBathroom,
                                  style: AppStyle.heading5Medium(color: AppColor.textColor),
                                ),
                              ],
                            ),
                          ),

                          // Bedroom Container
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSize.appSize6,
                              horizontal: AppSize.appSize14,
                            ),
                            margin: const EdgeInsets.only(right: AppSize.appSize16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSize.appSize12),
                              border: Border.all(
                                color: AppColor.primaryColor,
                                width: AppSize.appSizePoint50,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.bed, color: AppColor.primaryColor, size: AppSize.appSize18),
                                SizedBox(width: 6),
                                Text(
                                  response.data[index].totalBedroom,
                                  style: AppStyle.heading5Medium(color: AppColor.textColor),
                                ),
                              ],
                            ),
                          ),

                          // BHK Container
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSize.appSize6,
                              horizontal: AppSize.appSize14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSize.appSize12),
                              border: Border.all(
                                color: AppColor.primaryColor,
                                width: AppSize.appSizePoint50,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.bedroom_parent_outlined, color: AppColor.primaryColor, size: AppSize.appSize18),
                                SizedBox(width: 6),
                                Text(
                                  "${response.data[index].totalBedroom} BHK",
                                  style: AppStyle.heading5Medium(color: AppColor.textColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),


                      IntrinsicHeight(
                        child: Row(
                          children: [
                            CommonRichText(
                              segments: [
                                TextSegment(
                                  text:  "${response.data[index].totalArea} sqft",
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor),
                                ),
                                TextSegment(
                                  text: AppString.builtUp,
                                  style: AppStyle.heading7Regular(
                                      color: AppColor.descriptionColor),
                                ),
                              ],
                            ),
                            /*const VerticalDivider(
                              color: AppColor.descriptionColor,
                              width: AppSize.appSize0,
                              indent: AppSize.appSize2,
                              endIndent: AppSize.appSize2,
                            ).paddingOnly(
                                left: AppSize.appSize8,
                                right: AppSize.appSize8),
                            CommonRichText(
                              segments: [
                                TextSegment(
                                  text:  "${response.data[index].totalArea} sqft",
                                  style: AppStyle.heading5Regular(
                                      color: AppColor.textColor),
                                ),
                                TextSegment(
                                  text: AppString.builtUp,
                                  style: AppStyle.heading7Regular(
                                      color: AppColor.descriptionColor),
                                ),
                              ],
                            ),*/
                          ],
                        ).paddingOnly(top: AppSize.appSize10),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: AppSize.appSize35,
                        child: ElevatedButton(
                          onPressed: () {
                            // propertyListController.launchDialer();
                            String agentPhoneNumber = response.data[index].agent.phone; // Get dynamically
                            propertyListController.launchDialer(agentPhoneNumber);
                          },
                          style: ButtonStyle(
                            elevation: WidgetStatePropertyAll(AppSize.appSize0),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSize.appSize12),
                                side: const BorderSide(
                                    color: AppColor.primaryColor,
                                    width: AppSize.appSizePoint7),
                              ),
                            ),
                            backgroundColor: WidgetStateColor.transparent,
                          ),
                          child: Text(
                            AppString.getCallbackButton,
                            style: AppStyle.heading6Regular(
                                color: AppColor.primaryColor),
                          ),
                        ),
                      ).paddingOnly(top: AppSize.appSize26),
                    ],
                  ),
                ),
              );
            },
          ).paddingOnly(top: AppSize.appSize16),

        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16,
        right: AppSize.appSize16,
      ),





    );
  }
}