import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';

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
    actions: [
      Row(
        children: [
          // GestureDetector(
          //   onTap: () {
          //     Get.toNamed(AppRoutes.searchView);
          //   },
          //   child: Image.asset(
          //     Assets.images.search.path,
          //     width: AppSize.appSize24,
          //     color: AppColor.descriptionColor,
          //   ).paddingOnly(right: AppSize.appSize26),
          // ),
          GestureDetector(
            onTap: () {
              // Get.back();
              // Get.back();
              // Get.back();
              // Future.delayed(
              //   const Duration(milliseconds: AppSize.size400),
              //   () {
              //     // BottomBarController bottomBarController =
              //     //     Get.put(BottomBarController());
              //     // bottomBarController.pageController.jumpToPage(AppSize.size3);
              //   },
              // );
            },
            child: Image.asset(
              Assets.images.save.path,
              width: AppSize.appSize24,
              color: AppColor.descriptionColor,
            ).paddingOnly(right: AppSize.appSize26),
          ),
          // GestureDetector(
          //   onTap: () {
          //     Share.share(AppString.appName);
          //   },
          //   child: Image.asset(
          //     Assets.images.share.path,
          //     width: AppSize.appSize24,
          //   ),
          // ),
        ],
      ).paddingOnly(right: AppSize.appSize16),
    ],
    // bottom: PreferredSize(
    //   preferredSize: const Size.fromHeight(AppSize.appSize40),
    //   child: SizedBox(
    //     height: AppSize.appSize40,
    //     child: ListView(
    //       scrollDirection: Axis.horizontal,
    //       children: [
    //         Row(
    //           children: List.generate(
    //               propertyDetailsController.propertyList.length, (index) {
    //             return GestureDetector(
    //               onTap: () {
    //                 propertyDetailsController.updateProperty(index);
    //               },
    //               child: Obx(() => Container(
    //                     height: AppSize.appSize25,
    //                     padding: const EdgeInsets.symmetric(
    //                         horizontal: AppSize.appSize14),
    //                     decoration: BoxDecoration(
    //                       border: Border(
    //                         bottom: BorderSide(
    //                           color: propertyDetailsController
    //                                       .selectProperty.value ==
    //                                   index
    //                               ? AppColor.primaryColor
    //                               : AppColor.borderColor,
    //                           width: AppSize.appSize1,
    //                         ),
    //                         right: BorderSide(
    //                           color: index == AppSize.size6
    //                               ? Colors.transparent
    //                               : AppColor.borderColor,
    //                           width: AppSize.appSize1,
    //                         ),
    //                       ),
    //                     ),
    //                     child: Center(
    //                       child: Text(
    //                         propertyDetailsController.propertyList[index],
    //                         style: AppStyle.heading5Medium(
    //                           color: propertyDetailsController
    //                                       .selectProperty.value ==
    //                                   index
    //                               ? AppColor.primaryColor
    //                               : AppColor.textColor,
    //                         ),
    //                       ),
    //                     ),
    //                   )),
    //             );
    //           }),
    //         ).paddingOnly(
    //           top: AppSize.appSize10,
    //           left: AppSize.appSize16,
    //           right: AppSize.appSize16,
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
  );
}
