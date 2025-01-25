import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';

class BottomBarController extends GetxController {
  RxInt selectIndex = 0.obs;
  PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: AppSize.size0);
  }

  void updateIndex(int index) {
    selectIndex.value = index;
  }

  RxList<String> bottomBarImageList = [
    Assets.images.home.path,
    Assets.images.task.path,
    // '',
    Assets.images.save.path,
    Assets.images.user.path,
  ].obs;
  RxList<String> bottomBarImageList2 = [
    Assets.images.home.path,
    // Assets.images.task.path,
    '',
    // Assets.images.save.path,
    Assets.images.user.path,
  ].obs;
  RxList<String> bottomBarMenuNameList = [
    AppString.home,
    AppString.service,
    //'',
    AppString.saved,
    AppString.profile,
  ].obs;
}
