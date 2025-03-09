import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/notification_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});

  NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView
        child: buildNotificationsList(),
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
            Get.back();
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      title: Text(
        AppString.notifications,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildNotificationsList() {
    return Obx(() {
      if (notificationController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (notificationController.notifications.isEmpty) {
        return Center(child: Text("No notifications available"));
      }

      return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.appSize16,
          vertical: AppSize.appSize10,
        ),
        physics: const ClampingScrollPhysics(),
        itemCount: notificationController.notifications.length,
        itemBuilder: (context, index) {
          final notification = notificationController.notifications[index];

          return Container(
            padding: EdgeInsets.all(AppSize.appSize12),
            margin: EdgeInsets.only(bottom: AppSize.appSize10),
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(AppSize.appSize12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Ensure column takes minimal vertical space
              children: [
                Text(
                  notification.title,
                  style: AppStyle.heading5Medium(
                    color: AppColor.textColor,
                  ),
                  softWrap: true, // Ensure text wraps
                ),
                SizedBox(height: AppSize.appSize6),
                Text(
                  notification.description.replaceAll(RegExp(r'<[^>]*>'), ''),
                  style: AppStyle.heading5Regular(
                    color: AppColor.descriptionColor,
                  ),
                  softWrap: true, // Explicitly enable text wrapping
                ),
                SizedBox(height: AppSize.appSize10),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    notification.createdAt.toLocal().toString(),
                    style: AppStyle.heading6Regular(
                      color: AppColor.descriptionColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

}
