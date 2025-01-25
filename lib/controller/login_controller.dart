import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool hasFocus = false.obs;
  RxBool hasInput = false.obs;
  FocusNode focusNode = FocusNode();
  TextEditingController mobileController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      hasFocus.value = focusNode.hasFocus;
    });
    mobileController.addListener(() {
      hasInput.value = mobileController.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    focusNode.dispose();
    mobileController.dispose();
    super.onClose();
  }
}