import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_button.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/search_filter_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/searchcontentlocation_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/home_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/model/property__model.dart';



class SearchView extends StatelessWidget {
  final String source; // Add this field to store the source

  SearchView({super.key}) : source = Get.arguments?['source'] ?? 'home'; // Default to 'home' if no source is provided
 // String screenName;
  //SearchView({/*required this.screenName,*/super.key});

  SearchFilterController searchFilterController =
      Get.put(SearchFilterController());
  final FocusNode focusNode = FocusNode();
  final RxBool isFocused = false.obs;







  @override
  Widget build(BuildContext context) {
    print('Navigation Stack: ${Get.routing.route}');
    print('Previous Route: ${Get.routing.previous}');



    Future.delayed(Duration(milliseconds: 100), () {
      print('Default selected bedrooms: ${searchFilterController.selectBedrooms}');
      print('Default selected bathrooms: ${searchFilterController.selectbathrooms}');
      if (searchFilterController.selectLookingFor.value == 0) {
        print('Selected Furnishing: Furnished'); // Default selection is Furnished
      } else if (searchFilterController.selectLookingFor.value == 1) {
        print('Selected Furnishing: Semi-furnished');
      } else if (searchFilterController.selectLookingFor.value == 2) {
        print('Selected Furnishing: Unfurnished');
      }
      //print('Default selected aminity: ${searchFilterController.selectedAmenitiesIds}');
    });


    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final List<Map<String, dynamic>> selectedProperties = arguments['selectedProperties'] ?? [];
    //final List<Map<String, dynamic>> selectedProperties =
       // Get.arguments ?? []; // Default to an empty list if no arguments are passed

    // Debugging: Check if arguments are received after a slight delay
    Future.delayed(Duration(milliseconds: 100), () {
      //print('Selected Properties received: $selectedProperties');
      if (selectedProperties.isNotEmpty) {
        selectedProperties.forEach((property) {
          //print('Property Name: ${property['name']}'); // Print the name of each selected property
        });
      } else {
        print('No selected properties found.');
      }
    });

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildSearch(selectedProperties),
      bottomNavigationBar: buildButton(),
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
        AppString.search,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildSearch(List<Map<String, dynamic>> selectedProperties) {
    return Obx(() {
      if (searchFilterController.contentType.value == SearchContentType.searchFilter) {
        return _searchFilterContent(selectedProperties);
      } else {
        return _searchContent(); // Display search content with location suggestions
      }
    });
  }


  Widget buildButton() {
    return Obx(() => Padding(
          padding: const EdgeInsets.only(
            left: AppSize.appSize16,
            right: AppSize.appSize16,
            bottom: AppSize.appSize26,
          ),
          child: searchFilterController.contentType.value ==
                  SearchContentType.search
              ? CommonButton(
                  onPressed: () {
                    searchFilterController
                        .setContent(SearchContentType.searchFilter);
                  },
                  backgroundColor: AppColor.primaryColor,
                  child: Text(
                    AppString.continueButton,
                    style: AppStyle.heading5Medium(color: AppColor.whiteColor),
                  ),
                )

              /*: CommonButton(
                  onPressed: () async{
                    final String locationId = searchFilterController.selectedLocationId.value.toString(); // Convert locationId to String
                    final String tabValue = searchFilterController.selectLookingFor.value == 0
                        ? "rent"
                        : "buy"; // Example logic for tab value
                    final double minBudget = searchFilterController.values.value.start;
                    final double maxBudget = searchFilterController.values.value.end;
                    final double minArea = searchFilterController.values2.value.start;
                    final double maxArea = searchFilterController.values2.value.end;
                    final String propertyTypeId =
                    searchFilterController.selectedPropertyTypeId.value.toString();

                    // Convert Bedroom and Bathroom Lists from List<String> to List<int>
                    final List<int> bedroomList = searchFilterController.selectBedrooms
                        .map((bedroom) => int.tryParse(bedroom) ?? 0) // Convert to int and handle invalid cases
                        .toList();
                    final List<int> bathroomList = searchFilterController.selectbathrooms
                        .map((bathroom) => int.tryParse(bathroom) ?? 0) // Convert to int and handle invalid cases
                        .toList();

                    // Convert amenitiesList from List<int> to List<String> as required by the API
                    final List<String> amenitiesList = searchFilterController.selectedAmenitiesIds
                        .map((amenityId) => amenityId.toString()) // Convert each int to string
                        .toList();

                    final String furnishingValue = searchFilterController.selectLookingFor.value == 0
                        ? "furnished"
                        : searchFilterController.selectLookingFor.value == 1
                        ? "semi-furnished"
                        : "unfurnished";

                    // Call fetchProperties with dynamic values, including location ID
                    await searchFilterController.fetchProperties(
                      locationId: locationId,
                      tabValue: tabValue,
                      minBudget: minBudget,
                      maxBudget: maxBudget,
                      minArea: minArea,
                      maxArea: maxArea,
                      propertyTypeId: propertyTypeId,
                      bedroomList: bedroomList,
                      bathroomList: bathroomList,
                      amenitiesList: amenitiesList, // Pass List<String> to the API
                      furnishingValue: furnishingValue,
                    );
                    print("see all");
                    Get.toNamed(AppRoutes.propertyListView);
                  },

                  backgroundColor: AppColor.primaryColor,
                  child: Text(
                    AppString.seeall,
                    style: AppStyle.heading5Medium(color: AppColor.whiteColor),
                  ),
                ),*/



              : CommonButton(
            onPressed: () async {
              final String tabValue = searchFilterController.selectLookingFor.value == 0
                  ? "rent"
                  : "sale"; // Example logic for tab value
              final String locationId = searchFilterController.selectedLocationId.value.toString();
              final double minBudget = searchFilterController.values.value.start;
              final double maxBudget = searchFilterController.values.value.end;
              final double minArea = searchFilterController.values2.value.start;
              final double maxArea = searchFilterController.values2.value.end;
              final String propertyTypeId =
              searchFilterController.selectedPropertyTypeId.value.toString();
              final String furnishingValue = searchFilterController.selectLookingFor.value == 0
                  ? "furnished"
                  : searchFilterController.selectLookingFor.value == 1
                  ? "semi-furnished"
                  : "unfurnished";


              // Convert Bedroom and Bathroom Lists from List<String> to List<int>
              final List<int> bedroomList = searchFilterController.selectBedrooms
                  .map((bedroom) => int.tryParse(bedroom) ?? 0) // Convert to int and handle invalid cases
                  .toList();

              final List<int> bathroomList = searchFilterController.selectbathrooms
                  .map((bathroom) => int.tryParse(bathroom) ?? 0)
                  .toList();

              final List<int> amenitiesList = searchFilterController.selectedAmenitiesIds;
              print("Tab Value sent to API: $tabValue");
              // Call fetchProperties with dynamic values, including location ID
              final PropertyResponse? response = await searchFilterController.fetchProperties(
                tabValue: tabValue,
                bedroomList: bedroomList,

                locationId:locationId,
                minBudget:minBudget,
                 maxBudget:maxBudget,
                minArea:  minArea,
               maxArea: maxArea,
                propertyTypeId: propertyTypeId,
                 furnishingValue: furnishingValue,
                bathroomList: bathroomList, // Pass bathrooms
                amenitiesList: amenitiesList, // Pass amenities



              );
                  if (response != null) {
                     if (source == 'home') {
                       Get.toNamed(
                       AppRoutes.propertyListView,
                       arguments: response,
                           );
                      } else if (source == 'map') {
    // Navigate to the PropertyMapScreen with the fetched data
                              Get.toNamed(
                             AppRoutes.map,
                             arguments: response, // Pass the fetched property data
                                  );
                                   }
                                } else {
                              print("Failed to fetch properties");
                                  }
                               },
              /*if (response != null) {
                print("API data fetched successfully");
                if (source == 'home') {
                    Get.toNamed(
                   AppRoutes.propertyListView,
                   arguments: response,
                        );
                } else if (source == 'map') {
                    Get.back(); // Navigate back to the map screen
                             }

                // Navigate to the propertyListView, passing the response directly
               /* Get.toNamed(
                  AppRoutes.propertyListView,
                  arguments: response,  // Pass the response as an argument
                );*/
              } else {
                print("Failed to fetch properties");
              }*/

            backgroundColor: AppColor.primaryColor,
            child: Text(
              AppString.seeall,
              style: AppStyle.heading5Medium(color: AppColor.whiteColor),
            ),
          ),

    ));
  }

