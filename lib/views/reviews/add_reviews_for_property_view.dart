import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_button.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/add_reviews_for_property_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';

class AddReviewsForPropertyView extends StatelessWidget {
  AddReviewsForPropertyView({super.key});

  AddReviewsForPropertyController addReviewsForPropertyController = Get.put(AddReviewsForPropertyController());
  final int propertyId = Get.arguments ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildAddReviewsForPropertyFields(),
      bottomNavigationBar: buildButton(context),
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
            Get.back(result: propertyId);
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      title: Text(
        AppString.addReview,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildAddReviewsForPropertyFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Container(
          padding: const EdgeInsets.all(AppSize.appSize16),
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(AppSize.appSize16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColor.backgroundColor,
                backgroundImage: AssetImage(Assets.images.searchProperty1.path),
                radius: AppSize.appSize22,
              ).paddingOnly(right: AppSize.appSize8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.semiModernHouse,
                      style: AppStyle.heading4Medium(color: AppColor.textColor),
                    ),
                    Text(
                      AppString.address6,
                      style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
                    ).paddingOnly(top: AppSize.appSize4),
                  ],
                ),
              ),
            ],
          ),
        ),*/
        /*Obx(() => RatingBar(
          initialRating: addReviewsForPropertyController.rating.value,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: Image.asset(Assets.images.ratingStar.path),
            half: Image.asset(Assets.images.ratingStar.path),
            empty: Image.asset(Assets.images.emptyRatingStar.path),
          ),
          glow: false,
          itemSize: AppSize.appSize30,
          itemPadding: const EdgeInsets.only(right: AppSize.appSize16),
          onRatingUpdate: (rating) {
            addReviewsForPropertyController.updateRating(rating);
          },
        ))*/


        Obx(() => RatingBar(
          initialRating: addReviewsForPropertyController.rating.value,
          direction: Axis.horizontal,
          allowHalfRating: false,  // Disable half ratings
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: Icon(
              Icons.star,
              color: Color(0xFFFFA500),  // Static orange-yellow color for full star
              size: AppSize.appSize30,
            ),
            half: Icon(
              Icons.star_border,  // Dummy icon to satisfy the half parameter
              color: Colors.transparent,  // Transparent color, as half rating is not used
              size: AppSize.appSize30,
            ),
            empty: Icon(
              Icons.star_border,
              color: Color(0xFFFFA500),  // Grey color for empty star
              size: AppSize.appSize30,
            ),
          ),
          glow: false,
          itemSize: AppSize.appSize30,
          itemPadding: const EdgeInsets.only(right: AppSize.appSize16),
          onRatingUpdate: (rating) {
            addReviewsForPropertyController.updateRating(rating);
          },
        ))


            .paddingOnly(top: AppSize.appSize26),
        TextFormField(
          controller: addReviewsForPropertyController.writeAReviewController,
          cursorColor: AppColor.primaryColor,
          style: AppStyle.heading4Regular(color: AppColor.textColor),
          maxLines: AppSize.size3,
          decoration: InputDecoration(
            hintText: AppString.writeAReviews,
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
        ).paddingOnly(top: AppSize.appSize26),
      ],
    ).paddingOnly(
      top: AppSize.appSize10,
      left: AppSize.appSize16,
      right: AppSize.appSize16,
    );
  }

  Widget buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CommonButton(
        onPressed: () {
          //Get.back(result: propertyId);
          addReviewsForPropertyController.submitReview(propertyId);
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
