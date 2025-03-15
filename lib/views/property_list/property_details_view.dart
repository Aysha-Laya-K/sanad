import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_button.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_rich_text.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_textfield.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/bottom_bar_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/owner_country_picker_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/property_details_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/text_segment_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/widget/owner_country_picker_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/propertydetails_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/enquiryform.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/reviews/add_reviews_for_property_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'package:html/parser.dart' as html;
import 'package:html_unescape/html_unescape.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/home_controller.dart';


class PropertyDetailsView extends StatefulWidget {
  PropertyDetailsView({super.key});

  @override
  State<PropertyDetailsView> createState() => _PropertyDetailsViewState();
}

class _PropertyDetailsViewState extends State<PropertyDetailsView> {
  HomeController homeController = Get.put(HomeController());


  final PageController _pageController = PageController();
  RxMap<int, bool> isSavedMap = RxMap<int, bool>();
  late PropertyDetailsController propertyDetailsController;


 /* PropertyDetailsController propertyDetailsController =
      Get.put(PropertyDetailsController());*/

  OwnerCountryPickerController ownerCountryPickerController =
      Get.put(OwnerCountryPickerController());
  late int propertyId;

  String cleanDescription(String htmlString) {
    // Decode HTML entities multiple times
    HtmlUnescape unescape = HtmlUnescape();
    String decodedString = unescape.convert(htmlString);
    decodedString = unescape.convert(decodedString); // Double decoding

    // Parse the decoded HTML string and extract text content
    final document = html.parse(decodedString);
    String parsedString = document.body?.text ?? '';

    // Ensure no HTML tags remain
    parsedString = parsedString.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove extra spaces, new lines, and trim
    parsedString = parsedString.replaceAll(RegExp(r'\s+'), ' ').trim();

    return parsedString;
  }

 /* @override
  void initState() {
    super.initState();
    propertyId = Get.arguments as int;
    propertyDetailsController.fetchPropertyDetails(propertyId);
    print('Current Route: ${Get.routing.current}');

  }*/

  @override
  void initState() {
    super.initState();
    propertyId = Get.arguments as int;

    // Always create a new controller for this screen
    propertyDetailsController =
        Get.put(PropertyDetailsController(), tag: 'property_$propertyId');

    // Fetch the property details
    propertyDetailsController.fetchPropertyDetails(propertyId);

    print('Current Route: ${Get.routing.current}');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: Obx(() {
        final propertyDetails = propertyDetailsController.propertyDetails.value;

        if (propertyDetails == null || propertyDetailsController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return buildPropertyDetails(context, propertyDetails, propertyId);
      }),
      bottomNavigationBar: Obx(() {
        final propertyDetails = propertyDetailsController.propertyDetails.value;
        return propertyDetails != null ? buildButton(context, propertyDetails) : SizedBox();
      }),
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
           // Navigator.pop(context);
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      actions: [
       /* Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.searchView);
              },
              child: Image.asset(
                Assets.images.search.path,
                width: AppSize.appSize24,
                color: AppColor.descriptionColor,
              ).paddingOnly(right: AppSize.appSize26),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
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
        ).paddingOnly(right: AppSize.appSize16),*/
      ],

    );
  }

