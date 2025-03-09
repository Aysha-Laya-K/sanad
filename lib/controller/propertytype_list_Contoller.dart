import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/property__model.dart';

class PropertyTypeListController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<bool> isPropertyLiked = <bool>[].obs;
 // RxList<Property> properties = <Property>[].obs;
  //var loading = true.obs;




  void launchDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }





  RxList<String> searchImageList = [
    Assets.images.searchProperty1.path,
    Assets.images.searchProperty3.path,
    Assets.images.searchProperty4.path,
  ].obs;

  RxList<String> searchTitleList = [
    AppString.semiModernHouse,
    AppString.theAcceptanceSociety,
    AppString.happinessChasers,
  ].obs;

  RxList<String> searchAddressList = [
    AppString.address6,
    AppString.mistyAddress,
    AppString.wildermanAddress,
  ].obs;

  RxList<String> searchRupeesList = [
    AppString.rupees58Lakh,
    AppString.lakh25,
    AppString.crore1,
  ].obs;

  RxList<String> searchRatingList = [
    AppString.rating4Point5,
    AppString.rating4Point2,
    AppString.rating4Point2,
  ].obs;

  RxList<String> searchSquareFeetList = [
    AppString.squareFeet966,
    AppString.squareFeet866,
    AppString.squareFeet1000,
  ].obs;

  RxList<String> searchSquareFeet2List = [
    AppString.squareFeet773,
    AppString.squareFeet658,
    AppString.squareFeet985,
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

  @override
  void dispose() {
    super.dispose();

    searchController.clear();
  }
}