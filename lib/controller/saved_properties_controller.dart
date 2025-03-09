import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/wishlist_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SavedPropertiesController extends GetxController {
  RxInt selectSavedProperty = 0.obs;

  RxList<bool> isSimilarPropertyLiked = <bool>[].obs;
  var wishlistResponse = Rxn<WishlistResponse>();

  void updateSavedProperty(int index) {
    selectSavedProperty.value = index;
  }

  void launchDialer() async {
    final Uri phoneNumber = Uri(scheme: 'tel', path: '9995958748');
    if (await canLaunchUrl(phoneNumber)) {
      await launchUrl(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }


  Future<void> fetchWishlist() async {
    // Retrieve token from SharedPreferences
    final token = await UserTypeManager.getToken();

    // If token is null or empty, display a message and return early.
    if (token == null || token.isEmpty) {
      // You can use Get.snackbar, a dialog, or any other UI feedback mechanism.
      // Here, we simply print the message.
      print("No whitelisted properties available because no token is found.");
      // Optionally, you might want to update an observable message to show in the UI.
      return;
    }

    final url =
        'https://project.artisans.qa/realestate/api/user/wishlist?limit=10&offset=0';

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        wishlistResponse.value = WishlistResponse.fromJson(jsonData);
        print(
            "Wishlist fetched successfully. Total items: ${wishlistResponse.value?.properties.total}");
      } else {
        // Handle error responses
        print("Failed to fetch wishlist. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exceptions, e.g., network errors
      print("Exception when fetching wishlist: $e");
    }
  }






  RxList<String> savedPropertyList = [
    AppString.properties3,
    AppString.project,
    AppString.localities,
  ].obs;

  RxList<String> searchImageList = [
    Assets.images.searchProperty1.path,
    Assets.images.savedProperty1.path,
    Assets.images.savedProperty2.path,
  ].obs;

  RxList<String> searchTitleList = [
    AppString.semiModernHouse,
    AppString.vijayVRX,
    AppString.yashasviSiddhi,
  ].obs;

  RxList<String> searchAddressList = [
    AppString.address6,
    AppString.templeSquare,
    AppString.schinnerVillage,
  ].obs;

  RxList<String> searchRupeesList = [
    AppString.rupees58Lakh,
    AppString.rupees58Lakh,
    AppString.rupee65Lakh,
  ].obs;

  RxList<String> searchPropertyImageList = [
    Assets.images.bath.path,
    Assets.images.bed.path,
    Assets.images.plot.path,
  ].obs;

  RxList<String> searchPropertyTitleList = [
    AppString.point2,
    AppString.point2,
    AppString.bhk2,
  ].obs;
}