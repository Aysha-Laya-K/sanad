import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_button.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/login_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/login_country_picker_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/login/widgets/login_coutry_picker_bottom_sheet.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  LoginController loginController = Get.put(LoginController());
  LoginCountryPickerController loginCountryPickerController =
  Get.put(LoginCountryPickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: buildLoginFields(context),

    );
  }

  Widget buildLoginFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppString.login,
          style: AppStyle.heading1(color: AppColor.textColor),
        ),
        Text(
          AppString.loginString,
          style: AppStyle.heading4Regular(color: AppColor.descriptionColor),
        ).paddingOnly(top: AppSize.appSize12),
        Obx(() =>
            Container(
              padding: EdgeInsets.only(
                top: loginController.hasFocus.value ||
                    loginController.hasInput.value
                    ? AppSize.appSize6
                    : AppSize.appSize14,
                bottom: loginController.hasFocus.value ||
                    loginController.hasInput.value
                    ? AppSize.appSize8
                    : AppSize.appSize14,
                left: loginController.hasFocus.value
                    ? AppSize.appSize0
                    : AppSize.appSize16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                border: Border.all(
                  color: loginController.hasFocus.value ||
                      loginController.hasInput.value
                      ? AppColor.primaryColor
                      : AppColor.descriptionColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  loginController.hasFocus.value ||
                      loginController.hasInput.value
                      ? Text(
                    AppString.phoneNumber,
                    style: AppStyle.heading6Regular(
                        color: AppColor.primaryColor),
                  ).paddingOnly(
                    left: loginController.hasInput.value
                        ? (loginController.hasFocus.value
                        ? AppSize.appSize16
                        : AppSize.appSize0)
                        : AppSize.appSize16,
                    bottom: loginController.hasInput.value
                        ? AppSize.appSize2
                        : AppSize.appSize2,
                  )
                      : const SizedBox.shrink(),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: loginController.hasInput.value
                              ? (loginController.hasFocus.value
                              ? AppSize.appSize16
                              : AppSize.appSize0)
                              : AppSize.appSize16,
                        ),
                        child: Text(
                          '+974', // Static country code
                          style: AppStyle.heading4Regular(
                              color: AppColor.descriptionColor),
                        ),
                      ),
                      SizedBox(width: AppSize.appSize8),


                      Expanded(
                        child: SizedBox(
                          height: AppSize.appSize27,
                          width: double.infinity,
                          child: TextFormField(
                            focusNode: loginController.focusNode,
                            controller: loginController.mobileController,
                            cursorColor: AppColor.primaryColor,
                            keyboardType: TextInputType.phone,
                            style: AppStyle.heading4Regular(
                                color: AppColor.textColor),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(AppSize.size10),
                            ],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSize.appSize0,
                                vertical: AppSize.appSize0,
                              ),
                              isDense: true,
                              hintText: loginController.hasFocus.value
                                  ? ''
                                  : AppString.phoneNumber,
                              hintStyle: AppStyle.heading4Regular(
                                  color: AppColor.descriptionColor),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(AppSize.appSize12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(AppSize.appSize12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(AppSize.appSize12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )).paddingOnly(top: AppSize.appSize36),
        CommonButton(
          onPressed: () async {
            await UserTypeManager.setUserType('user');
            String mobileNumber = loginController.mobileController.text;
            Get.toNamed(AppRoutes.otpView, arguments: mobileNumber);


            loginController.sendMobileNumber();
          },
          child: Text(
            AppString.continueButton,
            style: AppStyle.heading5Medium(color: AppColor.whiteColor),
          ),
        ).paddingOnly(top: AppSize.appSize36),
      ],
    ).paddingOnly(
      left: AppSize.appSize16,
      right: AppSize.appSize16,
    );
  }

}