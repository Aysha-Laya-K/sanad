import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_button.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/about_property_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:html/parser.dart' as html;
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutPropertyView extends StatelessWidget {
  AboutPropertyView({super.key});

  AboutPropertyController aboutPropertyController = Get.put(AboutPropertyController());

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


  @override
  Widget build(BuildContext context) {
    // Retrieve passed arguments
    final arguments = Get.arguments;
    final furnish = arguments['furnish'] ?? "Not Available";
    final address = arguments['address'] ?? "Not Available";
    final description = arguments['description'] ?? "Not Available";
    final phoneNumber = arguments['phone'] ?? "Not Available";

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildAboutProperty(furnish, address, description),
      bottomNavigationBar: buildButton(phoneNumber),
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
        AppString.aboutProperty,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildAboutProperty(String furnish, String address, String description) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSize.appSize10),
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
                  furnish, // Display the passed furnish
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
                        address, // Display the passed address
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
            top: AppSize.appSize16,
            bottom: AppSize.appSize16,
          ),
          Html(
            data: description, // Use the raw HTML response here
            style: {
              "p": Style(
                fontSize: FontSize(16), // Adjust paragraph font size
                lineHeight: LineHeight(1.6), // Adjust line spacing
                color: AppColor.descriptionColor, // Customize text color
              ),
              "strong": Style(
                fontWeight: FontWeight.bold, // Bold text for strong elements
              ),
              "ul": Style(
                padding: HtmlPaddings.all(16), // Correct padding type for lists
              ),
              "li": Style(
                fontSize: FontSize(14), // Adjust list item font size
                // Use Margins for list item margins
                listStyleType: ListStyleType.disc, // Add bullets to the list
              ),
            },
          ),
        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16, right: AppSize.appSize16,
      ),
    );
  }

  Widget buildButton(String phoneNumber) {
    return CommonButton(
      onPressed: () {
        aboutPropertyController. launchDialer(phoneNumber); // Pass phone to dialer
      },
      backgroundColor: AppColor.primaryColor,
      child: Text(
        AppString.callOwnerButton,
        style: AppStyle.heading5Medium(color: AppColor.whiteColor),
      ),
    ).paddingOnly(
        left: AppSize.appSize16, right: AppSize.appSize16,
        bottom: AppSize.appSize26
    );
  }
}
