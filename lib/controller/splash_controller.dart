import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    // Delay for splash screen duration
    Future.delayed(const Duration(seconds: AppSize.size4), () async {
      // Check if token is present
      String? token = await UserTypeManager.getToken();

      if (token != null && token.isNotEmpty) {
        // If token exists, navigate to the Home page
        Get.offAllNamed(AppRoutes.bottomBarView);
      } else {
        // If token does not exist, navigate to the Onboard page
        Get.offAllNamed(AppRoutes.onboardView);
      }
    });
  }
}