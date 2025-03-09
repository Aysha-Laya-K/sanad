import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/privacypolicy_controller.dart';
import 'package:html/parser.dart' as html;
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});


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
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildPrivacyPolicy(),
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
        AppString.privacyPolicy,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  /*Widget buildPrivacyPolicy() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.privacyPolicyString1,
            style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          ),
          Text(
            AppString.privacyPolicyString2,
            style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          ),
          Text(
            AppString.privacyPolicyString3,
            style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          ),
          Text(
            AppString.informationYouProvide,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(top: AppSize.appSize20, bottom: AppSize.appSize20),
          customRow(AppString.informationYouProvideString1),
          customRow(AppString.informationYouProvideString2),
          customRow(AppString.informationYouProvideString3),
          Text(
            AppString.informationCollected,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(top: AppSize.appSize20, bottom: AppSize.appSize20),
          customRow(AppString.informationCollectedString1),
          customRow(AppString.informationCollectedString2),
          customRow(AppString.informationCollectedString3),
          Text(
            AppString.howUseInformation,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(top: AppSize.appSize20, bottom: AppSize.appSize20),
          Text(
            AppString.howUseInformationString,
            style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          ).paddingOnly(bottom: AppSize.appSize20),
          customRow(AppString.howUseInformationString1),
          customRow(AppString.howUseInformationString2),
          customRow(AppString.howUseInformationString3),
          customRow(AppString.howUseInformationString4),
          customRow(AppString.howUseInformationString5),
          customRow(AppString.howUseInformationString6),
          customRow(AppString.howUseInformationString7),
          customRow(AppString.howUseInformationString8),
        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16, right: AppSize.appSize16,
      ),
    );
  }*/

  Widget buildPrivacyPolicy() {
    return FutureBuilder<String>(
      future: fetchPrivacyPolicy(), // API call
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load privacy policy'));
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSize.appSize20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(
                  data: snapshot.data!, // Use the raw HTML response here
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
                /*Text(
                  cleanDescription(snapshot.data!),
                  style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
                ),*/
              ],
            ).paddingOnly(
              top: AppSize.appSize10,
              left: AppSize.appSize16, right: AppSize.appSize16,
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }


  customRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppSize.appSize5,
          height: AppSize.appSize5,
          margin: const EdgeInsets.only(
            right: AppSize.appSize12, top: AppSize.appSize8,
            left: AppSize.appSize12,
          ),
          decoration: const BoxDecoration(
            color: AppColor.descriptionColor,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          ),
        ),
      ],
    );
  }
}
