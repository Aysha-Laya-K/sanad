import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_rich_text.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/bottom_bar_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/saved_properties_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/text_segment_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/wishlist_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SavedPropertiesView extends StatefulWidget {
  SavedPropertiesView({super.key});

  @override
  State<SavedPropertiesView> createState() => _SavedPropertiesViewState();
}

class _SavedPropertiesViewState extends State<SavedPropertiesView> {
  SavedPropertiesController savedPropertiesController =
  Get.put(SavedPropertiesController());
  RxMap<int, bool> isSavedMap = RxMap<int, bool>();

  @override
  void initState() {
    super.initState();
    // Call the API method to fetch wishlist properties
    savedPropertiesController.fetchWishlist();
  }


  @override
  Widget build(BuildContext context) {
    savedPropertiesController.isSimilarPropertyLiked.value =
    List<bool>.generate(
        savedPropertiesController.searchImageList.length, (index) => false);
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: SingleChildScrollView(  // Wrap the body with SingleChildScrollView
        child: buildSavedPropertyList(),
      ),
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
      title: Text(
        AppString.savedProperties,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(AppSize.appSize40),
      //   child: SizedBox(
      //     height: AppSize.appSize40,
      //     child: Row(
      //       children: List.generate(savedPropertiesController.savedPropertyList.length, (index) {
      //         return Expanded(
      //           child: GestureDetector(
      //             onTap: () {
      //               savedPropertiesController.updateSavedProperty(index);
      //             },
      //             child: Obx(() => Container(
      //               height: AppSize.appSize25,
      //               decoration: BoxDecoration(
      //                 border: Border(
      //                   bottom: BorderSide(
      //                     color: savedPropertiesController.selectSavedProperty.value == index
      //                         ? AppColor.primaryColor
      //                         : AppColor.borderColor,
      //                     width: AppSize.appSize1,
      //                   ),
      //                   right: BorderSide(
      //                     color: index == AppSize.size2
      //                         ? Colors.transparent
      //                         : AppColor.borderColor,
      //                     width: AppSize.appSize1,
      //                   ),
      //                 ),
      //               ),
      //               child: Center(
      //                 child: Text(
      //                   savedPropertiesController.savedPropertyList[index],
      //                   style: AppStyle.heading5Medium(
      //                     color: savedPropertiesController.selectSavedProperty.value == index
      //                         ? AppColor.primaryColor
      //                         : AppColor.textColor,
      //                   ),
      //                 ),
      //               ),
      //             )),
      //           ),
      //         );
      //       }),
      //     ).paddingOnly(
      //       top: AppSize.appSize10,
      //       left: AppSize.appSize16, right: AppSize.appSize16,
      //     ),
      //   ),
      // ),
    );
  }

