import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/customer_needs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:html/parser.dart' as html;
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';

class CustomerNeedsView extends StatelessWidget {

  final CustomerNeedsController controller = Get.put(CustomerNeedsController());
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
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        title: Text(
          'Customer Needs',
          style: AppStyle.heading3SemiBold(color: AppColor.textColor),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: controller.customerNeeds.length,
            itemBuilder: (context, index) {
              final need = controller.customerNeeds[index];
              return Card(
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
                      Html(
                        data: need.description, // Use the raw HTML response here
                        style: {
                          "body": Style(
                            margin: Margins.zero, // Use HtmlPaddings for margin
                            padding: HtmlPaddings.zero, // Use HtmlPaddings for padding
                          ),
                          "p": Style(
                            fontSize: FontSize(16), // Adjust paragraph font size
                            lineHeight: LineHeight(1.6), // Adjust line spacing
                            color: AppColor.descriptionColor, // Customize text color
                            margin: Margins.only(bottom: 12), // Use HtmlPaddings for margin
                          ),
                          "strong": Style(
                            fontWeight: FontWeight.bold, // Bold text for strong elements
                            color: AppColor.textColor, // Customize strong text color
                          ),
                          "ul": Style(
                            padding: HtmlPaddings.all(16), // Use HtmlPaddings for padding
                            margin: Margins.only(bottom: 12), // Use HtmlPaddings for margin
                          ),
                          "li": Style(
                            fontSize: FontSize(14), // Adjust list item font size
                            listStyleType: ListStyleType.disc, // Add bullets to the list
                            color: AppColor.descriptionColor, // Customize list item color
                            margin: Margins.only(bottom: 8), // Use HtmlPaddings for margin
                          ),
                          "a": Style(
                            color: AppColor.primaryColor, // Customize link color
                            textDecoration: TextDecoration.underline, // Add underline
                          ),
                        },
                      ),
                      // Description
                      Divider(),

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
              );
            },
          );
        }
      }),
    );
  }
}