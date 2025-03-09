import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_button.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_textfield.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/edit_country_picker_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/edit_profile_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/profile/widgets/edit_country_picker_bottom_sheet.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/profile/widgets/edit_second_country_picker_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart'; // Import image picker
import 'dart:io'; // For File
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/profile_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';

class EditProfileView extends StatefulWidget {
  EditProfileView({super.key});

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {

  File? _image; // Store the selected image
  final picker = ImagePicker();
  bool _isLoading = false;
  Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  RxBool isLoading = false.obs;

  FocusNode _fullNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _aboutMeFocusNode = FocusNode();

  // Controllers for TextFields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();


  bool _isFullNameFocused = false;
  bool _isEmailFocused = false;
  bool _isAddressFocused = false;
  bool _isAboutMeFocused = false;


  @override
  void initState() {
    super.initState();
    _checkTokenAndFetchProfile();
  }

  Future<void> _checkTokenAndFetchProfile() async {
    final token = await UserTypeManager.getToken();
    if (token != null) {
      // If token exists, fetch the profile from the API
      await _fetchProfileData(token);
    } else {
      // If token is null, remain with the default greeting
      userProfile.value = null;
    }
  }

  // API call to fetch user profile
  Future<void> _fetchProfileData(String token) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('https://project.artisans.qa/realestate/api/user/my-profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response and update userProfile
        final profileData = UserProfile.fromJson(jsonDecode(response.body)['user']);
        userProfile.value = profileData;


        _fullNameController.text = profileData.name ?? '';
        _emailController.text = profileData.email ?? '';
        _phoneNumberController.text = profileData.phone ?? '';
        _addressController.text = profileData.address ?? '';
      } else {
        // Handle API error
        Get.snackbar('Error', 'Failed to fetch profile data');
      }
    } catch (e) {
      // Handle other errors (network issues, etc.)
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the selected image
      });
    }
  }


  void _updateFocusState(FocusNode focusNode) {
    setState(() {
      _isFullNameFocused = focusNode == _fullNameFocusNode;
      _isEmailFocused = focusNode == _emailFocusNode;
      _isAddressFocused = focusNode == _addressFocusNode;
      _isAboutMeFocused = focusNode == _aboutMeFocusNode;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildEditProfileFields(context),
      bottomNavigationBar: buildButton(context),
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
        AppString.editProfile,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildEditProfileFields(BuildContext context) {

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      child: Column(
        children: [
          // Image upload section
        GestureDetector(
        onTap: _pickImage, // Trigger image picker when tapped
        child: Container(
          width: 150,  // Set a fixed width
          height: 150, // Set a fixed height
          decoration: BoxDecoration(
            color: AppColor.descriptionColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSize.appSize12), // This gives rounded corners
            image: _image != null
                ? DecorationImage(
              image: FileImage(_image!),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: _image == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_upward_outlined,
                color: AppColor.primaryColor,
                size: AppSize.appSize30,
              ),
              SizedBox(height: AppSize.appSize8),
              Text(
                "Upload Image",
                style: AppStyle.heading4Regular(color: AppColor.primaryColor),
              ),
            ],
          )
              : null,
        ),
      ).paddingOnly(top: AppSize.appSize36),


          // Full Name Field
          CommonTextField(
            controller: _fullNameController,
            focusNode: _fullNameFocusNode,
            hasFocus: _isFullNameFocused,
            hasInput: false,
            hintText: AppString.fullName,
            labelText: AppString.fullName,
          ).paddingOnly(top: AppSize.appSize16),

          // Phone Number Field
          CommonTextField(
            controller: _phoneNumberController,
            focusNode: FocusNode(),
            hasFocus: false,
            hasInput: false,
            hintText: AppString.phoneNumber,
            labelText: AppString.phoneNumber,
            readOnly: true,
            textfieldStyle: AppStyle.heading4Regular(color: AppColor.descriptionColor), // Lighter text color
            border: Border.all(color: AppColor.descriptionColor.withOpacity(0.5)), // Subtle border
          ).paddingOnly(top: AppSize.appSize16),

          // Email Field
          CommonTextField(
            controller: _emailController,  focusNode: _emailFocusNode,
            hasFocus: _isEmailFocused,
            hasInput: false,
            hintText: AppString.emailAddress,
            labelText: AppString.emailAddress,
            keyboardType: TextInputType.emailAddress,
          ).paddingOnly(top: AppSize.appSize16),

          // Address Field
          CommonTextField(
            controller: _addressController,
            focusNode: _addressFocusNode,
            hasFocus: _isAddressFocused,
            hasInput: false,
            hintText: AppString.address0,
            labelText: AppString.address0,
            keyboardType: TextInputType.emailAddress,
          ).paddingOnly(top: AppSize.appSize16),

          // About Me Field
          TextFormField(
            controller: _aboutMeController,
            focusNode: _aboutMeFocusNode,
            cursorColor: AppColor.primaryColor,
            style: AppStyle.heading4Regular(color: AppColor.textColor),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: AppString.aboutMe,
              hintStyle: AppStyle.heading4Regular(color: AppColor.descriptionColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                borderSide: BorderSide(
                  color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint7),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                borderSide: BorderSide(
                  color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint7),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                borderSide: const BorderSide(
                  color: AppColor.primaryColor,
                ),
              ),
            ),
          ).paddingOnly(top: AppSize.appSize16),
        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16,
        right: AppSize.appSize16,
        bottom: AppSize.appSize20,
      ),
    );


  }





  Widget buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CommonButton(
        onPressed: _isLoading
            ? null // Disable button when loading
            : () async {
          setState(() => _isLoading = true);

          String? token = await UserTypeManager.getToken();
          if (token == null) {
            print("Error: Token not found");
            setState(() => _isLoading = false);
            Get.snackbar(
              'Login Required',
              'Please log in to update your profile.',
              snackPosition: SnackPosition.TOP,
            );
            Get.toNamed(AppRoutes.loginView); // Navigate to login page
            return;
          }

          try {
            var request = http.MultipartRequest(
              'POST',
              Uri.parse('https://project.artisans.qa/realestate/api/user/update-profile'),
            );
            request.headers['Authorization'] = 'Bearer $token';

            request.fields.addAll({
              'name': _fullNameController.text,
              'phone': _phoneNumberController.text,
              'email': _emailController.text,
              'about_me': _aboutMeController.text,
              'address': _addressController.text,
            });

            if (_image != null) {
              print("Image path: ${_image!.path}");
              request.files.add(await http.MultipartFile.fromPath(
                'image',
                _image!.path,
                filename: 'profile_image.png',
              ));
            }

            var response = await request.send();
            final responseData = await response.stream.bytesToString();
            final decodedData = json.decode(responseData);


            setState(() => _isLoading = false);

            if (response.statusCode == 200) {
              print("Decoded Response Data: $decodedData");
              Get.back();
              Get.snackbar(
                'Success',
                'Profile updated successfully',
                snackPosition: SnackPosition.TOP, // Moved to top
              );
            }else {
              print("Error: ${decodedData['message'] ?? 'Unknown error'}");
              String errorMessage = decodedData['message'] ?? 'Unknown error';

              // If there are specific errors, append them to the message
              if (decodedData['errors'] != null) {
                decodedData['errors'].forEach((field, messages) {
                  if (messages is List) {
                    messages.forEach((message) {
                      errorMessage += '\n$field: $message';
                    });
                  }
                });
              }

              Get.snackbar(
                'Failed',
                errorMessage, // Display actual error message with details
                snackPosition: SnackPosition.TOP, // Moved to top
              );
            }
          } catch (e) {
            setState(() => _isLoading = false);
            Get.snackbar(
              'Failed',
              'All Fields Required',
              snackPosition: SnackPosition.TOP, // Moved to top
            );
          }
        },
        backgroundColor: AppColor.primaryColor,
        child: _isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Updating...',
              style: AppStyle.heading5Medium(color: AppColor.whiteColor),
            ),
          ],
        )
            : Text(
          AppString.updateProfileButton,
          style: AppStyle.heading5Medium(color: AppColor.whiteColor),
        ),
      ).paddingOnly(
        left: AppSize.appSize16,
        right: AppSize.appSize16,
        bottom: AppSize.appSize26,
        top: AppSize.appSize10,
      ),
    );
  }

}
