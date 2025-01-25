import 'package:flutter/material.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/bottom_bar_controller.dart';

import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/activity_controller.dart';

import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/activity/service_detail_screen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/activity/widgets/listings_states_bottom_sheet.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/activity/widgets/sort_by_listing_bottom_sheet.dart';

import 'package:luxury_real_estate_flutter_ui_kit/views/home/widget/manage_property_bottom_sheet.dart';

class ServicesList extends StatelessWidget {
  final String serviceName;
  ServicesList({required this.serviceName, super.key});
  ActivityController activityController = Get.put(ActivityController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
          child: Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
            ), // buildAppBar(),
            body: buildActivityView(context),
          ),
        ));
  }

  Widget buildActivityView(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // listingStatesBottomSheet(context);
                },
                child: Row(
                  children: [
                    Text(
                      serviceName,
                      // activityController.deleteShowing.value == true
                      //     ? AppString.deleteListings
                      //     : AppString.yourListing,
                      style:
                          AppStyle.heading3SemiBold(color: AppColor.textColor),
                    ).paddingOnly(right: AppSize.appSize6),
                    // Image.asset(
                    //   Assets.images.dropdown.path,
                    //   width: AppSize.appSize20,
                    // ),
                  ],
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     sortByListingBottomSheet(context);
              //   },
              //   child: Text(
              //     AppString.sortByText,
              //     style: AppStyle.heading5Medium(color: AppColor.primaryColor),
              //   ),
              // )
            ],
          ),
          Container(
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
              controller: activityController.searchListController,
              cursorColor: AppColor.primaryColor,
              style: AppStyle.heading4Regular(color: AppColor.textColor),
              decoration: InputDecoration(
                hintText: AppString.searchServices,
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
          ).paddingOnly(top: AppSize.appSize26),
          activityController.deleteShowing.value == true
              ? ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: AppSize.appSize26),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3, //AppSize.size1,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSize.appSize26),
                      padding: const EdgeInsets.all(AppSize.appSize16),
                      decoration: BoxDecoration(
                        color: AppColor.backgroundColor,
                        borderRadius: BorderRadius.circular(AppSize.appSize12),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.images.listing2.path,
                            width: AppSize.appSize90,
                          ).paddingOnly(right: AppSize.appSize16),
                          Expanded(
                            child: SizedBox(
                              height: AppSize.appSize110,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppString.deleteButton,
                                        style: AppStyle.heading5Medium(
                                            color: AppColor.negativeColor),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    AppString.sellIndependentHouse,
                                    style: AppStyle.heading5SemiBold(
                                        color: AppColor.textColor),
                                  ),
                                  Text(
                                    AppString.roslynWalks,
                                    style: AppStyle.heading5Regular(
                                        color: AppColor.descriptionColor),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      managePropertyBottomSheet(context);
                                    },
                                    child: Text(
                                      AppString.manageProperty,
                                      style: AppStyle.heading5Medium(
                                          color: AppColor.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: AppSize.appSize26),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3, //activityController.propertyListImage.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceDetailScreen(),
                            ));
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(bottom: AppSize.appSize26),
                        padding: const EdgeInsets.all(AppSize.appSize16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF3F6), // AppColor.primaryColor,
                          borderRadius:
                              BorderRadius.circular(AppSize.appSize12),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              activityController.propertyListImage[index],
                              width: AppSize.appSize90,
                            ).paddingOnly(right: AppSize.appSize16),
                            Expanded(
                              child: SizedBox(
                                height: AppSize.appSize110,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Service Provider Name',
                                      // activityController
                                      //     .propertyListTitle[index],
                                      style: AppStyle.serviceName(
                                          color: AppColor.primaryColor),
                                    ),
                                    // Text(
                                    //   activityController
                                    //       .propertyListRupee[index],
                                    //   style: AppStyle.heading5Medium(
                                    //       color: AppColor.textColor),
                                    // ),
                                    Text(
                                      activityController
                                          .propertyListAddress[index],
                                      style: AppStyle.servicePlace(
                                          color: AppColor.primaryColor),
                                    ),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     managePropertyBottomSheet(context);
                                    //   },
                                    //   child: Text(
                                    //     AppString.manageProperty,
                                    //     style: AppStyle.heading5Medium(
                                    //         color: AppColor.primaryColor),
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // WhatsApp Button
                                        IconButton(
                                            onPressed: () {
                                              // Launch WhatsApp with a predefined message
                                              // final whatsappUrl =
                                              //     "whatsapp://send?phone=YOUR_PHONE_NUMBER&text=Hello";
                                              // launchUrl(Uri.parse(whatsappUrl));
                                            },
                                            icon: Image.asset(
                                              Assets.images.whatsapp.path,
                                              width: AppSize.appSize20,
                                              color: AppColor.primaryColor,
                                              // color: Colors.green,
                                            )),

                                        // Call Button
                                        IconButton(
                                          onPressed: () {
                                            // Launch phone dialer
                                            // final phoneUrl = "tel:YOUR_PHONE_NUMBER";
                                            // launchUrl(Uri.parse(phoneUrl));
                                          },
                                          icon: const Icon(
                                            Icons.phone,
                                            color: AppColor.primaryColor,
                                            // color: Colors.blue,
                                            size: 21,
                                          ),
                                        ),

                                        // SMS Button
                                        // IconButton(
                                        //   onPressed: () {
                                        //     // Launch SMS
                                        //     // final smsUrl = "sms:YOUR_PHONE_NUMBER";
                                        //     // launchUrl(Uri.parse(smsUrl));
                                        //   },
                                        //   icon: const Icon(
                                        //     Icons.sms,
                                        //     color: Color(0xFFEFECE4),
                                        //     size: 28,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16,
        right: AppSize.appSize16,
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
            if (activityController.deleteShowing.value == true) {
              activityController.deleteShowing.value = false;
              activityController.selectListing.value = AppSize.size0;
            } else {
              BottomBarController bottomBarController =
                  Get.put(BottomBarController());
              bottomBarController.pageController.jumpToPage(AppSize.size0);
            }
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
    );
  }
}