  Widget buildSavedPropertyList() {
    final token = UserTypeManager.getToken();

    return Obx(() {
      if (token == null ) {
        // Show message if token is not available
        return const Center(
          child: Text(
            "No saved properties",
            textAlign: TextAlign.center,
            // This ensures the text is centered
          ),
        );
      }

      // Check if wishlistResponse is available
      final wishlist = savedPropertiesController.wishlistResponse.value;

      if (wishlist == null || wishlist.properties.data.isEmpty) {
        // Show message if the API data is null or empty
        return const Center(child: Text("No saved properties"));
      }


      // Access the list of properties from the API response.
      final propertyList = wishlist.properties.data;

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: propertyList.length,
        itemBuilder: (context, index) {
          final property = propertyList[index];
          if (!isSavedMap.containsKey(property.id)) {
            isSavedMap[property.id] = false;
          }

          return GestureDetector(
            onTap: () async {
              final int propertyId = property.id;
              print('Tapped on property with ID: $propertyId');
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
                        property.thumbnailImage,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // Image loaded
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                    null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ??
                                        1)
                                    : null,
                              ),
                            ); // Loading indicator while the image loads
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error); // Fallback for errors
                        },
                      ),
                      Positioned(
                        right: AppSize.appSize6,
                        top: AppSize.appSize6,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              isSavedMap[property.id] = !(isSavedMap[property.id] ?? false);
                            });



                            String? token = await UserTypeManager.getToken();

                            if (token != null) {
                              // Make the API call to remove from wishlist
                              final url = Uri.parse(
                                  'https://project.artisans.qa/realestate/api/user/remove-wishlist/${property.id}');

                              final response = await http.delete(
                                url,
                                headers: {
                                  'Authorization': 'Bearer $token',
                                },
                              );

                              if (response.statusCode == 200) {
                                // Successfully removed from wishlist
                                // Handle any success logic here if needed
                                print('Removed from wishlist');
                              } else {
                                // Error handling
                                print('Failed to remove from wishlist: ${response.body}');
                              }
                            } else {
                              print('Token not found');
                            }

                            // Handle bookmark toggle logic
                          },
                          child: Container(
                            width: AppSize.appSize32,
                            height: AppSize.appSize32,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(
                                  AppSize.appSize6),
                            ),
                            child: Icon(
                              isSavedMap[property.id] == true
                                  ? Icons.bookmark_border
                                  : Icons.bookmark,
                              size: AppSize.appSize20,
                              color: isSavedMap[property.id] == true
                                  ? AppColor.primaryColor.withOpacity(0.6)
                                  : AppColor.primaryColor,
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
                          property.title, // Dynamic title
                          style: AppStyle.heading5SemiBold(
                              color: AppColor.textColor),
                        ),
                        Text(
                          property.slug, // Dynamic title
                          style: AppStyle.heading5SemiBold(
                              color: AppColor.textColor),
                        ),
                        Text(
                          property.address, // Dynamic address
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
                          "QAR ${property.price}", // Dynamic price
                          style: AppStyle.heading5Medium(
                              color: AppColor.primaryColor),
                        ),
                        Row(
                          children: [
                            Text(
                              property.totalRating.toString(), // Dynamic rating
                              style: AppStyle.heading5Medium(
                                  color: AppColor.primaryColor),
                            ).paddingOnly(right: AppSize.appSize6),
                            Icon(Icons.star, color: Colors.amber,
                                size: AppSize.appSize18),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColor.descriptionColor.withOpacity(0.3),
                    height: AppSize.appSize0,
                  ).paddingOnly(
                      top: AppSize.appSize16, bottom: AppSize.appSize16),
                  Row(
                    children: [
                      // Bathroom Container
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSize.appSize6,
                          horizontal: AppSize.appSize14,
                        ),
                        margin: const EdgeInsets.only(right: AppSize.appSize16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              AppSize.appSize12),
                          border: Border.all(
                            color: AppColor.primaryColor,
                            width: AppSize.appSizePoint50,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.bathtub, color: AppColor.primaryColor,
                                size: AppSize.appSize18),
                            SizedBox(width: 6),
                            Text(
                              property.totalBathroom,
                              style: AppStyle.heading5Medium(
                                  color: AppColor.textColor),
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
                          borderRadius: BorderRadius.circular(
                              AppSize.appSize12),
                          border: Border.all(
                            color: AppColor.primaryColor,
                            width: AppSize.appSizePoint50,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.bed, color: AppColor.primaryColor,
                                size: AppSize.appSize18),
                            SizedBox(width: 6),
                            Text(
                              property.totalBedroom,
                              style: AppStyle.heading5Medium(
                                  color: AppColor.textColor),
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
                          borderRadius: BorderRadius.circular(
                              AppSize.appSize12),
                          border: Border.all(
                            color: AppColor.primaryColor,
                            width: AppSize.appSizePoint50,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.bedroom_parent_outlined,
                                color: AppColor.primaryColor,
                                size: AppSize.appSize18),
                            SizedBox(width: 6),
                            Text(
                              "${property.totalBedroom} BHK",
                              style: AppStyle.heading5Medium(
                                  color: AppColor.textColor),
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
                              text: "${property.totalArea} sqft",
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
                            left: AppSize.appSize8, right: AppSize.appSize8),
                        CommonRichText(
                          segments: [
                            TextSegment(
                              text: "${property.totalArea} sqft",
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
                ],
              ),
            ),
          );
        },
      ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16);
    });
  }
}