import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_status_bar.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/activity_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/bottom_bar_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/home_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/activity/activity_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/activity/services_list.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/bottom_bar/bottom_bar_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/property_map_screen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/widget/explore_city_bottom_sheet.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/widget/manage_property_bottom_sheet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/home_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/search/search_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/propertydetails_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/controller/property_details_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';

import '../property_list/property_details_view.dart';



class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController homeController = Get.put(HomeController());
  PropertyDetailsController propertyController = Get.put(PropertyDetailsController());
  ActivityController activityController = Get.put(ActivityController());
  final ScrollController _scrollController = ScrollController();
  final HomeController homeController1 = Get.put(HomeController());
  final List<Map<String, dynamic>> selectedProperties = []; // List to store IDs and Names
  // In HomeController
 // Rx<ApiResponse?> propertyDetails = Rx<ApiResponse?>(null);
  List<bool> isSavedList = [];
  bool isSaved = false;
  RxMap<int, bool> isSavedMap = RxMap<int, bool>();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }


 /* Future<void> fetchPropertyDetails(int propertyId) async {
    print('Fetching details for property ID: $propertyId');  // Debugging print

    // Construct the URL by embedding the propertyId directly into the endpoint
    final String url = 'https://project.artisans.qa/realestate/api/property/$propertyId';

    try {
      // Make the GET request
      final response = await http.get(Uri.parse(url));

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Decoded API Data: $data');
        propertyDetails.value = ApiResponse.fromJson(data);
        print('Property details loaded: ${propertyDetails.value?.property?.title}');
      } else {
        // Handle non-successful status codes (e.g., 404, 500)
        print('Error: API returned status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors (e.g., network errors, timeout, etc.)
      print('Error occurred while fetching property details: $error');
    }
  }*/
  @override
  void initState() {
    super.initState();
    homeController.checkTokenAndFetchProfile();  // Refetch the profile when the screen is loaded again
  }

  @override
  Widget build(BuildContext context) {
    homeController.isTrendPropertyLiked.value = List<bool>.generate(
        homeController.searchImageList.length, (index) => false);
   /* if (isSavedList.length != homeController.featuredProperties.length) {
      isSavedList = List.generate(homeController.featuredProperties.length, (index) => false);
    }*/
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: buildHome(context),
          floatingActionButton: FloatingActionButton(
            onPressed: () async{
              //await homeController.fetchMapData();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PropertyMapScreen(),
                ),
              );
            },
            child: Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            backgroundColor: AppColor.primaryColor,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
        const CommonStatusBar(),
      ],
    );
  }

  String _getPropertyType(int index) {
    switch (index) {
      case 0:
        return 'Apartment';
      case 1:
        return 'Flat';
      case 2:
        return 'Building';
      case 3:
        return 'Duplex House';
      default:
        return 'Property'; // Default fallback text
    }
  }

  Widget buildHome(BuildContext context) {
    int activeIndex = 1;
    var querySize = MediaQuery.of(context).size;



    return SingleChildScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSize.appSize60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        final user = homeController.userProfile.value;
                        final greetingName = user?.name ?? 'Customer'; // Default to 'Francis' if null
                        return Text(
                          'Hi, $greetingName',
                          style: AppStyle.heading5Medium(color: AppColor.descriptionColor),
                        );
                      }),
                      Text(
                        AppString.welcome,
                        style: AppStyle.heading3Medium(
                            color: AppColor.primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.notificationView);
                },
                child: Image.asset(
                  Assets.images.notification.path,
                  width: AppSize.appSize40,
                  height: AppSize.appSize40,
                ),
              )
            ],
          ).paddingOnly(
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.appSize12),
              color: AppColor.whiteColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: AppSize.appSizePoint1,
                  blurRadius: AppSize.appSize2,
                ),
              ],
            ),
            child: TextFormField(
              controller: homeController.searchController,
              cursorColor: AppColor.primaryColor,
              style: AppStyle.heading4Regular(color: AppColor.textColor),
              readOnly: true,
              onTap: () {
                print('Selected Properties: $selectedProperties');

                /*Get.to(
                  SearchView(),
                  arguments: selectedProperties,
                );*/
                // From Home Page
                Get.toNamed(AppRoutes.searchView, arguments: {
                  'selectedProperties': selectedProperties,
                  'source': 'home', // Indicates navigation from home page
                });

// From Map Screen



              },
              decoration: InputDecoration(
                hintText: AppString.searchCity,
                hintStyle:
                    AppStyle.heading4Regular(color: AppColor.descriptionColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    left: AppSize.appSize16,
                    right: AppSize.appSize16,
                  ),
                  child: Image.asset(
                    Assets.images.search.path,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  maxWidth: AppSize.appSize51,
                ),
              ),
            ),
          ).paddingOnly(
            top: AppSize.appSize20,
            left: AppSize.appSize16,
            right: AppSize.appSize16,
          ),
          SizedBox(
            height: querySize.height * 0.02,
          ),
          Column(
            children: [
              Obx(() {
                if (homeController.isLoadingBanner.value) {
                  // Show a loading indicator while fetching the banner data
                  return Center(
                   // child: CircularProgressIndicator(),
                  );
                } else if (homeController.homeBanner.value != null) {
                  // Display the banner data from the API
                  final banner = homeController.homeBanner.value!.banner;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle banner tap (if needed)
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(querySize.height * 0.02),
                          child: Container(
                            width: double.infinity,
                            height: querySize.height * 0.24,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(banner.bgImage), // Use the banner image from the API
                                fit: BoxFit.cover,
                              ),
                            ),
                           /* child: Stack(
                              children: [
                                // Transparent container for the title at top-left
                                Positioned(
                                  top: 16, // Adjust top padding as needed
                                  left: 16, // Adjust left padding as needed
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12, // Horizontal padding
                                      vertical: 4, // Vertical padding
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5), // Transparent black background
                                      borderRadius: BorderRadius.circular(12), // Curved corners (adjust radius as needed)
                                    ),
                                    child: Text(
                                      banner.title, // Use the banner title from the API
                                      style: AppStyle.heading3Medium(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),*/
                          ),
                        ),
                      ),
                      //SizedBox(height: querySize.height * 0.01),
                    ],
                  );
                }else {
                  // Show a fallback message if no banner data is available
                  return Center(
                   // child: Text("No banner data available"),
                  );
                }
              }),
              /*CarouselSlider.builder(
                itemCount: activityController.propertyListImage.length,
                itemBuilder: (context, index, realIndex) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: querySize.width * 0.02),
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(querySize.height * 0.02),
                        child: Container(
                          width: double.infinity,
                          height: querySize.height * 0.24,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                activityController.propertyListImage[index],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                16.0), // Adjust padding as needed
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: querySize.height * 0.05,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: querySize.width * 0.02,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: querySize.width * 0.02,
                                    ),
                                  ],
                                ),
                                // Add other content below the text if needed
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                  viewportFraction: 1,
                  height: querySize.height * 0.24,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                ),
              ),*/
              SizedBox(
                height: querySize.height * 0.01,
              ),
              /*AnimatedSmoothIndicator(
                activeIndex: activeIndex,
                count: homeController.searchImageList.length,
                effect: SlideEffect(
                  dotHeight: querySize.height * 0.008,
                  dotWidth: querySize.width * 0.018,
                  activeDotColor: Colors.amber,
                ),
              ),*/
            ],
          ),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(homeController.countryOptionList.length,
                  (index) {
                return GestureDetector(
                  onTap: () {
                    homeController.updateCountry(index);


                    if (index == AppSize.size2) {
                      _scrollToBottom();
                    }
                    if (index == AppSize.size3) {
                      Get.toNamed(AppRoutes.searchView);
                    }
                  },
                  child: Obx(() => Container(
                        height: AppSize.appSize25,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.appSize14),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: homeController.selectCountry.value == index
                                  ? AppColor.primaryColor
                                  : AppColor.borderColor,
                              width: AppSize.appSize1,
                            ),
                            right: BorderSide(
                              color: index == AppSize.size3
                                  ? Colors.transparent
                                  : AppColor.borderColor,
                              width: AppSize.appSize1,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            homeController.countryOptionList[index],
                            style: AppStyle.heading5Medium(
                              color: homeController.selectCountry.value == index
                                  ? AppColor.primaryColor
                                  : AppColor.textColor,
                            ),
                          ),
                        ),
                      )),
                );
              }),
            ).paddingOnly(top: AppSize.appSize36),
          ),
          SizedBox(
            height: querySize.height * 0.02,
          ),
          Container(
            height: 100,
            child: Obx(() {
              // Using Obx to reactively update the UI when the propertyTypes list changes
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: homeController.propertyTypes.length, // Dynamic item count based on the list length
                itemBuilder: (context, index) {
                  final property = homeController.propertyTypes[index];
                  selectedProperties.add({
                    'type': property.id, // Replace with actual property ID field
                    'name': property.name, // Replace with actual property name field
                  });

                  return GestureDetector(
                    onTap: () async {
                      print('Navigating to property type list view...');
                      Get.toNamed(
                        AppRoutes.propertyTypeListView,
                        arguments: {
                          'propertyTypeId': property.id.toString(), // Pass the property type ID as a String
                          'purpose': homeController.purpose, // Pass the purpose from the HomeController
                        }, // Pass the property type ID as a String
                      );
                      print("id---------${property.id}");
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Circular container with circular image
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[100],
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30), // Half of container width
                              child: property.icon != null && property.icon.isNotEmpty
                                  ? Image.network(
                                "https://project.artisans.qa/realestate/${property.icon}",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, color: Colors.red);
                                },
                              )
                                  : Icon(Icons.error, color: Colors.red), // Error icon for missing/invalid image
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            property.name ?? '', // Display property name from the API
                            style: AppStyle.heading5Medium(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          SizedBox(
            child: Obx(() {
              if (homeController.isLoading.value) {
                // Show the loading indicator while data is being fetched
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if (homeController.featuredProperties.isEmpty) {
                // Show "No Data Available" message when no properties are fetched
                return Padding(
                  padding: EdgeInsets.only(top: 0.0), // Adjust the padding as needed
                  child: Center(

                  ),
                );
              }

              else {
                // Show the list when data is available
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Featured Properties" Text above the list
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSize.appSize12),
                      child: Text(
                        "Featured Properties",
                        style: AppStyle.heading3SemiBold(color: AppColor.textColor),
                      ).paddingOnly(
                        top: AppSize.appSize26,
                        left: AppSize.appSize5,
                        right: AppSize.appSize16,
                      ),
                    ),
                   // Optional: Add some space between title and list
                    GetBuilder<HomeController>(
                    builder: (homeController) {
                      return
                     ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(left: AppSize.appSize12),
                      itemCount: homeController.featuredProperties.length, // Use the dynamic list length
                      itemBuilder: (context, index) {
                        final property = homeController.featuredProperties[index];
                        final isSaved = homeController.isSavedMap[property.id] ?? false;
                        if (!isSavedMap.containsKey(property.id)) {
                          isSavedMap[property.id] = false;
                        }

                        // Access each property
                        return GestureDetector(
                          onTap: () {
                            final int propertyId = property.id;
                            print('Tapped on property with ID: $propertyId');

                            // Simply navigate to a new PropertyDetailsView with the property ID
                            // The new screen will create its own controller with the property ID
                            Get.to(() => PropertyDetailsView(),
                                arguments: propertyId, preventDuplicates: false);
                          },
                         /* onTap: () async {
                            /*final int propertyId = property.id;
                            print('Tapped on property with ID: $propertyId');

                            // Wait for the API call to finish before proceeding
                            await fetchPropertyDetails(propertyId);

                            // Print the property details that will be passed to the next view
                            print('Passing property details: ${propertyDetails.value?.property?.title}');

                            Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyDetails.value);*/
                            final int propertyId = property.id;
                            print('Tapped on property with ID: $propertyId');
                           // await propertyController.fetchPropertyDetails(propertyId); // Fetch details
                            //Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyController.propertyDetails.value);
                            Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyId);




                          },*/
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              width: AppSize.appSize300,
                              padding: const EdgeInsets.all(AppSize.appSize10),
                              margin: const EdgeInsets.only(right: AppSize.appSize16),
                              decoration: BoxDecoration(
                                color: AppColor.secondaryColor,
                                borderRadius: BorderRadius.circular(AppSize.appSize12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Image and like button
                                  Stack(
                                    children: [
                                      Image.network(
                                        property.thumbnailImage, // Load thumbnail from model
                                        height: AppSize.appSize200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        right: AppSize.appSize6,
                                        top: AppSize.appSize6,
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (isSaved) {
                                              await homeController.removeFromWishlist(property.id);
                                            } else {
                                              await homeController.addToWishlist(property.id);
                                            }
                                          },
                                          /*onTap: () async {
                                            // Check for token before proceeding.
                                            final token = await UserTypeManager.getToken();
                                            if (token == null) {
                                              // If no token, prompt the user to log in.
                                              Get.snackbar(
                                                'Login Required',
                                                'Please login to add or remove property from wishlist.',
                                                snackPosition: SnackPosition.TOP,
                                              );
                                              Get.toNamed(AppRoutes.loginView);
                                              return;
                                            }

                                            // Toggle the saved state.
                                            bool newState = !isSavedMap[property.id]!;
                                            setState(() {
                                              isSavedMap[property.id] = newState;
                                            });

                                            final int propertyId = property.id;
                                            if (newState) {
                                              // If saved state is true, call the add-to-wishlist API.
                                              final url = Uri.parse(
                                                'https://project.artisans.qa/realestate/api/user/add-to-wishlist/$propertyId',
                                              );
                                              try {
                                                final response = await http.get(
                                                  url,
                                                  headers: {
                                                    'Authorization': 'Bearer $token',
                                                  },
                                                );
                                                print('Add-to-Wishlist API Response: ${response.body}');
                                                print('Property added to wishlist with ID: $propertyId');
                                              } catch (error) {
                                                print('Error calling add-to-wishlist API: $error');
                                                Get.snackbar(
                                                  'Error',
                                                  'Failed to add property to wishlist.',
                                                  snackPosition: SnackPosition.TOP,
                                                );
                                              }
                                            } else {
                                              // If saved state is false, call the remove-wishlist API.
                                              final url = Uri.parse(
                                                'https://project.artisans.qa/realestate/api/user/remove-wishlist/$propertyId',
                                              );
                                              try {
                                                final response = await http.delete(
                                                  url,
                                                  headers: {
                                                    'Authorization': 'Bearer $token',
                                                  },
                                                );
                                                print('Remove-Wishlist API Response: ${response.body}');
                                                print('Property removed ID: $propertyId');
                                              } catch (error) {
                                                print('Error calling remove-wishlist API: $error');
                                                Get.snackbar(
                                                  'Error',
                                                  'Failed to remove property from wishlist.',
                                                  snackPosition: SnackPosition.TOP,
                                                );
                                              }
                                            }
                                          },*/
                                          child: Container(
                                            width: AppSize.appSize32,
                                            height: AppSize.appSize32,
                                            decoration: BoxDecoration(
                                              color: AppColor.whiteColor.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(AppSize.appSize6),
                                              border: Border.all(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                            ),
                                            child: Obx(() {
                                        final isSaved = homeController.isSavedMap[property.id] ?? false;
                                        return Icon(
                                          isSaved ? Icons.bookmark : Icons
                                              .bookmark_border,
                                          size: AppSize.appSize20,
                                          color: isSaved
                                              ? AppColor.primaryColor
                                              : AppColor.primaryColor
                                              .withOpacity(0.6),
                                        );
                                        }), /*Icon(
                                              isSavedMap[property.id] == true
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_border,
                                              size: AppSize.appSize20,
                                              color: isSavedMap[property.id] == true
                                                  ? AppColor.primaryColor
                                                  : AppColor.primaryColor.withOpacity(0.6),
                                            ),*/
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),
                                  // Title and address
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        property.title, // Title from API
                                        style: AppStyle.heading5SemiBold(color: AppColor.textColor),
                                      ),
                                      SizedBox(height: AppSize.appSize6),
                                      Text(
                                        property.address, // Address from API
                                        style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
                                      ),
                                    ],
                                  ).paddingOnly(top: AppSize.appSize8),
                                  // Price and ratings
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "QAR ${property.price}", // Add "QAR" before the price
                                        style: AppStyle.heading5Medium(color: AppColor.primaryColor),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            property.totalRating != null
                                                ? property.totalRating.toString()
                                                : 'No Rating', // Fallback for null value
                                            style: AppStyle.heading5Medium(color: AppColor.primaryColor),
                                          ),
                                          SizedBox(width: AppSize.appSize6),
                                          Icon(
                                            Icons.star,
                                            color: Color(0xFFFFB84D),
                                            size: AppSize.appSize18,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ).paddingOnly(top: AppSize.appSize6),
                                  Divider(
                                    color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint3),
                                  ),
                                  // Display number of bedrooms, bathrooms, and area (keeping the design same)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Display number of bedrooms
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppSize.appSize6,
                                          horizontal: AppSize.appSize16,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(AppSize.appSize12),
                                          border: Border.all(
                                            color: AppColor.primaryColor,
                                            width: AppSize.appSizePoint50,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.bed,
                                              color: Colors.blueGrey,
                                              size: AppSize.appSize18,
                                            ),
                                            SizedBox(width: AppSize.appSize6),
                                            Text(
                                              '${property.totalBedroom} ',
                                              style: AppStyle.heading5Medium(color: AppColor.textColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Display number of bathrooms
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppSize.appSize6,
                                          horizontal: AppSize.appSize16,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(AppSize.appSize12),
                                          border: Border.all(
                                            color: AppColor.primaryColor,
                                            width: AppSize.appSizePoint50,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.bathtub,
                                              color: Colors.blueGrey,
                                              size: AppSize.appSize18,
                                            ),
                                            SizedBox(width: AppSize.appSize6),
                                            Text(
                                              '${property.totalBathroom} ',
                                              style: AppStyle.heading5Medium(color: AppColor.textColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Display area
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppSize.appSize6,
                                          horizontal: AppSize.appSize16,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(AppSize.appSize12),
                                          border: Border.all(
                                            color: AppColor.primaryColor,
                                            width: AppSize.appSizePoint50,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.area_chart,
                                              color: Colors.blueGrey,
                                              size: AppSize.appSize18,
                                            ),
                                            SizedBox(width: AppSize.appSize6),
                                            Text(
                                              '${property.totalArea} sq/m',
                                              style: AppStyle.heading5Medium(color: AppColor.textColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(top: AppSize.appSize6),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                     );
                    }
                    ).paddingOnly(top: AppSize.appSize16),
                  ],
                );
              }
            }),
          ),
// Check if newProperties is not null and not empty before displaying the section



    SizedBox(
    child: Obx(() {
    if (homeController.isLoading.value) {
    // Show the loading indicator while data is being fetched
    return Center(

    );
    }
    else if (homeController.featuredProperties.isEmpty) {
    // Show "No Data Available" message when no properties are fetched
    return Padding(
    padding: EdgeInsets.only(top: 0.0), // Adjust the padding as needed
    child: Center(

    ),
    );
    }

    else {
      // Show the list when data is available
      return
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align children to the left
            children: [
              if (homeController.newProperties != null &&
                  homeController.newProperties.isNotEmpty)
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align children to the left
                    children: [


                      Text(
                        AppString.newprop,
                        style: AppStyle.heading3SemiBold(
                            color: AppColor.textColor),
                      ).paddingOnly(
                        top: AppSize.appSize26,
                        left: AppSize.appSize16,
                        right: AppSize.appSize16,
                      ),


                      SizedBox(
                        height: AppSize.appSize372,
                        child: GetBuilder<HomeController>(
                            builder: (homeController) {
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    left: AppSize.appSize16),
                                itemCount: homeController.newProperties.length,
                                itemBuilder: (context, index) {
                                  final property = homeController
                                      .newProperties[index];
                                  final isSaved = homeController
                                      .isSavedMap[property.id] ??
                                      false;
                                  if (!isSavedMap.containsKey(property.id)) {
                                    isSavedMap[property.id] = false;
                                  }
                                  return GestureDetector(
                                    onTap: () async {
                                      final int propertyId = property.id;
                                      print(
                                          'Tapped on property with ID: $propertyId');
                                      // await propertyController.fetchPropertyDetails(propertyId); // Fetch details
                                      //Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyController.propertyDetails.value);
                                      Get.toNamed(AppRoutes.propertyDetailsView,
                                          arguments: propertyId);
                                      //Get.toNamed(AppRoutes.propertyDetailsView);
                                    },
                                    child: Container(
                                      width: AppSize.appSize300,
                                      padding: const EdgeInsets.all(
                                          AppSize.appSize10),
                                      margin: const EdgeInsets.only(
                                          right: AppSize.appSize16),
                                      decoration: BoxDecoration(
                                        color: AppColor.secondaryColor,
                                        borderRadius: BorderRadius.circular(
                                            AppSize.appSize12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Stack(
                                            children: [
                                              Image.network(
                                                property.thumbnailImage,
                                                // Load thumbnail from model
                                                height: AppSize.appSize200,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                right: AppSize.appSize6,
                                                top: AppSize.appSize6,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    if (isSaved) {
                                                      await homeController
                                                          .removeFromWishlist(
                                                          property.id);
                                                    } else {
                                                      await homeController
                                                          .addToWishlist(
                                                          property.id);
                                                    }
                                                  },
                                                  child: Container(
                                                    width: AppSize.appSize32,
                                                    height: AppSize.appSize32,
                                                    decoration: BoxDecoration(
                                                      color: AppColor.whiteColor
                                                          .withOpacity(
                                                          0.5),
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          AppSize.appSize6),
                                                      border: Border.all(
                                                        color: Colors
                                                            .transparent,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Obx(() {
                                                      final isSaved = homeController
                                                          .isSavedMap[property
                                                          .id] ?? false;
                                                      return Icon(
                                                        isSaved
                                                            ? Icons.bookmark
                                                            : Icons
                                                            .bookmark_border,
                                                        size: AppSize.appSize20,
                                                        color: isSaved
                                                            ? AppColor
                                                            .primaryColor
                                                            : AppColor
                                                            .primaryColor
                                                            .withOpacity(0.6),
                                                      );
                                                    }),


                                                    /*Icon(
                                    isSavedMap[property.id] == true
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    size: AppSize.appSize20,
                                    color: isSavedMap[property.id] == true
                                        ? AppColor.primaryColor
                                        : AppColor.primaryColor.withOpacity(0.6),
                                  ),*/
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                property.title,
                                                style: AppStyle
                                                    .heading5SemiBold(
                                                    color: AppColor.textColor),
                                              ),
                                              /*Text(
                              property.address,
                              style: AppStyle.heading5Regular(
                                  color: AppColor.descriptionColor),
                            ).paddingOnly(top: AppSize.appSize6),*/
                                            ],
                                          ).paddingOnly(top: AppSize.appSize8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                "QAR ${property.price}",
                                                // Add "QAR" before the price
                                                style: AppStyle.heading5Medium(
                                                    color: AppColor
                                                        .primaryColor),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    property.totalRating != null
                                                        ? property.totalRating
                                                        .toString()
                                                        : 'No Rating',
                                                    // Fallback for null value
                                                    style: AppStyle
                                                        .heading5Medium(
                                                        color: AppColor
                                                            .primaryColor),
                                                  ),
                                                  SizedBox(
                                                      width: AppSize.appSize6),
                                                  Icon(
                                                    Icons.star,
                                                    color: Color(0xFFFFB84D),
                                                    size: AppSize.appSize18,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ).paddingOnly(top: AppSize.appSize6),
                                          Divider(
                                            color: AppColor.descriptionColor
                                                .withOpacity(
                                                AppSize.appSizePoint3),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              // Display number of bedrooms
                                              Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  vertical: AppSize.appSize6,
                                                  horizontal: AppSize.appSize16,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(
                                                      AppSize.appSize12),
                                                  border: Border.all(
                                                    color: AppColor
                                                        .primaryColor,
                                                    width: AppSize
                                                        .appSizePoint50,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.bed,
                                                      color: Colors.blueGrey,
                                                      size: AppSize.appSize18,
                                                    ),
                                                    SizedBox(width: AppSize
                                                        .appSize6),
                                                    Text(
                                                      '${property
                                                          .totalBedroom} ',
                                                      style: AppStyle
                                                          .heading5Medium(
                                                          color: AppColor
                                                              .textColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Display number of bathrooms
                                              Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  vertical: AppSize.appSize6,
                                                  horizontal: AppSize.appSize16,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(
                                                      AppSize.appSize12),
                                                  border: Border.all(
                                                    color: AppColor
                                                        .primaryColor,
                                                    width: AppSize
                                                        .appSizePoint50,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.bathtub,
                                                      color: Colors.blueGrey,
                                                      size: AppSize.appSize18,
                                                    ),
                                                    SizedBox(width: AppSize
                                                        .appSize6),
                                                    Text(
                                                      '${property
                                                          .totalBathroom} ',
                                                      style: AppStyle
                                                          .heading5Medium(
                                                          color: AppColor
                                                              .textColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Display area
                                              Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  vertical: AppSize.appSize6,
                                                  horizontal: AppSize.appSize16,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(
                                                      AppSize.appSize12),
                                                  border: Border.all(
                                                    color: AppColor
                                                        .primaryColor,
                                                    width: AppSize
                                                        .appSizePoint50,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.area_chart,
                                                      color: Colors.blueGrey,
                                                      size: AppSize.appSize18,
                                                    ),
                                                    SizedBox(width: AppSize
                                                        .appSize6),
                                                    Text(
                                                      '${property
                                                          .totalArea} sq/m',
                                                      style: AppStyle
                                                          .heading5Medium(
                                                          color: AppColor
                                                              .textColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ).paddingOnly(top: AppSize.appSize6),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                        ),
                      ).paddingOnly(top: AppSize.appSize16),
                    ]
                )
            ]
        );
    }
    }
    )



    ),


      Obx(() {
        return Column(
          children: [
            // Agents Section
            Row(
              children: [
                Text(
                  "Agents ",
                  style: AppStyle.heading3SemiBold(color: AppColor.textColor),
                ),
                Text(
                  AppString.inWesternMumbai,
                  style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
                ),
              ],
            ).paddingOnly(
              top: AppSize.appSize26,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            SizedBox(
              height: AppSize.appSize95,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(left: AppSize.appSize16),
                itemCount: homeController.agentsList.length,
                itemBuilder: (context, index) {
                  final agent = homeController.agentsList[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.popularBuildersView, arguments: agent);
                    },
                    child: Container(
                      width: AppSize.appSize160,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSize.appSize16,
                        horizontal: AppSize.appSize10,
                      ),
                      margin: const EdgeInsets.only(right: AppSize.appSize16),
                      decoration: BoxDecoration(
                        color: AppColor.secondaryColor,
                        borderRadius: BorderRadius.circular(AppSize.appSize12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: AppSize.appSize20,
                              backgroundColor: AppColor.primaryColor,
                              child: Icon(
                                Icons.contacts_outlined,
                                size: AppSize.appSize24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              agent.name,
                              style: AppStyle.heading5Medium(color: AppColor.textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ).paddingOnly(top: AppSize.appSize16),

            // Upcoming Projects Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppString.upcomingProject,
                  style: AppStyle.heading3SemiBold(color: AppColor.textColor),
                ),
              ],
            ).paddingOnly(
              top: AppSize.appSize26,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
            ),
            SizedBox(
              height: AppSize.appSize200,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(left: AppSize.appSize16),
                scrollDirection: Axis.horizontal,
                itemCount: homeController.serviceTypes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      int serviceId = homeController.serviceTypes[index].id;
                      print('Service ID: $serviceId');
                      await homeController.fetchServiceList(serviceId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServicesList(
                            serviceName: homeController.serviceTypes[index].name,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: AppSize.appSize300,
                          margin: const EdgeInsets.only(right: AppSize.appSize16),
                          padding: const EdgeInsets.all(AppSize.appSize10),
                          decoration: BoxDecoration(
                            color: AppColor.secondaryColor,
                            borderRadius: BorderRadius.circular(AppSize.appSize12),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(homeController.serviceTypes[index].image),
                            ),
                          ),
                        ),
                        Container(
                          width: AppSize.appSize300,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(101, 0, 0, 0),
                            borderRadius: BorderRadius.circular(AppSize.appSize12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: querySize.width * 0.025),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      homeController.serviceTypes[index].name,
                                      style: AppStyle.heading3(color: AppColor.whiteColor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: querySize.height * 0.03,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ).paddingOnly(top: AppSize.appSize16),
          ],
        );
      })
        ],
      ).paddingOnly(top: AppSize.appSize50, bottom: AppSize.appSize20),
    );
  }
}
