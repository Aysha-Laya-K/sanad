import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';

class ProfileController extends GetxController {
  RxInt selectEmoji = 0.obs;

  void updateEmoji(int index) {
    selectEmoji.value = index;
  }

  RxList<String> profileOptionImageList = [
    Assets.images.profileOption1.path,
    Assets.images.profileOption2.path,
    //  Assets.images.profileOption3.path,
    Assets.images.profileOption4.path,
    Assets.images.profileOption5.path,
    Assets.images.profileOption6.path,
    Assets.images.profileOption6.path,
  ].obs;

  RxList<String> profileOptionTitleList = [
    AppString.viewResponses,
    AppString.languages,
    // AppString.communicationSettings,
    AppString.shareFeedback,
    AppString.areYouFindingUsHelpful,
    AppString.logout,
    AppString.deleteAccount,
  ].obs;

  RxList<String> findingUsImageList = [
    Assets.images.poor.path,
    Assets.images.neutral.path,
    Assets.images.good.path,
    Assets.images.excellent.path,
  ].obs;

  RxList<String> findingUsTitleList = [
    AppString.poor,
    AppString.neutral,
    AppString.good,
    AppString.excellent,
  ].obs;
}
