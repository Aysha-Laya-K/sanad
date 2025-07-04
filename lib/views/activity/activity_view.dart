import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/activity_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/bottom_bar_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/activity/services_list.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/activity/widgets/listings_states_bottom_sheet.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/activity/widgets/sort_by_listing_bottom_sheet.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/widget/manage_property_bottom_sheet.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/home_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';

class ActivityView extends StatelessWidget {
  ActivityView({super.key});

  ActivityController activityController = Get.put(ActivityController());
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
          child: Scaffold(
            backgroundColor: AppColor.whiteColor,
            //appBar: buildAppBar(),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // listingStatesBottomSheet(context);
                },
                child: Row(
                  children: [
                    Text(
                      activityController.deleteShowing.value == true
                          ? AppString.deleteListings
                          : AppString.yourListing,
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
         /* Container(
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
              readOnly: true,
              onTap: () {
                Get.toNamed(AppRoutes.searchView);


              },
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
          ).paddingOnly(top: AppSize.appSize26),*/
          activityController.deleteShowing.value == true
              ? ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: AppSize.appSize26),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3, //AppSize.size1,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => ServicesList(),
                        //     ));
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(bottom: AppSize.appSize26),
                        padding: const EdgeInsets.all(AppSize.appSize16),
                        decoration: BoxDecoration(
                          color: AppColor.backgroundColor,
                          borderRadius:
                              BorderRadius.circular(AppSize.appSize12),
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
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       AppString.deleteButton,
                                    //       style: AppStyle.heading5Medium(
                                    //           color: AppColor.negativeColor),
                                    //     ),
                                    //   ],
                                    // ),
                                    // Text(
                                    //   AppString.sellIndependentHouse,
                                    //   style: AppStyle.heading5SemiBold(
                                    //       color: AppColor.textColor),
                                    // ),
                                    Text(
                                      AppString.roslynWalks,
                                      style: AppStyle.heading5Regular(
                                          color: AppColor.descriptionColor),
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: AppSize.appSize26),
                  physics: const NeverScrollableScrollPhysics(),
            itemCount: activityController.serviceTypes.length,
            itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        int serviceId = homeController.serviceTypes[index].id;  // Get the service ID

                        print('Service ID: $serviceId');  // Debugging: Print service ID

                        await homeController.fetchServiceList(serviceId);  // Call API with service ID

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicesList(
                              serviceName: homeController.serviceTypes[index].name,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        margin:
                            const EdgeInsets.only(bottom: AppSize.appSize26),
                        padding: const EdgeInsets.all(AppSize.appSize16),
                        decoration: BoxDecoration(
                          color: AppColor
                              .backgroundColor, //Color(0xFFFFF3F6), //AppColor.backgroundColor,
                          borderRadius:
                              BorderRadius.circular(AppSize.appSize12),
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              activityController.serviceTypes[index].image,
                              width: AppSize.appSize78,
                            ).paddingOnly(right: AppSize.appSize16),
                            Expanded(
                              child: SizedBox(
                                height: AppSize.appSize75,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          activityController.serviceTypes[index].name,
                                          style: AppStyle.serviceName(
                                              color: AppColor.primaryColor),
                                          // style: AppStyle.heading5SemiBold(
                                          //     color: AppColor.textColor),
                                        ),
                                        // if (index == AppSize.size1) ...[
                                        //   Text(
                                        //     AppString.deleteButton,
                                        //     style: AppStyle.heading5Medium(
                                        //         color: AppColor.negativeColor),
                                        //   ),
                                        // ],
                                      ],
                                    ),
                                    // Text(
                                    //   activityController
                                    //       .propertyListRupee[index],
                                    //   style: AppStyle.heading5Medium(
                                    //       color: AppColor.textColor),
                                    // ),
                                    // Text(
                                    //   activityController
                                    //       .propertyListAddress[index],
                                    //   style: AppStyle.heading5Regular(
                                    //       color: AppColor.descriptionColor),
                                    // ),
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
