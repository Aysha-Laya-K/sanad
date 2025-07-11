import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';

class TermsOfUseView extends StatelessWidget {
  const TermsOfUseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildTermsOfUse(),
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
        AppString.termsOfUse,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildTermsOfUse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.privacyPolicyView);
          },
          child: Text(
            AppString.privacyPolicy,
            style: AppStyle.heading5Regular(color: AppColor.textColor),
          ),
        ),

        Divider(
          color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
          thickness: AppSize.appSizePoint7,
          height: AppSize.appSize0,
        ).paddingOnly(top: AppSize.appSize16, bottom: AppSize.appSize26),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.termsconditionsView);
          },
          child: Text(
            AppString.terms2,
            style: AppStyle.heading5Regular(color: AppColor.textColor),
          ),
        ),

        Divider(
          color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
          thickness: AppSize.appSizePoint7,
          height: AppSize.appSize0,
        ).paddingOnly(top: AppSize.appSize16, bottom: AppSize.appSize26),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.aboutUsView);
          },
          child: Text(
            AppString.aboutUs,
            style: AppStyle.heading5Regular(color: AppColor.textColor),
          ),
        ),
        Divider(
          color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
          thickness: AppSize.appSizePoint7,
          height: AppSize.appSize0,
        ).paddingOnly(top: AppSize.appSize16, bottom: AppSize.appSize26),

      ],
    ).paddingOnly(
      top: AppSize.appSize10,
      left: AppSize.appSize16, right: AppSize.appSize16,
    );
  }
}
