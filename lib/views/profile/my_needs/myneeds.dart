import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/customer_needs_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/myneeds_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/requirement_update./req_update.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:html/parser.dart' as html;
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';





class MyNeedsView extends StatelessWidget {
  final MyNeedsController controller = Get.put(MyNeedsController());

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
          'My Requirements',
          style: AppStyle.heading4Medium(color: AppColor.textColor),
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: controller.myNeeds.length,
            itemBuilder: (context, index) {
              final need = controller.myNeeds[index];
              return GestureDetector(
                  onTap: () {
                Get.to(
                      () => UpdateRequirementView(),
                  arguments: {
                    'requirementId': need.id, // Pass the need ID
                    'title': need.title,
                    'description': need.description,
                    'locationId': need.location,

                    // 'locationId': need.location,
                  },
                );
              },
              child:  Card(
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
                          "p": Style(
                            fontSize: FontSize(16), // Adjust paragraph font size
                            lineHeight: LineHeight(1.6), // Adjust line spacing
                            color: AppColor.descriptionColor, // Customize text color
                          ),
                          "strong": Style(
                            fontWeight: FontWeight.bold, // Bold text for strong elements
                          ),
                          "ul": Style(
                            padding: HtmlPaddings.all(16), // Use HtmlPaddings for padding
                          ),
                          "li": Style(
                            fontSize: FontSize(14), // Adjust list item font size
                            listStyleType: ListStyleType.disc, // Add bullets to the list
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
              )
              );
            },
          );
        }
      }),
    );
  }
}