  Widget buildPropertyDetails(BuildContext context, propertyDetails,propertyId) {
    final additionalInformationsWithYes = propertyDetails?.additionalInformations
        ?.where((info) => info.addValue?.toLowerCase() == "yes")
        .toList() ?? [];
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSize.appSize30),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          propertyDetails?.sliders?.isNotEmpty == true
              ? Stack(
            children: [
              // **PageView for Image Swiping**
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: propertyDetails?.sliders?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(propertyDetails?.sliders?[index].image ?? ''),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // **Page Indicator**
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: propertyDetails?.sliders?.length ?? 0,
                    effect: ExpandingDotsEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                      expansionFactor: 3.0,
                      spacing: 4.0,
                      activeDotColor: Colors.orange,
                      dotColor: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          )
              : Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage("assets/images/modern_house.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),

          Text(
            'QAR ${propertyDetails?.property?.price}',
            style: AppStyle.heading4Medium(color: AppColor.primaryColor),
          ).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          IntrinsicHeight(
            child: Row(
              children: [
               /* Text(
                  AppString.readyToMove,
                  style: AppStyle.heading6Regular(
                      color: AppColor.descriptionColor),
                ),
                VerticalDivider(
                  color: AppColor.descriptionColor
                      .withOpacity(AppSize.appSizePoint4),
                  thickness: AppSize.appSizePoint7,
                  width: AppSize.appSize22,
                  indent: AppSize.appSize2,
                  endIndent: AppSize.appSize2,
                ),*/
                Text(
               propertyDetails?.property?.furnish,
                  style: AppStyle.heading6Regular(
                      color: AppColor.descriptionColor),
                ),
              ],
            ),
          ).paddingOnly(
            top: AppSize.appSize8,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Text(
            '${propertyDetails?.property?.title}',
            style: AppStyle.heading5SemiBold(color: AppColor.textColor),
          ).paddingOnly(
            top: AppSize.appSize8,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Text(
            '${propertyDetails?.property?.address}',
            style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          ).paddingOnly(
            top: AppSize.appSize4,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Divider(
            color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
            thickness: AppSize.appSizePoint7,
            height: AppSize.appSize0,
          ).paddingOnly(
            top: AppSize.appSize16,
            bottom: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (propertyDetails?.property?.totalBedroom != null)
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
                        Icon(
                          Icons.bed, // Replace with your icon
                          size: AppSize.appSize18,
                          color: AppColor.primaryColor,
                        ).paddingOnly(right: AppSize.appSize6),
                        Text(
                          '${propertyDetails?.property?.totalBedroom}', // Replace with your static text
                          style: AppStyle.heading5Medium(color: AppColor.textColor),
                        ),
                      ],
                    ),
                  ),

                  if (propertyDetails?.property?.totalBathroom != null)
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
                        Icon(
                          Icons.bathtub, // Replace with your icon
                          size: AppSize.appSize18,
                          color: AppColor.primaryColor,
                        ).paddingOnly(right: AppSize.appSize6),
                        Text(
                          '${propertyDetails?.property?.totalBathroom}', // Replace with your static text
                          style: AppStyle.heading5Medium(color: AppColor.textColor),
                        ),
                      ],
                    ),
                  ),
                  if (propertyDetails?.property?.totalBedroom != null)
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
                        Icon(
                          Icons.bedroom_parent, // Replace with your icon
                          size: AppSize.appSize18,
                          color: AppColor.primaryColor,
                        ).paddingOnly(right: AppSize.appSize6),
                        Text(
                          '${propertyDetails?.property?.totalBedroom} BHK', // Replace with your static text
                          style: AppStyle.heading5Medium(color: AppColor.textColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (propertyDetails?.property?.totalArea != null) // The "sq/m" container placed below the first row
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSize.appSize6,
                  horizontal: AppSize.appSize14,
                ),
                margin: const EdgeInsets.only(top: AppSize.appSize16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  border: Border.all(
                    color: AppColor.primaryColor,
                    width: AppSize.appSizePoint50,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Makes the Row take only the required space
                  children: [
                    Icon(
                      Icons.area_chart_rounded, // Replace with your icon
                      size: AppSize.appSize18,
                      color: AppColor.primaryColor,
                    ).paddingOnly(right: AppSize.appSize6),
                    Text(
                      '${propertyDetails?.property?.totalArea} sq/m', // Replace with your static text
                      style: AppStyle.heading5Medium(color: AppColor.textColor),
                    ),
                  ],
                ),
              )

            ],
          )


              .paddingOnly(
            top: AppSize.appSize10,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),


          if (propertyDetails?.aminities?.isNotEmpty ?? false)
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(AppSize.appSize16),
            margin: const EdgeInsets.only(
              top: AppSize.appSize36,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(AppSize.appSize12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.keyHighlights,
                  style: AppStyle.heading4SemiBold(color: AppColor.whiteColor),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    propertyDetails?.aminities?.length ?? 0,
                        (index) {
                      final aminity = propertyDetails?.aminities?[index].aminity;
                      return Row(
                        children: [
                          Container(
                            width: AppSize.appSize5,
                            height: AppSize.appSize5,
                            margin: const EdgeInsets.only(left: AppSize.appSize10),
                            decoration: const BoxDecoration(
                              color: AppColor.whiteColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            propertyDetails?.aminities?[index]?.aminity?.aminity ?? '', // Handle the case where aminity is null
                            style: AppStyle.heading5Regular(color: AppColor.whiteColor),
                          ).paddingOnly(left: AppSize.appSize10),
                        ],
                      ).paddingOnly(top: AppSize.appSize10);
                    },
                  ),
                ).paddingOnly(top: AppSize.appSize6),
              ],
            ),
          ),
          if (propertyDetails?.property?.totalBedroom != null ||
              propertyDetails?.property?.purpose != null ||
              propertyDetails?.property?.rentPeriod != null ||
              propertyDetails?.property?.totalArea != null ||
              propertyDetails?.property?.totalUnit != null)
            Container(
              margin: const EdgeInsets.only(
                top: AppSize.appSize36,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                color: AppColor.secondaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.propertyDetails,
                    style: AppStyle.heading4Medium(color: AppColor.textColor),
                  ),
                  Column(
                    children: [
                      if (propertyDetails?.property?.totalBedroom != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Layout', // Static text here
                                    style: AppStyle.heading5Regular(
                                        color: AppColor.descriptionColor),
                                  ).paddingOnly(right: AppSize.appSize10),
                                ),
                                Expanded(
                                  child: Text(
                                    '${propertyDetails?.property?.totalBedroom} BHK', // Dynamic text here
                                    style: AppStyle.heading5Regular(color: AppColor.textColor),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: AppColor.descriptionColor
                                  .withOpacity(AppSize.appSizePoint4),
                              thickness: AppSize.appSizePoint7,
                              height: AppSize.appSize0,
                            ).paddingOnly(
                                top: AppSize.appSize16, bottom: AppSize.appSize16),
                          ],
                        ),

                      if (propertyDetails?.property?.purpose != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Purpose', // Static text here
                                    style: AppStyle.heading5Regular(
                                        color: AppColor.descriptionColor),
                                  ).paddingOnly(right: AppSize.appSize10),
                                ),
                                Expanded(
                                  child: Text(
                                    '${propertyDetails?.property?.purpose}', // Dynamic text here
                                    style: AppStyle.heading5Regular(color: AppColor.textColor),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: AppColor.descriptionColor
                                  .withOpacity(AppSize.appSizePoint4),
                              thickness: AppSize.appSizePoint7,
                              height: AppSize.appSize0,
                            ).paddingOnly(
                                top: AppSize.appSize16, bottom: AppSize.appSize16),
                          ],
                        ),

                      if (propertyDetails?.property?.rentPeriod != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Period', // Static text here
                                    style: AppStyle.heading5Regular(
                                        color: AppColor.descriptionColor),
                                  ).paddingOnly(right: AppSize.appSize10),
                                ),
                                Expanded(
                                  child: Text(
                                    '${propertyDetails?.property?.rentPeriod}', // Dynamic text here
                                    style: AppStyle.heading5Regular(color: AppColor.textColor),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: AppColor.descriptionColor
                                  .withOpacity(AppSize.appSizePoint4),
                              thickness: AppSize.appSizePoint7,
                              height: AppSize.appSize0,
                            ).paddingOnly(
                                top: AppSize.appSize16, bottom: AppSize.appSize16),
                          ],
                        ),

                      if (propertyDetails?.property?.totalArea != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total Area', // Static text here
                                    style: AppStyle.heading5Regular(
                                        color: AppColor.descriptionColor),
                                  ).paddingOnly(right: AppSize.appSize10),
                                ),
                                Expanded(
                                  child: Text(
                                    '${propertyDetails?.property?.totalArea} sq/m', // Dynamic text here
                                    style: AppStyle.heading5Regular(color: AppColor.textColor),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: AppColor.descriptionColor
                                  .withOpacity(AppSize.appSizePoint4),
                              thickness: AppSize.appSizePoint7,
                              height: AppSize.appSize0,
                            ).paddingOnly(
                                top: AppSize.appSize16, bottom: AppSize.appSize16),
                          ],
                        ),

                      if (propertyDetails?.property?.totalUnit != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total Unit', // Static text here
                                    style: AppStyle.heading5Regular(
                                        color: AppColor.descriptionColor),
                                  ).paddingOnly(right: AppSize.appSize10),
                                ),
                                Expanded(
                                  child: Text(
                                    '${propertyDetails?.property?.totalUnit}', // Dynamic text here
                                    style: AppStyle.heading5Regular(color: AppColor.textColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ).paddingOnly(top: AppSize.appSize16),
                ],
              ).paddingOnly(
                left: AppSize.appSize16,
                right: AppSize.appSize16,
                top: AppSize.appSize16,
                bottom: AppSize.appSize16,
              ),
            ),


          /*Container(
            margin: const EdgeInsets.only(
              top: AppSize.appSize36,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.appSize12),
              color: AppColor.secondaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.propertyDetails,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ),
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Layout', // Static text here
                                style: AppStyle.heading5Regular(
                                    color: AppColor.descriptionColor),
                              ).paddingOnly(right: AppSize.appSize10),
                            ),
                            Expanded(
                              child: Text(
                                '${propertyDetails?.property?.totalBedroom} BHK',// Static text here
                                style: AppStyle.heading5Regular(color: AppColor.textColor),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: AppColor.descriptionColor
                              .withOpacity(AppSize.appSizePoint4),
                          thickness: AppSize.appSizePoint7,
                          height: AppSize.appSize0,
                        ).paddingOnly(
                            top: AppSize.appSize16, bottom: AppSize.appSize16),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Purpose', // Static text here
                                style: AppStyle.heading5Regular(
                                    color: AppColor.descriptionColor),
                              ).paddingOnly(right: AppSize.appSize10),
                            ),
                            Expanded(
                              child: Text(
                                '${propertyDetails?.property?.purpose}', // Static text here
                                style: AppStyle.heading5Regular(color: AppColor.textColor),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: AppColor.descriptionColor
                              .withOpacity(AppSize.appSizePoint4),
                          thickness: AppSize.appSizePoint7,
                          height: AppSize.appSize0,
                        ).paddingOnly(
                            top: AppSize.appSize16, bottom: AppSize.appSize16),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Period', // Static text here
                                style: AppStyle.heading5Regular(
                                    color: AppColor.descriptionColor),
                              ).paddingOnly(right: AppSize.appSize10),
                            ),
                            Expanded(
                              child: Text(
                                '${propertyDetails?.property?.rentPeriod}', // Static text here
                                style: AppStyle.heading5Regular(color: AppColor.textColor),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: AppColor.descriptionColor
                              .withOpacity(AppSize.appSizePoint4),
                          thickness: AppSize.appSizePoint7,
                          height: AppSize.appSize0,
                        ).paddingOnly(
                            top: AppSize.appSize16, bottom: AppSize.appSize16),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Total Area', // Static text here
                                style: AppStyle.heading5Regular(
                                    color: AppColor.descriptionColor),
                              ).paddingOnly(right: AppSize.appSize10),
                            ),
                            Expanded(
                              child: Text(
                                '${propertyDetails?.property?.totalArea} sq/m',// Static text here
                                style: AppStyle.heading5Regular(color: AppColor.textColor),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: AppColor.descriptionColor
                              .withOpacity(AppSize.appSizePoint4),
                          thickness: AppSize.appSizePoint7,
                          height: AppSize.appSize0,
                        ).paddingOnly(
                            top: AppSize.appSize16, bottom: AppSize.appSize16),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Total Unit', // Static text here
                                style: AppStyle.heading5Regular(
                                    color: AppColor.descriptionColor),
                              ).paddingOnly(right: AppSize.appSize10),
                            ),
                            Expanded(
                              child: Text(
                                '${propertyDetails?.property?.totalUnit}', // Static text here
                                style: AppStyle.heading5Regular(color: AppColor.textColor),
                              ),
                            ),
                          ],
                        ),




                      ],
                    ),


                    // Add more static text pairs as needed
                  ],
                ).paddingOnly(top: AppSize.appSize16),
              ],
            ).paddingOnly(
              left: AppSize.appSize16,
              right: AppSize.appSize16,
              top: AppSize.appSize16,
              bottom: AppSize.appSize16,
            ),
          ),*/


         /* Text(
            AppString.facilities,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(
            top: AppSize.appSize36,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          SizedBox(
            height: AppSize.appSize110,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: AppSize.appSize16),
              itemCount: additionalInformationsWithYes.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: AppSize.appSize16),
                  padding: const EdgeInsets.only(
                    left: AppSize.appSize16,
                    right: AppSize.appSize16,
                    top: AppSize.appSize16,
                    bottom: AppSize.appSize16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(AppSize.appSize12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     /* Image.asset(
                        propertyDetailsController.facilitiesImageList[index],
                        width: AppSize.appSize40,
                      ),*/

                      Icon(
                        Icons.add_business_rounded, // Change this to any suitable common icon
                        size: AppSize.appSize40,
                        color: AppColor.primaryColor, // Adjust color if needed
                      ),
                      Text(
                        additionalInformationsWithYes[index].addKey ?? '',
                        style:
                            AppStyle.heading5Regular(color: AppColor.textColor),
                      ),
                    ],
                  ),
                );
              },
            ),
          ).paddingOnly(top: AppSize.appSize16),*/



          if (additionalInformationsWithYes.isNotEmpty) // Check if the list is not empty
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppString.facilities,
                  style: AppStyle.heading4Medium(color: AppColor.textColor),
                ).paddingOnly(
                  top: AppSize.appSize36,
                  left: AppSize.appSize16,
                  right: AppSize.appSize16,
                ),
                SizedBox(
                  height: AppSize.appSize110,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: AppSize.appSize16),
                    itemCount: additionalInformationsWithYes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: AppSize.appSize16),
                        padding: const EdgeInsets.only(
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                          top: AppSize.appSize16,
                          bottom: AppSize.appSize16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: BorderRadius.circular(AppSize.appSize12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.add_business_rounded, // Change this to any suitable common icon
                              size: AppSize.appSize40,
                              color: AppColor.primaryColor, // Adjust color if needed
                            ),
                            Text(
                              additionalInformationsWithYes[index].addKey ?? '',
                              style: AppStyle.heading5Regular(color: AppColor.textColor),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ).paddingOnly(top: AppSize.appSize16),
              ],
            ),



          Text(
            AppString.aboutProperty,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(
            top: AppSize.appSize36,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Container(
            padding: const EdgeInsets.all(AppSize.appSize10),
            margin: const EdgeInsets.only(
              top: AppSize.appSize16,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.descriptionColor
                    .withOpacity(AppSize.appSizePoint50),
              ),
              borderRadius: BorderRadius.circular(AppSize.appSize12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  propertyDetails?.property?.furnish,
                  style: AppStyle.heading5SemiBold(color: AppColor.textColor),
                ).paddingOnly(bottom: AppSize.appSize8),
                Row(
                  children: [
                    Image.asset(
                      Assets.images.locationPin.path,
                      width: AppSize.appSize18,
                    ).paddingOnly(right: AppSize.appSize6),
                    Expanded(
                      child: Text(
                        propertyDetails?.property?.address,
                        style: AppStyle.heading5Regular(
                            color: AppColor.descriptionColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint4),
            thickness: AppSize.appSizePoint7,
            height: AppSize.appSize0,
          ).paddingOnly(
            left: AppSize.appSize16,
            right: AppSize.appSize16,
            top: AppSize.appSize16,
            bottom: AppSize.appSize16,
          ),
          CommonRichText(
            segments: [
              TextSegment(


                text: cleanDescription(propertyDetails?.property?.description ?? ''),
                style:
                    AppStyle.heading5Regular(color: AppColor.descriptionColor),
              ),
              TextSegment(
                text: AppString.readMore,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.aboutPropertyView,
                    arguments: {
                      'furnish': propertyDetails?.property?.furnish,
                      'address': propertyDetails?.property?.address,
                      'description': propertyDetails?.property?.description,
                      "phone": propertyDetails?.propertyAgent?.phone,
                    },
                  );

                },
                style: AppStyle.heading5Regular(color: AppColor.primaryColor),
              ),
            ],
          ).paddingOnly(
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       AppString.propertyVisitTime,
          //       style: AppStyle.heading4Medium(color: AppColor.textColor),
          //     ),
          //     Text(
          //       AppString.openNow,
          //       style: AppStyle.heading5Medium(color: AppColor.positiveColor),
          //     ),
          //   ],
          // ).paddingOnly(
          //   top: AppSize.appSize36,
          //   left: AppSize.appSize16,
          //   right: AppSize.appSize16,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     propertyDetailsController.toggleVisitExpansion();
          //   },
          //   child: Obx(() => Container(
          //         padding: const EdgeInsets.all(AppSize.appSize16),
          //         margin: const EdgeInsets.only(
          //           top: AppSize.appSize16,
          //           left: AppSize.appSize16,
          //           right: AppSize.appSize16,
          //         ),
          //         decoration: BoxDecoration(
          //           border: Border.all(
          //             color: AppColor.descriptionColor
          //                 .withOpacity(AppSize.appSizePoint50),
          //           ),
          //           borderRadius: BorderRadius.circular(AppSize.appSize12),
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               AppString.monday,
          //               style: AppStyle.heading4Regular(
          //                   color: AppColor.descriptionColor),
          //             ),
          //             Image.asset(
          //               propertyDetailsController.isVisitExpanded.value
          //                   ? Assets.images.dropdownExpand.path
          //                   : Assets.images.dropdown.path,
          //               width: AppSize.appSize18,
          //             ),
          //           ],
          //         ),
          //       )),
          // ),
          // Obx(() => AnimatedContainer(
          //       duration: const Duration(seconds: AppSize.size1),
          //       curve: Curves.fastEaseInToSlowEaseOut,
          //       margin: EdgeInsets.only(
          //         top: propertyDetailsController.isVisitExpanded.value
          //             ? AppSize.appSize16
          //             : AppSize.appSize0,
          //       ),
          //       height: propertyDetailsController.isVisitExpanded.value
          //           ? null
          //           : AppSize.appSize0,
          //       child: propertyDetailsController.isVisitExpanded.value
          //           ? GestureDetector(
          //               onTap: () {
          //                 propertyDetailsController.toggleVisitExpansion();
          //               },
          //               child: Container(
          //                 margin: const EdgeInsets.only(
          //                   left: AppSize.appSize16,
          //                   right: AppSize.appSize16,
          //                 ),
          //                 padding: const EdgeInsets.only(
          //                   left: AppSize.appSize16,
          //                   right: AppSize.appSize16,
          //                   top: AppSize.appSize16,
          //                   bottom: AppSize.appSize6,
          //                 ),
          //                 decoration: BoxDecoration(
          //                   borderRadius:
          //                       BorderRadius.circular(AppSize.appSize12),
          //                   color: AppColor.whiteColor,
          //                   boxShadow: const [
          //                     BoxShadow(
          //                       color: Colors.black12,
          //                       spreadRadius: AppSize.appSizePoint1,
          //                       blurRadius: AppSize.appSize2,
          //                     ),
          //                   ],
          //                 ),
          //                 child: Column(
          //                   children: List.generate(
          //                       propertyDetailsController.dayList.length,
          //                       (index) {
          //                     return Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text(
          //                           propertyDetailsController.dayList[index],
          //                           style: AppStyle.heading5Regular(
          //                               color: AppColor.descriptionColor),
          //                         ),
          //                         Text(
          //                           propertyDetailsController.timingList[index],
          //                           style: AppStyle.heading5Regular(
          //                               color: AppColor.textColor),
          //                         ),
          //                       ],
          //                     ).paddingOnly(bottom: AppSize.appSize10);
          //                   }),
          //                 ),
          //               ),
          //             )
          //           : const SizedBox.shrink(),
          //     )),
          // Text(
          //   AppString.contactToOwner,
          //   style: AppStyle.heading4Medium(color: AppColor.textColor),
          // ).paddingOnly(
          //   top: AppSize.appSize36,
          //   left: AppSize.appSize16,
          //   right: AppSize.appSize16,
          // ),
          // Container(
          //   padding: const EdgeInsets.all(AppSize.appSize10),
          //   margin: const EdgeInsets.only(
          //     top: AppSize.appSize16,
          //     left: AppSize.appSize16,
          //     right: AppSize.appSize16,
          //   ),
          //   decoration: BoxDecoration(
          //     color: AppColor.secondaryColor,
          //     borderRadius: BorderRadius.circular(AppSize.appSize12),
          //   ),
          //   child: Row(
          //     children: [
          //       Image.asset(
          //         Assets.images.response1.path,
          //         width: AppSize.appSize64,
          //         height: AppSize.appSize64,
          //       ).paddingOnly(right: AppSize.appSize12),
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               AppString.rudraProperties,
          //               style:
          //                   AppStyle.heading4Medium(color: AppColor.textColor),
          //             ).paddingOnly(bottom: AppSize.appSize4),
          //             IntrinsicHeight(
          //               child: Row(
          //                 children: [
          //                   Text(
          //                     AppString.broker,
          //                     style: AppStyle.heading5Medium(
          //                         color: AppColor.descriptionColor),
          //                   ),
          //                   VerticalDivider(
          //                     color: AppColor.descriptionColor
          //                         .withOpacity(AppSize.appSizePoint4),
          //                     thickness: AppSize.appSizePoint7,
          //                     width: AppSize.appSize20,
          //                     indent: AppSize.appSize2,
          //                     endIndent: AppSize.appSize2,
          //                   ),
          //                   Text(
          //                     AppString.brokerNumber,
          //                     style: AppStyle.heading5Medium(
          //                         color: AppColor.descriptionColor),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Obx(() => CommonTextField(
          //       controller: propertyDetailsController.fullNameController,
          //       focusNode: propertyDetailsController.focusNode,
          //       hasFocus: propertyDetailsController.hasFullNameFocus.value,
          //       hasInput: propertyDetailsController.hasFullNameInput.value,
          //       hintText: AppString.fullName,
          //       labelText: AppString.fullName,
          //     )).paddingOnly(
          //   top: AppSize.appSize16,
          //   left: AppSize.appSize16,
          //   right: AppSize.appSize16,
          // ),
          // Obx(() => Container(
          //       padding: EdgeInsets.only(
          //         top: propertyDetailsController.hasPhoneNumberFocus.value ||
          //                 propertyDetailsController.hasPhoneNumberInput.value
          //             ? AppSize.appSize6
          //             : AppSize.appSize14,
          //         bottom: propertyDetailsController.hasPhoneNumberFocus.value ||
          //                 propertyDetailsController.hasPhoneNumberInput.value
          //             ? AppSize.appSize8
          //             : AppSize.appSize14,
          //         left: propertyDetailsController.hasPhoneNumberFocus.value
          //             ? AppSize.appSize0
          //             : AppSize.appSize16,
          //       ),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(AppSize.appSize12),
          //         border: Border.all(
          //           color: propertyDetailsController
          //                       .hasPhoneNumberFocus.value ||
          //                   propertyDetailsController.hasPhoneNumberInput.value
          //               ? AppColor.primaryColor
          //               : AppColor.descriptionColor,
          //         ),
          //       ),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           propertyDetailsController.hasPhoneNumberFocus.value ||
          //                   propertyDetailsController.hasPhoneNumberInput.value
          //               ? Text(
          //                   AppString.phoneNumber,
          //                   style: AppStyle.heading6Regular(
          //                       color: AppColor.primaryColor),
          //                 ).paddingOnly(
          //                   left: propertyDetailsController
          //                           .hasPhoneNumberInput.value
          //                       ? (propertyDetailsController
          //                               .hasPhoneNumberFocus.value
          //                           ? AppSize.appSize16
          //                           : AppSize.appSize0)
          //                       : AppSize.appSize16,
          //                   bottom: propertyDetailsController
          //                           .hasPhoneNumberInput.value
          //                       ? AppSize.appSize2
          //                       : AppSize.appSize2,
          //                 )
          //               : const SizedBox.shrink(),
          //           Row(
          //             children: [
          //               propertyDetailsController.hasPhoneNumberFocus.value ||
          //                       propertyDetailsController
          //                           .hasPhoneNumberInput.value
          //                   ? SizedBox(
          //                       // width: AppSize.appSize78,
          //                       child: IntrinsicHeight(
          //                         child: GestureDetector(
          //                           onTap: () {
          //                             ownerCountryPickerBottomSheet(context);
          //                           },
          //                           child: Row(
          //                             children: [
          //                               Obx(() {
          //                                 final selectedCountryIndex =
          //                                     ownerCountryPickerController
          //                                         .selectedIndex.value;
          //                                 return Text(
          //                                   ownerCountryPickerController
          //                                                   .countries[
          //                                               selectedCountryIndex]
          //                                           [AppString.codeText] ??
          //                                       '',
          //                                   style: AppStyle.heading4Regular(
          //                                       color: AppColor.primaryColor),
          //                                 );
          //                               }),
          //                               Image.asset(
          //                                 Assets.images.dropdown.path,
          //                                 width: AppSize.appSize16,
          //                               ).paddingOnly(
          //                                   left: AppSize.appSize8,
          //                                   right: AppSize.appSize3),
          //                               const VerticalDivider(
          //                                 color: AppColor.primaryColor,
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                     ).paddingOnly(
          //                       left: propertyDetailsController
          //                               .hasPhoneNumberInput.value
          //                           ? (propertyDetailsController
          //                                   .hasPhoneNumberFocus.value
          //                               ? AppSize.appSize16
          //                               : AppSize.appSize0)
          //                           : AppSize.appSize16,
          //                     )
          //                   : const SizedBox.shrink(),
          //               Expanded(
          //                 child: SizedBox(
          //                   height: AppSize.appSize27,
          //                   width: double.infinity,
          //                   child: TextFormField(
          //                     focusNode: propertyDetailsController
          //                         .phoneNumberFocusNode,
          //                     controller: propertyDetailsController
          //                         .mobileNumberController,
          //                     cursorColor: AppColor.primaryColor,
          //                     keyboardType: TextInputType.phone,
          //                     style: AppStyle.heading4Regular(
          //                         color: AppColor.textColor),
          //                     inputFormatters: [
          //                       LengthLimitingTextInputFormatter(
          //                           AppSize.size10),
          //                     ],
          //                     decoration: InputDecoration(
          //                       contentPadding: const EdgeInsets.symmetric(
          //                         horizontal: AppSize.appSize0,
          //                         vertical: AppSize.appSize0,
          //                       ),
          //                       isDense: true,
          //                       hintText: propertyDetailsController
          //                               .hasPhoneNumberFocus.value
          //                           ? ''
          //                           : AppString.phoneNumber,
          //                       hintStyle: AppStyle.heading4Regular(
          //                           color: AppColor.descriptionColor),
          //                       border: OutlineInputBorder(
          //                         borderRadius:
          //                             BorderRadius.circular(AppSize.appSize12),
          //                         borderSide: BorderSide.none,
          //                       ),
          //                       enabledBorder: OutlineInputBorder(
          //                         borderRadius:
          //                             BorderRadius.circular(AppSize.appSize12),
          //                         borderSide: BorderSide.none,
          //                       ),
          //                       focusedBorder: OutlineInputBorder(
          //                         borderRadius:
          //                             BorderRadius.circular(AppSize.appSize12),
          //                         borderSide: BorderSide.none,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     )).paddingOnly(
          //   top: AppSize.appSize16,
          //   left: AppSize.appSize16,
          //   right: AppSize.appSize16,
          // ),
          // Obx(() => CommonTextField(
          //       controller: propertyDetailsController.emailController,
          //       focusNode: propertyDetailsController.emailFocusNode,
          //       hasFocus: propertyDetailsController.hasEmailFocus.value,
          //       hasInput: propertyDetailsController.hasEmailInput.value,
          //       hintText: AppString.emailAddress,
          //       labelText: AppString.emailAddress,
          //     )).paddingOnly(
          //   top: AppSize.appSize16,
          //   left: AppSize.appSize16,
          //   right: AppSize.appSize16,
          // ),
          // Text(
          //   AppString.areYouARealEstateAgent,
          //   style: AppStyle.heading4Regular(color: AppColor.textColor),
          // ).paddingOnly(
          //   top: AppSize.appSize16,
          //   left: AppSize.appSize16,
          //   right: AppSize.appSize16,
          // ),
          // Row(
          //   children: List.generate(propertyDetailsController.realEstateList.length, (index) {
          //     return GestureDetector(
          //       onTap: () {
          //         propertyDetailsController.updateAgent(index);
          //       },
          //       child: Obx(() => Container(
          //         width: AppSize.appSize75,
          //         margin: const EdgeInsets.only(right: AppSize.appSize16),
          //         padding: const EdgeInsets.symmetric(
          //           vertical: AppSize.appSize10,
          //         ),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(AppSize.appSize12),
          //           border: Border.all(
          //             color: propertyDetailsController.selectAgent.value == index
          //                 ? AppColor.primaryColor
          //                 : AppColor.borderColor,
          //             width: AppSize.appSize1,
          //           ),
          //         ),
          //         child: Center(
          //           child: Text(
          //             propertyDetailsController.realEstateList[index],
          //             style: AppStyle.heading5Medium(
          //               color: propertyDetailsController.selectAgent.value == index
          //                   ? AppColor.primaryColor
          //                   : AppColor.descriptionColor,
          //             ),
          //           ),
          //         ),
          //       )),
          //     );
          //   }),
          // ).paddingOnly(
          //   top: AppSize.appSize10,
          //   left: AppSize.appSize16, right: AppSize.appSize16,
          // ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         propertyDetailsController.toggleCheckbox();
          //       },
          //       child: Obx(() => Image.asset(
          //             propertyDetailsController.isChecked.value
          //                 ? Assets.images.checkbox.path
          //                 : Assets.images.emptyCheckbox.path,
          //             width: AppSize.appSize20,
          //           )).paddingOnly(right: AppSize.appSize16),
          //     ),
          //     Expanded(
          //       child: CommonRichText(
          //         segments: [
          //           TextSegment(
          //             text: AppString.terms1,
          //             style: AppStyle.heading6Regular(
          //                 color: AppColor.descriptionColor),
          //           ),
          //           TextSegment(
          //             text: AppString.terms2,
          //             style: AppStyle.heading6Regular(
          //                 color: AppColor.primaryColor),
          //           ),
          //           TextSegment(
          //             text: AppString.terms3,
          //             style: AppStyle.heading6Regular(
          //                 color: AppColor.descriptionColor),
          //           ),
          //           TextSegment(
          //             text: AppString.terms4,
          //             style: AppStyle.heading6Regular(
          //                 color: AppColor.primaryColor),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ).paddingOnly(
          //   top: AppSize.appSize16,
          //   left: AppSize.appSize16,
          //   right: AppSize.appSize16,
          // ),
          // CommonButton(
          //   onPressed: () {
          //     Get.toNamed(AppRoutes.contactOwnerView);
          //   },
          //   backgroundColor: AppColor.primaryColor,
          //   child: Text(
          //     AppString.viewPhoneNumberButton,
          //     style: AppStyle.heading5Medium(color: AppColor.whiteColor),
          //   ),
          // ).paddingOnly(
          //   left: AppSize.appSize16,
          //   right: AppSize.appSize16,
          //   top: AppSize.appSize26,
          // ),
          Text(
            AppString.exploreMap,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(
            top: AppSize.appSize36,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.appSize12),
            child: SizedBox(
              height: AppSize.appSize200,
              width: double.infinity,
              child: GoogleMap(
                onMapCreated: (ctr) {},
                mapType: MapType.normal,
                myLocationEnabled: false,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                markers: {
                  Marker(
                    markerId: const MarkerId(AppString.testing),
                    visible: true,
                    position: LatLng(
                      propertyDetails?.property?.lat ?? AppSize.latitude,
                      propertyDetails?.property?.lon ?? AppSize.longitude,
                    ),
                  )
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    propertyDetails?.property?.lat ?? AppSize.latitude,
                    propertyDetails?.property?.lon ?? AppSize.longitude,
                  ),
                  zoom: AppSize.appSize15,
                ),
              ),
            ),
          ).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),






          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.reviews,
                style: AppStyle.heading3SemiBold(color: AppColor.textColor),
              ),
              GestureDetector(
                onTap: () {
                  //Get.toNamed(AppRoutes.addReviewsForPropertyView);
                  Get.to(() => AddReviewsForPropertyView(),

                      arguments: propertyId);
                },
                child: Text(
                  AppString.addReviews,
                  style: AppStyle.heading5Regular(color: AppColor.primaryColor),
                ),
              ),
            ],
          ).paddingOnly(
            top: AppSize.appSize36,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),

          propertyDetails?.reviews?.data?.isEmpty ?? true
              ? Center(
            child: Text(
              'No reviews available',
              style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
            ),
          )
              :

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: propertyDetails?.reviews?.data?.length ?? 0,
            itemBuilder: (context, index) {
              final review = propertyDetails?.reviews?.data?[index];
              return Container(
                margin: const EdgeInsets.only(bottom: AppSize.appSize16),
                padding: const EdgeInsets.all(AppSize.appSize16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.appSize16),
                  border: Border.all(
                    color: AppColor.descriptionColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Review Date
                        Text(
                          propertyDetailsController.reviewDateList[index],
                          style: AppStyle.heading6Regular(
                              color: AppColor.descriptionColor),
                        ),

                        // Dynamic Star Rating
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              Icons.star,
                              color: (starIndex < (review?.rating ?? 0))
                                  ? Colors.orange // Filled star
                                  : Colors.grey,  // Empty star
                              size: AppSize.appSize18, // Adjust the size
                            );
                          }),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.account_circle, // You can replace this with another icon if you prefer
                          size: AppSize.appSize36,
                          color: AppColor.descriptionColor, // Customize color as needed
                        ),

                        Text(
                          review?.user?.name ?? '',
                          style: AppStyle.heading5Medium(
                              color: AppColor.textColor),
                        ).paddingOnly(left: AppSize.appSize6),
                      ],
                    ).paddingOnly(top: AppSize.appSize10),
                    Text(
                      propertyDetailsController.reviewTypeList[index],
                      style: AppStyle.heading5Medium(
                          color: AppColor.descriptionColor),
                    ).paddingOnly(top: AppSize.appSize10),
                    Text(
                      review?.review ?? '',
                      style:
                          AppStyle.heading5Regular(color: AppColor.textColor),
                    ).paddingOnly(top: AppSize.appSize10),
                  ],
                ),
              );
            },
          ).paddingOnly(
            top: AppSize.appSize16,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),



          Text(
            AppString.similarHomesForYou,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          SizedBox(
            height: AppSize.appSize372,
              child: GetBuilder<HomeController>(
                  builder: (homeController) {
                    return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(left: AppSize.appSize16),
              itemCount: propertyDetails?. relatedProperties.length,
              itemBuilder: (context, index) {
                final property =propertyDetails?.relatedProperties[index];
                final isSaved = homeController.isSavedMap[property.id] ?? false;
                /*if (!isSavedMap.containsKey(property.id)) {
                  isSavedMap[property.id] = false;
                }*/

                return GestureDetector(
                  onTap: () async {
                    final int propertyId = property.id;
                    print('Tapped on property with ID: $propertyId');

                    // Create a new controller instance for the new property details screen
                    final PropertyDetailsController newController = Get.put(
                        PropertyDetailsController(),
                        tag: 'property_$propertyId'  // Use a unique tag for each property
                    );

                    // Fetch the details with the new controller
                    await newController.fetchPropertyDetails(propertyId);

                    // Navigate to a new instance of PropertyDetailsView with the new controller
                    Get.to(
                            () => PropertyDetailsView(),
                        arguments: propertyId,
                        preventDuplicates: false
                    );
                  },


                 /* onTap: () async {
                    final int propertyId =property.id;
                    /*print('Tapped on property with ID: $propertyId');

                  // Wait for the API call to finish before proceeding
                  await fetchPropertyDetails(propertyId);

                  // Print the property details that will be passed to the next view
                  print('Passing property details: ${propertyDetails.value?.property?.title}');

                  Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyDetails.value);*/



                    print('Tapped on property with ID: $propertyId');
                    await propertyDetailsController.fetchPropertyDetails(propertyId); // Fetch details
                    //Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyController.propertyDetails.value);
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        PropertyDetailsView()),
                    );*/

                    Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyId);


                    //Get.offNamed(AppRoutes.propertyDetailsView, arguments: propertyId);

                    /* Get.to(
                          () => PropertyDetailsView(),
                      arguments: propertyId,  preventDuplicates: false
                    );*/

                  },*/



                  child: Container(
                    width: AppSize.appSize300,
                    padding: const EdgeInsets.all(AppSize.appSize10),
                    margin: const EdgeInsets.only(right: AppSize.appSize16),
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              property.thumbnailImage, // Load thumbnail from model
                              height: AppSize.appSize200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: AppSize.appSize6,
                              top: AppSize.appSize6,
                              child: GestureDetector(
                                onTap: () async {
                                  // Check for token before proceeding.
                                  if (isSaved) {
                                    await homeController.removeFromWishlist(
                                        property.id);
                                  } else {
                                    await homeController.addToWishlist(
                                        property.id);
                                  }
                                },
                                child: Container(
                                  width: AppSize.appSize32,
                                  height: AppSize.appSize32,
                                  decoration: BoxDecoration(
                                    color: AppColor.whiteColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(AppSize.appSize6),
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 1,
                                    ),
                                  ),
                                  child: Obx(() {
                                    final isSaved = homeController.isSavedMap[property.id] ?? false;
                                    return  Icon(
                                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                                      color: isSaved ? AppColor.primaryColor : AppColor.primaryColor.withOpacity(0.6),
                                    );

                                  }),
                                ),
                              ),
                            ),

                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.title,
                              style: AppStyle.heading5SemiBold(
                                  color: AppColor.textColor),
                            ),
                            /*Text(
                              property.address,
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ).paddingOnly(top: AppSize.appSize6),*/
                          ],
                        ).paddingOnly(top: AppSize.appSize8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "QAR ${property.price}", // Add "QAR" before the price
                              style: AppStyle.heading5Medium(color: AppColor.primaryColor),
                            ),
                            Row(
                              children: [
                                Text(
                                  property.totalRating != null
                                      ? property.totalRating.toString()
                                      : 'No Rating', // Fallback for null value
                                  style: AppStyle.heading5Medium(color: AppColor.primaryColor),
                                ),
                                SizedBox(width: AppSize.appSize6),
                                Icon(
                                  Icons.star,
                                  color: Color(0xFFFFB84D),
                                  size: AppSize.appSize18,
                                ),
                              ],
                            ),
                          ],
                        ).paddingOnly(top: AppSize.appSize6),
                        Divider(
                          color: AppColor.descriptionColor
                              .withOpacity(AppSize.appSizePoint3),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Display number of bedrooms
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSize.appSize6,
                                horizontal: AppSize.appSize16,
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
                                  Icon(
                                    Icons.bed,
                                    color: AppColor.primaryColor,
                                    size: AppSize.appSize18,
                                  ),
                                  SizedBox(width: AppSize.appSize6),
                                  Text(
                                    '${property.totalBedroom} ',
                                    style: AppStyle.heading5Medium(color: AppColor.textColor),
                                  ),
                                ],
                              ),
                            ),
                            // Display number of bathrooms
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSize.appSize6,
                                horizontal: AppSize.appSize16,
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
                                  Icon(
                                    Icons.bathtub,
                                    color: AppColor.primaryColor,
                                    size: AppSize.appSize18,
                                  ),
                                  SizedBox(width: AppSize.appSize6),
                                  Text(
                                    '${property.totalBathroom} ',
                                    style: AppStyle.heading5Medium(color: AppColor.textColor),
                                  ),
                                ],
                              ),
                            ),
                            // Display area
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSize.appSize6,
                                horizontal: AppSize.appSize16,
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
                                  Icon(
                                    Icons.area_chart,
                                    color: AppColor.primaryColor,
                                    size: AppSize.appSize18,
                                  ),
                                  SizedBox(width: AppSize.appSize6),
                                  Text(
                                    '${property.totalArea} sq/m',
                                    style: AppStyle.heading5Medium(color: AppColor.textColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).paddingOnly(top: AppSize.appSize6),
                      ],
                    ),
                  ),
                );
              },
            );
  }
  ),



          ).paddingOnly(top: AppSize.appSize16),
          // Text(
          //   AppString.interestingReads,
          //   style: AppStyle.heading4Medium(color: AppColor.textColor),
          // ).paddingOnly(
          //   top: AppSize.appSize36,
          //   left: AppSize.appSize16,
          //   right: AppSize.appSize16,
          // ),
          // SizedBox(
          //   height: AppSize.appSize116,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     shrinkWrap: true,
          //     physics: const ClampingScrollPhysics(),
          //     padding: const EdgeInsets.only(left: AppSize.appSize16),
          //     itemCount: propertyDetailsController.interestingImageList.length,
          //     itemBuilder: (context, index) {
          //       return Container(
          //         width: AppSize.appSize300,
          //         padding: const EdgeInsets.all(AppSize.appSize16),
          //         margin: const EdgeInsets.only(right: AppSize.appSize16),
          //         decoration: BoxDecoration(
          //           color: AppColor.secondaryColor,
          //           borderRadius: BorderRadius.circular(AppSize.appSize12),
          //         ),
          //         child: Row(
          //           children: [
          //             Image.asset(
          //               propertyDetailsController.interestingImageList[index],
          //             ).paddingOnly(right: AppSize.appSize16),
          //             Expanded(
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     propertyDetailsController
          //                         .interestingTitleList[index],
          //                     maxLines: AppSize.size3,
          //                     overflow: TextOverflow.ellipsis,
          //                     style: AppStyle.heading5Medium(
          //                         color: AppColor.textColor),
          //                   ),
          //                   Text(
          //                     propertyDetailsController
          //                         .interestingDateList[index],
          //                     style: AppStyle.heading6Regular(
          //                         color: AppColor.descriptionColor),
          //                   ).paddingOnly(top: AppSize.appSize6),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ).paddingOnly(top: AppSize.appSize16),
        ],
      ).paddingOnly(top: AppSize.appSize10),
    );
  }

  Widget buildButton( context,propertyDetails) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColor.primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // WhatsApp Button
            IconButton(
                onPressed: () {
                  String whatsapp = propertyDetails?.propertyAgent?.phone;  // Get dynamically
                  propertyDetailsController.openWhatsApp(whatsapp);

                  // Launch WhatsApp with a predefined message
                  // final whatsappUrl =
                  //     "whatsapp://send?phone=YOUR_PHONE_NUMBER&text=Hello";
                  // launchUrl(Uri.parse(whatsappUrl));
                },
                icon: Image.asset(
                  Assets.images.whatsapp.path,
                  width: AppSize.appSize28, color: Color(0xFFEFECE4),
                  // color: Colors.green,
                )),

            // Call Button
            IconButton(
              onPressed: () {
                String phoneNumber = propertyDetails?.propertyAgent?.phone; // Get dynamically
                propertyDetailsController.launchDialer(phoneNumber);
                // Launch phone dialer
                // final phoneUrl = "tel:YOUR_PHONE_NUMBER";
                // launchUrl(Uri.parse(phoneUrl));
              },
              icon: const Icon(
                Icons.phone, color: Color(0xFFEFECE4),
                // color: Colors.blue,
                size: 28,
              ),
            ),

            // SMS Button
            IconButton(
              onPressed: () {

                String agentEmail = propertyDetails?.propertyAgent?.email; // Get dynamically
                propertyDetailsController.openGmail(agentEmail);

                // Launch SMS
                // final smsUrl = "sms:YOUR_PHONE_NUMBER";
                // launchUrl(Uri.parse(smsUrl));
              },
              icon: const Icon(
                Icons.sms,
                color: Color(0xFFEFECE4),
                size: 28,
              ),
            ),

            IconButton(
              onPressed: () {
               // Get.to(() => EnquiryForm());
                // Passing the propertyId as an argument to the EnquiryForm
                final int propertyId = propertyDetails?.property?.id ?? 0; // Default to 0 if null
                Get.to(() => EnquiryForm(), arguments: propertyId);



              },
              icon: const Icon(
                Icons.list_alt, color: Color(0xFFEFECE4),
                // color: Colors.blue,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
    // return CommonButton(
    //   onPressed: () {},
    //   backgroundColor: AppColor.primaryColor,
    //   child: Text(
    //     AppString.ownerDetailsButton,
    //     style: AppStyle.heading5Medium(color: AppColor.whiteColor),
    //   ),
    // ).paddingOnly(
    //   left: AppSize.appSize16,
    //   right: AppSize.appSize16,
    //   bottom: AppSize.appSize26,
    //   top: AppSize.appSize10,
    // );
  }
}
