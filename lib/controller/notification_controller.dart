import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/notification_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Import the model class

class NotificationController extends GetxController {
  RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(); // Call API when the page is loaded
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse("https://project.artisans.qa/realestate/api/notifications"));

      if (response.statusCode == 200) {
        print("API Response: ${response.body}");
        final jsonResponse = json.decode(response.body);
        NotificationResponse notificationResponse = NotificationResponse.fromMap(jsonResponse);
        notifications.assignAll(notificationResponse.notifications);
      } else {
        print("Failed to load notifications: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading(false);
    }
  }

  RxList<String> notificationTitleList = [
    AppString.title1,
    AppString.title2,
    AppString.title3,
    AppString.title4,
    AppString.title5,
    AppString.title5,
    AppString.title6,
    AppString.title7,
    AppString.title8,
  ].obs;

  RxList<String> notificationSubTitleList = [
    AppString.subtitle1,
    AppString.subtitle1,
    AppString.subtitle3,
    AppString.subtitle4,
    AppString.subtitle5,
    AppString.subtitle6,
    AppString.subtitle7,
    AppString.subtitle8,
    AppString.subtitle9,
  ].obs;

  RxList<String> notificationTimingList = [
    AppString.hours2Ago,
    AppString.hours5Ago,
    AppString.yesterdayText,
    AppString.yesterdayText,
    AppString.yesterdayText,
    AppString.days2Ago,
    AppString.days3Ago,
    AppString.days3Ago,
    AppString.days3Ago,
  ].obs;
}