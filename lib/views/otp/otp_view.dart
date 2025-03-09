import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_button.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_rich_text.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/otp_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/text_segment_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:pinput/pinput.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/login_controller.dart';

class OtpView extends StatelessWidget {
  OtpView({super.key});

  OtpController otpController = Get.put(OtpController());
  LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    String mobileNumber = Get.arguments ?? "";
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: buildOTPField(mobileNumber),
      // bottomNavigationBar: buildTextButton(),
    );
  }

  Widget buildOTPField(mobileNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppString.otpVerification,
          style: AppStyle.heading1(color: AppColor.textColor),
        ),
        CommonRichText(
          segments: [
            TextSegment(
              text: AppString.verifyYourMobileNumber,
              style: AppStyle.heading4Regular(color: AppColor.descriptionColor),
            ),
            TextSegment(
              text: "+974 ${mobileNumber}",
              style: AppStyle.heading4Medium(color: AppColor.primaryColor),
            ),
          ],
        ).paddingOnly(top: AppSize.appSize12),
        Pinput(
          keyboardType: TextInputType.number,
          length: AppSize.size4,
          controller: otpController.pinController,
          autofocus: true,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          defaultPinTheme: PinTheme(
            height: AppSize.appSize51,
            width: AppSize.appSize51,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.descriptionColor,
              ),
              borderRadius: BorderRadius.circular(AppSize.appSize12),
            ),
            textStyle:
                AppStyle.heading4Regular(color: AppColor.descriptionColor),
          ),
          focusedPinTheme: PinTheme(
            height: AppSize.appSize51,
            width: AppSize.appSize51,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.primaryColor,
              ),
              borderRadius: BorderRadius.circular(AppSize.appSize12),
            ),
            textStyle: AppStyle.heading4Regular(color: AppColor.primaryColor),
          ),
          followingPinTheme: PinTheme(
            height: AppSize.appSize51,
            width: AppSize.appSize51,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.primaryColor,
              ),
              borderRadius: BorderRadius.circular(AppSize.appSize12),
            ),
            textStyle: AppStyle.heading4Regular(color: AppColor.primaryColor),
          ),
        ).paddingOnly(top: AppSize.appSize36),
        Center(
          child: Obx(() => CommonRichText(
                segments: [
                  TextSegment(
                    text: AppString.didNotReceiveTheCode,
                    style: AppStyle.heading5Regular(
                        color: AppColor.descriptionColor),
                  ),
                  TextSegment(
                    text: otpController.countdown.value == AppSize.size0
                        ? AppString.resendCodeButton
                        : otpController.formattedCountdown,
                    style:
                        AppStyle.heading5Medium(color: AppColor.primaryColor),
                    onTap: otpController.countdown.value == AppSize.size0
                        ? () async{
                      await loginController.sendMobileNumber();
                            otpController.startCountdown();
                          }
                        : null,
                  ),
                ],
              )).paddingOnly(top: AppSize.appSize12),
        ),
        CommonButton(
          onPressed: () {
            otpController.verifyOtp();
          },
          child: Obx(() {
            return otpController.isLoading.value
                ? CircularProgressIndicator(color: AppColor.whiteColor) // Show loading indicator
                : Text(
              AppString.verifyButton,
              style: AppStyle.heading5Medium(color: AppColor.whiteColor),
            );
          }),
        ).paddingOnly(top: AppSize.appSize36),

      ],
    ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16);
  }

  // Widget buildTextButton() {
  //   return Text(
  //     AppString.verifyViaMissedCallButton,
  //     textAlign: TextAlign.center,
  //     style: AppStyle.heading4Regular(color: AppColor.primaryColor),
  //   ).paddingOnly(bottom: AppSize.appSize26);
  // }
}
