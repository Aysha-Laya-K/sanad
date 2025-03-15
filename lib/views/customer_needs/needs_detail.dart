import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/customerneeds_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_font.dart';
class CustomerNeedDetailView extends StatelessWidget {
  final CustomerNeed need;

  CustomerNeedDetailView({required this.need});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        title: Text(
          'Customer Need Details',
          style: TextStyle(
            fontSize: AppSize.appSize18,
            fontWeight: FontWeight.w600,
            fontFamily: AppFont.interRegular, // Use Inter-Regular
            color: AppColor.textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          color: AppColor.backgroundColor,
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
              children: [
                // Title
                Text(
                  need.title,
                  style: TextStyle(
                    fontSize: AppSize.appSize18,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFont.interRegular, // Use Inter-Regular
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                // Full Description
                Html(
                  data: need.description,
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontFamily: AppFont.interRegular, // Use Inter-Regular
                    ),
                    "p": Style(
                      fontSize: FontSize(16),
                      lineHeight: LineHeight(1.6),
                      color: AppColor.descriptionColor,
                      margin: Margins.only(bottom: 12),
                      fontFamily: AppFont.interRegular, // Use Inter-Regular
                    ),
                    "ul": Style(
                      padding: HtmlPaddings.all(16),
                      margin: Margins.only(bottom: 12),
                      fontFamily: AppFont.interRegular, // Use Inter-Regular
                    ),
                    "li": Style(
                      fontSize: FontSize(14),
                      listStyleType: ListStyleType.disc,
                      color: Colors.black,
                      margin: Margins.only(bottom: 8),
                      fontFamily: AppFont.interRegular, // Use Inter-Regular
                    ),
                  },
                ),
                SizedBox(height: 16),
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blueGrey, size: 18),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Location: ${need.location}',
                        style: TextStyle(
                          fontSize: AppSize.appSize14,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFont.interRegular, // Use Inter-Regular
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*class CustomerNeedDetailView extends StatelessWidget {
  final CustomerNeed need;

  CustomerNeedDetailView({required this.need});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        title: Text(
          'Customer Need Details',
          style: AppStyle.heading3SemiBold(color: AppColor.textColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          color: AppColor.backgroundColor,
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  need.title,
                  style: AppStyle.headingSemiBold(color: Colors.black87),
                ),
                SizedBox(height: 8),
                // Full Description
                Html(
                  data: need.description,
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                    "p": Style(
                      fontSize: FontSize(16),
                      lineHeight: LineHeight(1.6),
                      color: AppColor.descriptionColor,
                      margin: Margins.only(bottom: 12),
                    ),
                  },
                ),
                SizedBox(height: 16),
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blueGrey, size: 18),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Location: ${need.location}',
                        style: AppStyle.heading5SemiBold(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/