  Widget _searchFilterContent(List<Map<String, dynamic>> selectedProperties) {

    String initialTabName = searchFilterController.propertyList[0];
    print("Initial Tab: $initialTabName");

    return DefaultTabController(
      length: searchFilterController.propertyList.length,
      initialIndex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TabBar for navigation
          TabBar(
            onTap: (index) {
              String selectedTabName = searchFilterController.propertyList[index];
              print("Selected Tab: $selectedTabName");

              // Update selectLookingFor based on the tab index
              searchFilterController.selectLookingFor.value = index == 0 ? 0 : 1;  // 0 for rent, 1 for buy

              // Now update the property as per the selected tab
              searchFilterController.updateProperty(index);

            },
            indicatorColor: AppColor.primaryColor,
            labelColor: AppColor.primaryColor,
            unselectedLabelColor: AppColor.textColor,
            tabs: List.generate(
              searchFilterController.propertyList.length,
                  (index) => Tab(
                child: Text(
                  searchFilterController.propertyList[index],
                  style: AppStyle.heading5Medium(
                    color: searchFilterController.selectProperty.value == index
                        ? AppColor.primaryColor
                        : AppColor.textColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            // TabBarView with separate content for each tab
            child: TabBarView(
              children: List.generate(
                searchFilterController.propertyList.length,
                    (index) {
                  // Display unique content based on the tab index
                  if (index == 0) {
                    return ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
                      children: [
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
                            controller: searchFilterController.searchController,
                            cursorColor: AppColor.primaryColor,
                            style: AppStyle.heading4Regular(color: AppColor.textColor),
                            readOnly: true,
                            onTap: () {
                              searchFilterController.setContent(SearchContentType.search);
                            },
                            decoration: InputDecoration(
                              hintText: AppString.searchCity,
                              hintStyle: AppStyle.heading4Regular(
                                  color: AppColor.descriptionColor),
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
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),

                        Text(
                          AppString.budget,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        Theme(
                          data: ThemeData(
                            sliderTheme: SliderThemeData(
                              activeTrackColor: AppColor.primaryColor,
                              disabledActiveTrackColor: AppColor.secondaryColor,
                              inactiveTrackColor: AppColor.secondaryColor,
                              overlayShape: SliderComponentShape.noOverlay,
                              trackHeight: AppSize.appSize3,
                              thumbColor: AppColor.primaryColor,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: AppSize.appSize3,
                                disabledThumbRadius: AppSize.appSize3,
                              ),
                            ),
                          ),
                          child: Obx(() => RangeSlider(
                            values: searchFilterController.values.value,
                            min: AppSize.appSize50,
                            max: AppSize.appSize500,
                            onChanged: (value) {
                              searchFilterController.updateValues(value);
                            },
                          )),
                        ).paddingOnly(
                          top: AppSize.appSize20,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: AppSize.appSize37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: AppColor.descriptionColor,
                                    width: AppSize.appSizePoint7,
                                  ),
                                ),
                                child: Center(
                                  child: Obx(() => Text(
                                    searchFilterController.startValueText,
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.textColor),
                                  )),
                                ),
                              ),
                            ),
                            Text(
                              AppString.toText,
                              style: AppStyle.heading5Medium(color: AppColor.textColor),
                            ).paddingSymmetric(horizontal: AppSize.appSize26),
                            Expanded(
                              child: Container(
                                height: AppSize.appSize37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: AppColor.descriptionColor,
                                    width: AppSize.appSizePoint7,
                                  ),
                                ),
                                child: Center(
                                  child: Obx(() => Text(
                                    searchFilterController.endValueText,
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.textColor),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ).paddingOnly(
                          top: AppSize.appSize18,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),

                        //area
                        Text(
                          AppString.area, // Update with appropriate string identifier
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),

                        Theme(
                          data: ThemeData(
                            sliderTheme: SliderThemeData(
                              activeTrackColor: AppColor.primaryColor,
                              disabledActiveTrackColor: AppColor.secondaryColor,
                              inactiveTrackColor: AppColor.secondaryColor,
                              overlayShape: SliderComponentShape.noOverlay,
                              trackHeight: AppSize.appSize3,
                              thumbColor: AppColor.primaryColor,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: AppSize.appSize3,
                                disabledThumbRadius: AppSize.appSize3,
                              ),
                            ),
                          ),
                          child: Obx(() => RangeSlider(
                            values: searchFilterController.values2.value,
                            min: AppSize.appSize50,
                            max: AppSize.appSize501,
                            onChanged: (value) {
                              searchFilterController.updateValues2(value);
                            },
                          )),
                        ).paddingOnly(
                          top: AppSize.appSize20,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),

// Second Slider Values Display
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: AppSize.appSize37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: AppColor.descriptionColor,
                                    width: AppSize.appSizePoint7,
                                  ),
                                ),
                                child: Center(
                                  child: Obx(() => Text(
                                    searchFilterController.startValueText2,
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.textColor),
                                  )),
                                ),
                              ),
                            ),
                            Text(
                              AppString.toText,
                              style: AppStyle.heading5Medium(color: AppColor.textColor),
                            ).paddingSymmetric(horizontal: AppSize.appSize26),
                            Expanded(
                              child: Container(
                                height: AppSize.appSize37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: AppColor.descriptionColor,
                                    width: AppSize.appSizePoint7,
                                  ),
                                ),
                                child: Center(
                                  child: Obx(() => Text(
                                    searchFilterController.endValueText2,
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.textColor),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ).paddingOnly(
                          top: AppSize.appSize18,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),










                        Text(
                          AppString.typesOfProperty,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            searchFilterController.propertyTypes.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                // Update the property type using the selected property
                                searchFilterController.updateTypesOfProperty(index);

                              },
                              child: Obx(() => Container(
                                  margin: const EdgeInsets.only(bottom: AppSize.appSize6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.appSize16,
                                    vertical: AppSize.appSize10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppSize.appSize12),
                                    border: Border.all(
                                      color: searchFilterController
                                          .selectTypesOfProperty.value ==
                                          index
                                          ? AppColor.primaryColor
                                          : AppColor.borderColor,
                                      width: AppSize.appSize1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min, // Ensures that the row only takes up the space required
                                    children: [
                                      Icon(
                                        Icons.add, // Plus icon
                                        size: 16, // Adjust the size of the icon as needed
                                        color: searchFilterController.selectTypesOfProperty.value == index
                                            ? AppColor.primaryColor
                                            : AppColor.descriptionColor,
                                      ),
                                      SizedBox(width: 4), // Adjust the spacing between the icon and the text
                                      Text(
                                        searchFilterController.propertyTypes[index].name, // Use the property name from selectedProperties
                                        style: AppStyle.heading5Medium(
                                          color: searchFilterController.selectTypesOfProperty.value == index
                                              ? AppColor.primaryColor
                                              : AppColor.descriptionColor,
                                        ),
                                      ),
                                    ],
                                  )

                              )),
                            );
                          },
                          ),
                        ).paddingOnly(
                          top: AppSize.appSize16,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        // Text(
                        //   AppString.viewAllAdd,
                        //   style: AppStyle.heading6Medium(
                        //     color: AppColor.primaryColor,
                        //   ),
                        // )
                        //
                        // .paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
                        Text(
                          AppString.noOfBedrooms,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: AppSize.appSize16),
                          child: Row(
                            children: List.generate(
                                searchFilterController.bedroomsList.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  // Update with actual bedroom value (not index)
                                  searchFilterController.updateBedrooms(index);
                                },
                                child: Obx(() => Container(
                                  margin: const EdgeInsets.only(right: AppSize.appSize16),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.appSize16,
                                    vertical: AppSize.appSize10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppSize.appSize12),
                                    border: Border.all(
                                      color: searchFilterController.selectBedrooms.contains(searchFilterController.bedroomsList[index])
                                          ? AppColor.primaryColor // Change border color when selected
                                          : AppColor.borderColor,
                                      width: AppSize.appSize1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      searchFilterController.bedroomsList[index],
                                      style: AppStyle.heading5Medium(
                                        color: searchFilterController.selectBedrooms.contains(searchFilterController.bedroomsList[index])
                                            ? AppColor.primaryColor // Change text color when selected
                                            : AppColor.descriptionColor,
                                      ),
                                    ),
                                  ),
                                )),
                              );
                            }
                            ),
                          ).paddingOnly(top: AppSize.appSize16),
                        ),


                        Text(
                          AppString.noOfBathrooms,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: AppSize.appSize16),
                          child: Row(
                            children: List.generate(
                              searchFilterController.bathroomList.length,
                                  (index) {
                                return GestureDetector(
                                  onTap: () {
                                    searchFilterController.updateBathrooms(index); // Update selection
                                  },
                                  child: Obx(() => Container(
                                    margin: const EdgeInsets.only(right: AppSize.appSize16),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.appSize16,
                                      vertical: AppSize.appSize10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                                      border: Border.all(
                                        color: searchFilterController.selectbathrooms.contains(
                                            searchFilterController.bathroomList[index])
                                            ? AppColor.primaryColor
                                            : AppColor.borderColor,
                                        width: AppSize.appSize1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        searchFilterController.bathroomList[index],
                                        style: AppStyle.heading5Medium(
                                          color: searchFilterController.selectbathrooms.contains(
                                              searchFilterController.bathroomList[index])
                                              ? AppColor.primaryColor
                                              : AppColor.descriptionColor,
                                        ),
                                      ),
                                    ),
                                  )),
                                );
                              },
                            ),
                          ).paddingOnly(top: AppSize.appSize16),
                        ),

                        Text(
                          AppString.amenities,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: AppSize.appSize16),
                          child: Row(
                            children: List.generate(
                              searchFilterController.amenities.length,
                                  (index) {
                                return GestureDetector(
                                  onTap: () {
                                    searchFilterController.updateAmenities(index);
                                  },
                                  child: Obx(() => Container(
                                    margin: const EdgeInsets.only(right: AppSize.appSize16),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.appSize16,
                                      vertical: AppSize.appSize10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                                      border: Border.all(
                                        color: searchFilterController.selectedAmenitiesIds.contains(
                                            searchFilterController.amenities[index].id)
                                            ? AppColor.primaryColor
                                            : AppColor.borderColor,
                                        width: AppSize.appSize1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        searchFilterController.amenities[index].aminity,
                                        style: AppStyle.heading5Medium(
                                          color: searchFilterController.selectedAmenitiesIds.contains(
                                              searchFilterController.amenities[index].id)
                                              ? AppColor.primaryColor
                                              : AppColor.descriptionColor,
                                        ),
                                      ),
                                    ),
                                  )),
                                );
                              },
                            ),
                          ).paddingOnly(top: AppSize.appSize16),
                        ),



                        Text(
                          AppString.lookingForReadyToMove,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                searchFilterController.updateLookingFor(0); // Furnished
                                print('Selected: Furnished'); // Print selected item
                              },
                              child: Obx(() => Container(
                                width: AppSize.appSize100,
                                margin: const EdgeInsets.only(right: AppSize.appSize16),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSize.appSize10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: searchFilterController.selectLookingFor.value == 0
                                        ? AppColor.primaryColor
                                        : AppColor.borderColor,
                                    width: AppSize.appSize1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Furnished',
                                    style: AppStyle.heading6Medium(
                                      color: searchFilterController.selectLookingFor.value == 0
                                          ? AppColor.primaryColor
                                          : AppColor.descriptionColor,
                                    ),
                                  ),
                                ),
                              )),
                            ),
                            GestureDetector(
                              onTap: () {
                                searchFilterController.updateLookingFor(1); // Semi-furnished
                                print('Selected: Semi-furnished'); // Print selected item
                              },
                              child: Obx(() => Container(
                                width: AppSize.appSize100,
                                margin: const EdgeInsets.only(right: AppSize.appSize16),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSize.appSize10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: searchFilterController.selectLookingFor.value == 1
                                        ? AppColor.primaryColor
                                        : AppColor.borderColor,
                                    width: AppSize.appSize1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Semi-furnished',
                                    style: AppStyle.heading6Medium(
                                      color: searchFilterController.selectLookingFor.value == 1
                                          ? AppColor.primaryColor
                                          : AppColor.descriptionColor,
                                    ),
                                  ),
                                ),
                              )),
                            ),
                            GestureDetector(
                              onTap: () {
                                searchFilterController.updateLookingFor(2); // Unfurnished
                                print('Selected: Unfurnished'); // Print selected item
                              },
                              child: Obx(() => Container(
                                width: AppSize.appSize100,
                                margin: const EdgeInsets.only(right: AppSize.appSize16),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSize.appSize10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: searchFilterController.selectLookingFor.value == 2
                                        ? AppColor.primaryColor
                                        : AppColor.borderColor,
                                    width: AppSize.appSize1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Unfurnished',
                                    style: AppStyle.heading6Medium(
                                      color: searchFilterController.selectLookingFor.value == 2
                                          ? AppColor.primaryColor
                                          : AppColor.descriptionColor,
                                    ),
                                  ),
                                ),
                              )),
                            ),
                          ],
                        )
                            .paddingOnly(
                          top: AppSize.appSize16,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                      ],
                    );
                  } else if (index == 1) {
                    return ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
                      children: [
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
                            controller: searchFilterController.searchController,
                            cursorColor: AppColor.primaryColor,
                            style: AppStyle.heading4Regular(color: AppColor.textColor),
                            readOnly: true,
                            onTap: () {
                              searchFilterController.setContent(SearchContentType.search);
                            },
                            decoration: InputDecoration(
                              hintText: AppString.searchCity,
                              hintStyle: AppStyle.heading4Regular(
                                  color: AppColor.descriptionColor),
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
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),

                        Text(
                          AppString.budget,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        Theme(
                          data: ThemeData(
                            sliderTheme: SliderThemeData(
                              activeTrackColor: AppColor.primaryColor,
                              disabledActiveTrackColor: AppColor.secondaryColor,
                              inactiveTrackColor: AppColor.secondaryColor,
                              overlayShape: SliderComponentShape.noOverlay,
                              trackHeight: AppSize.appSize3,
                              thumbColor: AppColor.primaryColor,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: AppSize.appSize3,
                                disabledThumbRadius: AppSize.appSize3,
                              ),
                            ),
                          ),
                          child: Obx(() => RangeSlider(
                            values: searchFilterController.values1.value,
                            min: AppSize.appSize50,
                            max: AppSize.appSize500,
                            onChanged: (value) {
                              searchFilterController.updateValues1(value);
                            },
                          )),
                        ).paddingOnly(
                          top: AppSize.appSize20,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: AppSize.appSize37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: AppColor.descriptionColor,
                                    width: AppSize.appSizePoint7,
                                  ),
                                ),
                                child: Center(
                                  child: Obx(() => Text(
                                    searchFilterController.startValueText1,
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.textColor),
                                  )),
                                ),
                              ),
                            ),
                            Text(
                              AppString.toText,
                              style: AppStyle.heading5Medium(color: AppColor.textColor),
                            ).paddingSymmetric(horizontal: AppSize.appSize26),
                            Expanded(
                              child: Container(
                                height: AppSize.appSize37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: AppColor.descriptionColor,
                                    width: AppSize.appSizePoint7,
                                  ),
                                ),
                                child: Center(
                                  child: Obx(() => Text(
                                    searchFilterController.endValueText1,
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.textColor),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ).paddingOnly(
                          top: AppSize.appSize18,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),

                        //area
                        Text(
                          AppString.area, // Update with appropriate string identifier
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),

                        Theme(
                          data: ThemeData(
                            sliderTheme: SliderThemeData(
                              activeTrackColor: AppColor.primaryColor,
                              disabledActiveTrackColor: AppColor.secondaryColor,
                              inactiveTrackColor: AppColor.secondaryColor,
                              overlayShape: SliderComponentShape.noOverlay,
                              trackHeight: AppSize.appSize3,
                              thumbColor: AppColor.primaryColor,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: AppSize.appSize3,
                                disabledThumbRadius: AppSize.appSize3,
                              ),
                            ),
                          ),
                          child: Obx(() => RangeSlider(
                            values: searchFilterController.values2.value,
                            min: AppSize.appSize50,
                            max: AppSize.appSize501,
                            onChanged: (value) {
                              searchFilterController.updateValues2(value);
                            },
                          )),
                        ).paddingOnly(
                          top: AppSize.appSize20,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),

// Second Slider Values Display
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: AppSize.appSize37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: AppColor.descriptionColor,
                                    width: AppSize.appSizePoint7,
                                  ),
                                ),
                                child: Center(
                                  child: Obx(() => Text(
                                    searchFilterController.startValueText2,
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.textColor),
                                  )),
                                ),
                              ),
                            ),
                            Text(
                              AppString.toText,
                              style: AppStyle.heading5Medium(color: AppColor.textColor),
                            ).paddingSymmetric(horizontal: AppSize.appSize26),
                            Expanded(
                              child: Container(
                                height: AppSize.appSize37,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: AppColor.descriptionColor,
                                    width: AppSize.appSizePoint7,
                                  ),
                                ),
                                child: Center(
                                  child: Obx(() => Text(
                                    searchFilterController.endValueText2,
                                    style: AppStyle.heading5Medium(
                                        color: AppColor.textColor),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ).paddingOnly(
                          top: AppSize.appSize18,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),










                        Text(
                          AppString.typesOfProperty,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            searchFilterController.propertyTypes.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                // Update the property type using the selected property
                                searchFilterController.updateTypesOfProperty(index);

                              },
                              child: Obx(() => Container(
                                  margin: const EdgeInsets.only(bottom: AppSize.appSize6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.appSize16,
                                    vertical: AppSize.appSize10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppSize.appSize12),
                                    border: Border.all(
                                      color: searchFilterController
                                          .selectTypesOfProperty.value ==
                                          index
                                          ? AppColor.primaryColor
                                          : AppColor.borderColor,
                                      width: AppSize.appSize1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min, // Ensures that the row only takes up the space required
                                    children: [
                                      Icon(
                                        Icons.add, // Plus icon
                                        size: 16, // Adjust the size of the icon as needed
                                        color: searchFilterController.selectTypesOfProperty.value == index
                                            ? AppColor.primaryColor
                                            : AppColor.descriptionColor,
                                      ),
                                      SizedBox(width: 4), // Adjust the spacing between the icon and the text
                                      Text(
                                        searchFilterController.propertyTypes[index].name, // Use the property name from selectedProperties
                                        style: AppStyle.heading5Medium(
                                          color: searchFilterController.selectTypesOfProperty.value == index
                                              ? AppColor.primaryColor
                                              : AppColor.descriptionColor,
                                        ),
                                      ),
                                    ],
                                  )

                              )),
                            );
                          },
                          ),
                        ).paddingOnly(
                          top: AppSize.appSize16,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        // Text(
                        //   AppString.viewAllAdd,
                        //   style: AppStyle.heading6Medium(
                        //     color: AppColor.primaryColor,
                        //   ),
                        // )
                        //
                        // .paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
                        Text(
                          AppString.noOfBedrooms,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: AppSize.appSize16),
                          child: Row(
                            children: List.generate(
                                searchFilterController.bedroomsList.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  // Update with actual bedroom value (not index)
                                  searchFilterController.updateBedrooms(index);
                                },
                                child: Obx(() => Container(
                                  margin: const EdgeInsets.only(right: AppSize.appSize16),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.appSize16,
                                    vertical: AppSize.appSize10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppSize.appSize12),
                                    border: Border.all(
                                      color: searchFilterController.selectBedrooms.contains(searchFilterController.bedroomsList[index])
                                          ? AppColor.primaryColor // Change border color when selected
                                          : AppColor.borderColor,
                                      width: AppSize.appSize1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      searchFilterController.bedroomsList[index],
                                      style: AppStyle.heading5Medium(
                                        color: searchFilterController.selectBedrooms.contains(searchFilterController.bedroomsList[index])
                                            ? AppColor.primaryColor // Change text color when selected
                                            : AppColor.descriptionColor,
                                      ),
                                    ),
                                  ),
                                )),
                              );
                            }
                            ),
                          ).paddingOnly(top: AppSize.appSize16),
                        ),


                        Text(
                          AppString.noOfBathrooms,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: AppSize.appSize16),
                          child: Row(
                            children: List.generate(
                              searchFilterController.bathroomList.length,
                                  (index) {
                                return GestureDetector(
                                  onTap: () {
                                    searchFilterController.updateBathrooms(index); // Update selection
                                  },
                                  child: Obx(() => Container(
                                    margin: const EdgeInsets.only(right: AppSize.appSize16),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.appSize16,
                                      vertical: AppSize.appSize10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                                      border: Border.all(
                                        color: searchFilterController.selectbathrooms.contains(
                                            searchFilterController.bathroomList[index])
                                            ? AppColor.primaryColor
                                            : AppColor.borderColor,
                                        width: AppSize.appSize1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        searchFilterController.bathroomList[index],
                                        style: AppStyle.heading5Medium(
                                          color: searchFilterController.selectbathrooms.contains(
                                              searchFilterController.bathroomList[index])
                                              ? AppColor.primaryColor
                                              : AppColor.descriptionColor,
                                        ),
                                      ),
                                    ),
                                  )),
                                );
                              },
                            ),
                          ).paddingOnly(top: AppSize.appSize16),
                        ),

                        Text(
                          AppString.amenities,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: AppSize.appSize16),
                          child: Row(
                            children: List.generate(
                              searchFilterController.amenities.length,
                                  (index) {
                                return GestureDetector(
                                  onTap: () {
                                    searchFilterController.updateAmenities(index);
                                  },
                                  child: Obx(() => Container(
                                    margin: const EdgeInsets.only(right: AppSize.appSize16),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.appSize16,
                                      vertical: AppSize.appSize10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppSize.appSize12),
                                      border: Border.all(
                                        color: searchFilterController.selectedAmenitiesIds.contains(
                                            searchFilterController.amenities[index].id)
                                            ? AppColor.primaryColor
                                            : AppColor.borderColor,
                                        width: AppSize.appSize1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        searchFilterController.amenities[index].aminity,
                                        style: AppStyle.heading5Medium(
                                          color: searchFilterController.selectedAmenitiesIds.contains(
                                              searchFilterController.amenities[index].id)
                                              ? AppColor.primaryColor
                                              : AppColor.descriptionColor,
                                        ),
                                      ),
                                    ),
                                  )),
                                );
                              },
                            ),
                          ).paddingOnly(top: AppSize.appSize16),
                        ),



                        Text(
                          AppString.lookingForReadyToMove,
                          style: AppStyle.heading4Medium(color: AppColor.textColor),
                        ).paddingOnly(
                          top: AppSize.appSize26,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                searchFilterController.updateLookingFor(0); // Furnished
                                print('Selected: Furnished'); // Print selected item
                              },
                              child: Obx(() => Container(
                                width: AppSize.appSize100,
                                margin: const EdgeInsets.only(right: AppSize.appSize16),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSize.appSize10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: searchFilterController.selectLookingFor.value == 0
                                        ? AppColor.primaryColor
                                        : AppColor.borderColor,
                                    width: AppSize.appSize1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Furnished',
                                    style: AppStyle.heading6Medium(
                                      color: searchFilterController.selectLookingFor.value == 0
                                          ? AppColor.primaryColor
                                          : AppColor.descriptionColor,
                                    ),
                                  ),
                                ),
                              )),
                            ),
                            GestureDetector(
                              onTap: () {
                                searchFilterController.updateLookingFor(1); // Semi-furnished
                                print('Selected: Semi-furnished'); // Print selected item
                              },
                              child: Obx(() => Container(
                                width: AppSize.appSize100,
                                margin: const EdgeInsets.only(right: AppSize.appSize16),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSize.appSize10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: searchFilterController.selectLookingFor.value == 1
                                        ? AppColor.primaryColor
                                        : AppColor.borderColor,
                                    width: AppSize.appSize1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Semi-furnished',
                                    style: AppStyle.heading6Medium(
                                      color: searchFilterController.selectLookingFor.value == 1
                                          ? AppColor.primaryColor
                                          : AppColor.descriptionColor,
                                    ),
                                  ),
                                ),
                              )),
                            ),
                            GestureDetector(
                              onTap: () {
                                searchFilterController.updateLookingFor(2); // Unfurnished
                                print('Selected: Unfurnished'); // Print selected item
                              },
                              child: Obx(() => Container(
                                width: AppSize.appSize100,
                                margin: const EdgeInsets.only(right: AppSize.appSize16),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSize.appSize10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                                  border: Border.all(
                                    color: searchFilterController.selectLookingFor.value == 2
                                        ? AppColor.primaryColor
                                        : AppColor.borderColor,
                                    width: AppSize.appSize1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Unfurnished',
                                    style: AppStyle.heading6Medium(
                                      color: searchFilterController.selectLookingFor.value == 2
                                          ? AppColor.primaryColor
                                          : AppColor.descriptionColor,
                                    ),
                                  ),
                                ),
                              )),
                            ),
                          ],
                        )
                            .paddingOnly(
                          top: AppSize.appSize16,
                          left: AppSize.appSize16,
                          right: AppSize.appSize16,
                        ),
                      ],
                    );
                  } else {
                    return ListView(
                      padding: const EdgeInsets.all(AppSize.appSize16),
                      children: [
                        Text(
                          "Tab ${index + 1}: Other Content",
                          style: AppStyle.heading5Medium(color: AppColor.textColor),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  /* _searchFilterContent(selectedProperties) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: List.generate(searchFilterController.propertyList.length,
              (index) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  searchFilterController.updateProperty(index);
                  print("hello");
                },
                child: Obx(() => Container(
                      height: AppSize.appSize25,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.appSize14),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                searchFilterController.selectProperty.value ==
                                        index
                                    ? AppColor.primaryColor
                                    : AppColor.borderColor,
                            width: AppSize.appSize1,
                          ),
                          right: BorderSide(
                            color: index == AppSize.size1
                                ? Colors.transparent
                                : AppColor.borderColor,
                            width: AppSize.appSize1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          searchFilterController.propertyList[index],
                          style: AppStyle.heading5Medium(
                            color:
                                searchFilterController.selectProperty.value ==
                                        index
                                    ? AppColor.primaryColor
                                    : AppColor.textColor,
                          ),
                        ),
                      ),
                    )),
              ),
            );
          }),
        ).paddingOnly(
          top: AppSize.appSize10,
          left: AppSize.appSize16,
          right: AppSize.appSize16,
        ),
        Expanded(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSize.appSize20),
            children: [
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
                  controller: searchFilterController.searchController,
                  cursorColor: AppColor.primaryColor,
                  style: AppStyle.heading4Regular(color: AppColor.textColor),
                  readOnly: true,
                  onTap: () {
                    searchFilterController.setContent(SearchContentType.search);
                  },
                  decoration: InputDecoration(
                    hintText: AppString.searchCity,
                    hintStyle: AppStyle.heading4Regular(
                        color: AppColor.descriptionColor),
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
                top: AppSize.appSize26,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),

              Text(
                AppString.budget,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize26,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Theme(
                data: ThemeData(
                  sliderTheme: SliderThemeData(
                    activeTrackColor: AppColor.primaryColor,
                    disabledActiveTrackColor: AppColor.secondaryColor,
                    inactiveTrackColor: AppColor.secondaryColor,
                    overlayShape: SliderComponentShape.noOverlay,
                    trackHeight: AppSize.appSize3,
                    thumbColor: AppColor.primaryColor,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: AppSize.appSize3,
                      disabledThumbRadius: AppSize.appSize3,
                    ),
                  ),
                ),
                child: Obx(() => RangeSlider(
                      values: searchFilterController.values.value,
                      min: AppSize.appSize50,
                      max: AppSize.appSize500,
                      onChanged: (value) {
                        searchFilterController.updateValues(value);
                      },
                    )),
              ).paddingOnly(
                top: AppSize.appSize20,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: AppSize.appSize37,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.appSize12),
                        border: Border.all(
                          color: AppColor.descriptionColor,
                          width: AppSize.appSizePoint7,
                        ),
                      ),
                      child: Center(
                        child: Obx(() => Text(
                              searchFilterController.startValueText,
                              style: AppStyle.heading5Medium(
                                  color: AppColor.textColor),
                            )),
                      ),
                    ),
                  ),
                  Text(
                    AppString.toText,
                    style: AppStyle.heading5Medium(color: AppColor.textColor),
                  ).paddingSymmetric(horizontal: AppSize.appSize26),
                  Expanded(
                    child: Container(
                      height: AppSize.appSize37,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.appSize12),
                        border: Border.all(
                          color: AppColor.descriptionColor,
                          width: AppSize.appSizePoint7,
                        ),
                      ),
                      child: Center(
                        child: Obx(() => Text(
                              searchFilterController.endValueText,
                              style: AppStyle.heading5Medium(
                                  color: AppColor.textColor),
                            )),
                      ),
                    ),
                  ),
                ],
              ).paddingOnly(
                top: AppSize.appSize18,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),

              //area
              Text(
                AppString.area, // Update with appropriate string identifier
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize26,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),

              Theme(
                data: ThemeData(
                  sliderTheme: SliderThemeData(
                    activeTrackColor: AppColor.primaryColor,
                    disabledActiveTrackColor: AppColor.secondaryColor,
                    inactiveTrackColor: AppColor.secondaryColor,
                    overlayShape: SliderComponentShape.noOverlay,
                    trackHeight: AppSize.appSize3,
                    thumbColor: AppColor.primaryColor,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: AppSize.appSize3,
                      disabledThumbRadius: AppSize.appSize3,
                    ),
                  ),
                ),
                child: Obx(() => RangeSlider(
                  values: searchFilterController.values2.value,
                  min: AppSize.appSize50,
                  max: AppSize.appSize500,
                  onChanged: (value) {
                    searchFilterController.updateValues2(value);
                  },
                )),
              ).paddingOnly(
                top: AppSize.appSize20,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),

// Second Slider Values Display
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: AppSize.appSize37,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.appSize12),
                        border: Border.all(
                          color: AppColor.descriptionColor,
                          width: AppSize.appSizePoint7,
                        ),
                      ),
                      child: Center(
                        child: Obx(() => Text(
                          searchFilterController.startValueText2,
                          style: AppStyle.heading5Medium(
                              color: AppColor.textColor),
                        )),
                      ),
                    ),
                  ),
                  Text(
                    AppString.toText,
                    style: AppStyle.heading5Medium(color: AppColor.textColor),
                  ).paddingSymmetric(horizontal: AppSize.appSize26),
                  Expanded(
                    child: Container(
                      height: AppSize.appSize37,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.appSize12),
                        border: Border.all(
                          color: AppColor.descriptionColor,
                          width: AppSize.appSizePoint7,
                        ),
                      ),
                      child: Center(
                        child: Obx(() => Text(
                          searchFilterController.endValueText2,
                          style: AppStyle.heading5Medium(
                              color: AppColor.textColor),
                        )),
                      ),
                    ),
                  ),
                ],
              ).paddingOnly(
                top: AppSize.appSize18,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),










              Text(
                AppString.typesOfProperty,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize26,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  searchFilterController.propertyTypes.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        // Update the property type using the selected property
                        searchFilterController.updateTypesOfProperty(index);
                      },
                      child: Obx(() => Container(
                        margin: const EdgeInsets.only(bottom: AppSize.appSize6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.appSize16,
                          vertical: AppSize.appSize10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.appSize12),
                          border: Border.all(
                            color: searchFilterController
                                .selectTypesOfProperty.value ==
                                index
                                ? AppColor.primaryColor
                                : AppColor.borderColor,
                            width: AppSize.appSize1,
                          ),
                        ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Ensures that the row only takes up the space required
                            children: [
                              Icon(
                                Icons.add, // Plus icon
                                size: 16, // Adjust the size of the icon as needed
                                color: searchFilterController.selectTypesOfProperty.value == index
                                    ? AppColor.primaryColor
                                    : AppColor.descriptionColor,
                              ),
                              SizedBox(width: 4), // Adjust the spacing between the icon and the text
                              Text(
                                searchFilterController.propertyTypes[index].name, // Use the property name from selectedProperties
                                style: AppStyle.heading5Medium(
                                  color: searchFilterController.selectTypesOfProperty.value == index
                                      ? AppColor.primaryColor
                                      : AppColor.descriptionColor,
                                ),
                              ),
                            ],
                          )

                      )),
                    );
                  },
                ),
              ).paddingOnly(
                top: AppSize.appSize16,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              // Text(
              //   AppString.viewAllAdd,
              //   style: AppStyle.heading6Medium(
              //     color: AppColor.primaryColor,
              //   ),
              // ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
              Text(
                AppString.noOfBedrooms,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize26,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: AppSize.appSize16),
                child: Row(
                  children: List.generate(
                      searchFilterController.bedroomsList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        searchFilterController.updateBedrooms(index);
                      },
                      child: Obx(() => Container(
                            margin:
                                const EdgeInsets.only(right: AppSize.appSize16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.appSize16,
                              vertical: AppSize.appSize10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSize.appSize12),
                              border: Border.all(
                                color: searchFilterController
                                            .selectBedrooms.value ==
                                        index
                                    ? AppColor.primaryColor
                                    : AppColor.borderColor,
                                width: AppSize.appSize1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                searchFilterController.bedroomsList[index],
                                style: AppStyle.heading5Medium(
                                  color: searchFilterController
                                              .selectBedrooms.value ==
                                          index
                                      ? AppColor.primaryColor
                                      : AppColor.descriptionColor,
                                ),
                              ),
                            ),
                          )),
                    );
                  }),
                ).paddingOnly(top: AppSize.appSize16),
              ),
              Text(
                AppString.noOfBathrooms,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize26,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: AppSize.appSize16),
                child: Row(
                  children: List.generate(
                      searchFilterController.bathroomList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        searchFilterController.updateBathroom(index);
                      },
                      child: Obx(() => Container(
                            margin:
                                const EdgeInsets.only(right: AppSize.appSize16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.appSize16,
                              vertical: AppSize.appSize10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSize.appSize12),
                              border: Border.all(
                                color: searchFilterController
                                            .selectbathrooms.value ==
                                        index
                                    ? AppColor.primaryColor
                                    : AppColor.borderColor,
                                width: AppSize.appSize1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                searchFilterController.bathroomList[index],
                                style: AppStyle.heading5Medium(
                                  color: searchFilterController
                                              .selectbathrooms.value ==
                                          index
                                      ? AppColor.primaryColor
                                      : AppColor.descriptionColor,
                                ),
                              ),
                            ),
                          )),
                    );
                  }),
                ).paddingOnly(top: AppSize.appSize16),
              ),



              Text(
                AppString.amenities,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize26,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: AppSize.appSize16),
                child: Row(
                  children: List.generate(
                      searchFilterController.amenities.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        searchFilterController.updateAmenities(index);
                      },
                      child: Obx(() => Container(
                            margin:
                                const EdgeInsets.only(right: AppSize.appSize16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.appSize16,
                              vertical: AppSize.appSize10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSize.appSize12),
                              border: Border.all(
                                color: searchFilterController.amenitiesSelec.value ==
                                        index
                                    ? AppColor.primaryColor
                                    : AppColor.borderColor,
                                width: AppSize.appSize1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                searchFilterController.amenities[index].aminity,
                                style: AppStyle.heading5Medium(
                                  color: searchFilterController
                                              .amenitiesSelec.value ==
                                          index
                                      ? AppColor.primaryColor
                                      : AppColor.descriptionColor,
                                ),
                              ),
                            ),
                          )),
                    );
                  }),
                ).paddingOnly(top: AppSize.appSize16),
              ),




              Text(
                AppString.lookingForReadyToMove,
                style: AppStyle.heading4Medium(color: AppColor.textColor),
              ).paddingOnly(
                top: AppSize.appSize26,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
              Row(
                children: List.generate(
                    searchFilterController.propertyLookingForList.length,
                    (index) {
                  return GestureDetector(
                    onTap: () {
                      searchFilterController.updateLookingFor(index);
                    },
                    child: Obx(() => Container(
                          width: AppSize.appSize100,
                          margin:
                              const EdgeInsets.only(right: AppSize.appSize16),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSize.appSize10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSize.appSize12),
                            border: Border.all(
                              color: searchFilterController
                                          .selectLookingFor.value ==
                                      index
                                  ? AppColor.primaryColor
                                  : AppColor.borderColor,
                              width: AppSize.appSize1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              searchFilterController
                                  .propertyLookingForList[index],
                              style: AppStyle.heading6Medium(
                                color: searchFilterController
                                            .selectLookingFor.value ==
                                        index
                                    ? AppColor.primaryColor
                                    : AppColor.descriptionColor,
                              ),
                            ),
                          ),
                        )),
                  );
                }),
              ).paddingOnly(
                top: AppSize.appSize16,
                left: AppSize.appSize16,
                right: AppSize.appSize16,
              ),
            ],
          ),
        ),







      ],
    );
  }*/

  _searchContent() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              focusNode: focusNode
                ..addListener(() {
                  isFocused.value = focusNode.hasFocus; // Update focus state
                }),
              controller: searchFilterController.searchController,
              cursorColor: AppColor.primaryColor,
              style: AppStyle.heading4Regular(color: AppColor.textColor),
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
                  borderSide: BorderSide(color: Colors.black),
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
          ),

         /* Text(
            AppString.recentSearched,
            style: AppStyle.heading4Medium(color: AppColor.textColor),
          ).paddingOnly(top: AppSize.appSize26),
          Wrap(
            runSpacing: AppSize.appSize6,
            children: List.generate(searchFilterController.recentSearched2List.length, (index) {
              return Container(
                margin: const EdgeInsets.only(right: AppSize.appSize16),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSize.appSize10,
                  horizontal: AppSize.appSize14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.appSize12),
                  border: Border.all(
                    color: AppColor.borderColor,
                    width: AppSize.appSize1,
                  ),
                ),
                child: Text(
                  searchFilterController.recentSearched2List[index],
                  style: AppStyle.heading5Medium(
                    color: AppColor.descriptionColor,
                  ),
                ),
              );
            }),
          ).paddingOnly(top: AppSize.appSize16),*/
          SizedBox(height: AppSize.appSize20), // Space above Obx widget
          Obx(() {
            return isFocused.value
                ? searchFilterController.locations.isEmpty
                ? const Center(child: CircularProgressIndicator()) // Loading indicator
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchFilterController.locations.length,
              itemBuilder: (context, index) {
                Location location = searchFilterController.locations[index];
                return ListTile(
                  title: Text(
                    location.name,
                    style: AppStyle.heading5Medium(
                      color: AppColor.textColor,
                    ),
                  ),
                  onTap: () {
                    searchFilterController.searchController.text = location.name;
                    searchFilterController.setSelectedLocationId(location.id);
                    print("Selected Location ID: ${searchFilterController.selectedLocationId.value}");


                    // Optionally, hide the suggestions after selection
                    FocusScope.of(context).requestFocus(FocusNode());
                    searchFilterController.locations.clear();  // Clear suggestions
                    // Handle location selection here
                  },
                );
              },
            )
                : SizedBox(); // If not focused, show nothing
          }),
        ],
      ).paddingOnly(
        top: AppSize.appSize10,
        left: AppSize.appSize16,
        right: AppSize.appSize16,
      ),
    );
  }

}
