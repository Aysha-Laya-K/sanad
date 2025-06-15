import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/property__model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/searchcontentlocation_model.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:luxury_real_estate_flutter_ui_kit/model/aminities_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/propertytype_model.dart';

enum SearchContentType {
  searchFilter,
  search,
}

class SearchFilterController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<Location> locations = <Location>[].obs;
  //RxList<Amenity> amenities = <Amenity>[].obs;
  RxList<Amenity> amenities = <Amenity>[].obs;
  RxList<int> selectedAmenitiesIds = <int>[].obs;
  var selectLookingFor = 0.obs; // Store selected amenity IDs
  RxList<Location> allLocations = <Location>[].obs;
  Timer? _debounce;
  RxInt selectProperty = 0.obs;
  RxInt selectPropertyLooking = 0.obs;
  //RxInt selectBedrooms = 0.obs;
  RxInt amenitiesSelec = 0.obs;
  //RxInt selectbathrooms = 0.obs;
//  RxInt selectLookingFor = 0.obs;
  RxInt selectTypesOfProperty = 0.obs;
  Rx<RangeValues> values = const RangeValues(0, 100000).obs;
  String get startValueText => "QAR ${convertToText(values.value.start)}";
  String get endValueText => "QAR ${convertToText(values.value.end)}";

  Rx<RangeValues> values1 = const RangeValues(0, 100000).obs;
  String get startValueText1 => "QAR ${convertToText(values1.value.start)}";
  String get endValueText1 => "QAR ${convertToText(values1.value.end)}";

  Rx<RangeValues> values2 = const RangeValues(0, 10000).obs;
  String get startValueText2 => "sq/m ${convertToText(values2.value.start)}";
  String get endValueText2 => "sq/m ${convertToText(values2.value.end)}";




  Rx<RangeValues> values3 = const RangeValues(0, 10000).obs;
  String get startValueText3 => "sq/m ${convertToText(values3.value.start)}";
  String get endValueText3 => "sq/m ${convertToText(values3.value.end)}";

  RxList<PropertyType> propertyTypes = <PropertyType>[].obs;
  RxInt selectedPropertyTypeId = 0.obs;
 // RxList<int> selectBedrooms = <int>[].obs;
  RxList<String> selectBedrooms = <String>[].obs;
  RxList<String> selectbathrooms= <String>[].obs;











  Rx<SearchContentType> contentType = SearchContentType.searchFilter.obs;
  var loading = true.obs;
  RxInt selectedLocationId = RxInt(0);
  RxInt selectedTabIndex = 0.obs;
  @override



  // Method to set the selected location IDf


  void setSelectedLocationId(int id) {
    selectedLocationId.value = id;
    searchController.text = allLocations.firstWhere((location) => location.id == id).name;
    locations.value = allLocations; // Reset to full list
  }


  /*String convertToText(double value) {
    if (value >= 100) {
      return "${(value / 100).toStringAsFixed(2)} ";
    } else {
      return "${value.toStringAsFixed(2)} ";
    }
  }*/

  String convertToText(double value) {
    return "${value.toStringAsFixed(2)}";
  }


  Future<void> fetchLocations() async {
    final response = await http.get(Uri.parse('https://project.artisans.qa/realestate/api/locations'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      allLocations.value = (data['locations'] as List)
          .map((json) => Location.fromJson(json))
          .toList();
      locations.value = allLocations; // Initialize locations with allLocations
      print("Fetched Locations: ${allLocations.length}"); // Debugging
    } else {
      print("Failed to fetch locations: ${response.statusCode}");
    }
  }

  Future<void> fetchAmenities({int limit = 10, int offset = 0}) async {
    loading.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://project.artisans.qa/realestate/api/aminities?limit=$limit&offset=$offset'),
      );

      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("success0");
        final data = json.decode(response.body);

        // Parse the API response into a list of amenities
        List<Amenity> amenityList = (data['amenities'] as List)
            .map((json) => Amenity.fromJson(json))
            .toList();

        // Update the observable amenities list
        amenities.value = amenityList;

        // Default selection: Select the first amenity if the list is not empty
        if (amenities.isNotEmpty) {
          selectedAmenitiesIds.add(amenities.first.id);
          print("Default selected amenity: ${selectedAmenitiesIds}");
        }
      } else {
        print("failed");
        throw Exception('Failed to load amenities');
      }
    } catch (e) {
      print("Error fetching amenities: $e");
      Get.snackbar("Error", "Failed to fetch amenities");
    } finally {
      loading.value = false;
    }
  }


  Future<void> fetchPropertyTypes({int limit = 10, int offset = 0}) async {
    try {
      final response = await http.get(
        Uri.parse("https://project.artisans.qa/realestate/api/property-types?limit=10&offset=0"),
      );

      if (response.statusCode == 200) {
        print("success1");
        final data = json.decode(response.body);
        final propertyTypeResponse = PropertyTypeResponse.fromJson(data);
        propertyTypes.assignAll(propertyTypeResponse.propertyTypes);
        if (propertyTypes.isNotEmpty && selectTypesOfProperty.value == 0) {
          updateTypesOfProperty(0); // Automatically select the first item
        }

      } else {
        print("failed1");
        Get.snackbar("Error", "Failed to load property types");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }


 /* Future<void> fetchProperties({
    required String locationId,
    required String tabValue,
    required double minBudget,
    required double maxBudget,
    required double minArea,
    required double maxArea,
    required String propertyTypeId,
   required List<int> bedroomList,
    required List<int> bathroomList,
    required List<String> amenitiesList,
    required String furnishingValue,
  }) async {print("----------------${bedroomList.join(',')}");
    const String apiUrl = "https://project.artisans.qa/realestate/api/properties";
print(tabValue);
    // Prepare query parameters
    final queryParams = {
      'location': locationId,
      'purpose': tabValue,
      'min_price': minBudget.toString(),
      'max_price': maxBudget.toString(),
      'min_area': minArea.toString(),
      'max_area': maxArea.toString(),
      'type': propertyTypeId,
      'rooms': bedroomList.join(','), // Convert list to comma-separated string
      'bath_rooms': bathroomList.join(','), // Convert list to comma-separated string
      'amenities': amenitiesList.join(','), // Convert list to comma-separated string
      'furnishing_value': furnishingValue,
    };

    // Print passed parameters for debugging
    print("Passed Parameters:");
    print("location: $locationId");
    print("purpose: $tabValue");
    print("min_price: $minBudget");
    print("max_price: $maxBudget");
    print("min_area: $minArea");
    print("max_area: $maxArea");
    print("type: $propertyTypeId");
    print("rooms: $bedroomList");
    print("bath_rooms: $bathroomList");
    print("amenities: $amenitiesList");
    print("furnishing_value: $furnishingValue");

    try {
      // Build URI with query parameters
      final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

      // Send GET request
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse JSON response
        final data = json.decode(response.body);
        print("API Response: $data");
PropertyResponse sample=PropertyResponse.fromJson(data);
print("--------------${sample.data.length}");
        // Optionally navigate to a new screen with the fetched data
      } else {
        print("Failed to load properties. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while fetching properties: $e");
    }
  }*/
  void resetFilters() {
    // Reset all filters to their initial state
    searchController.clear();
    selectProperty.value = 0;
    selectPropertyLooking.value = 0;
    selectBedrooms.clear();
    selectbathrooms.clear();
    selectLookingFor.value = 0;
    selectTypesOfProperty.value = 0;
    values.value = const RangeValues(0, 100000);
    values1.value = const RangeValues(0, 100000);
    values2.value = const RangeValues(0, 10000);
    values3.value = const RangeValues(0, 10000);
    selectedAmenitiesIds.clear();
    selectedLocationId.value = 0;
    selectedTabIndex.value = 0;
    contentType.value = SearchContentType.searchFilter;

    // Optionally, you can re-fetch the initial data if needed
    fetchLocations();
    fetchAmenities();
    fetchPropertyTypes();
  }

  Future<PropertyResponse?> fetchProperties({
    required String tabValue,
    required List<int> bedroomList,

    required List<int> bathroomList,
    required List<int> amenitiesList,
    required String locationId,
    required double minBudget,
    required double maxBudget,
    required double minArea,
    required double maxArea,
    required String propertyTypeId,
    required String furnishingValue,
  }) async {
    print("Selected Bedrooms: $bedroomList");

    const String apiUrl = "https://project.artisans.qa/realestate/api/properties";

    // Encode the bedroomList as a JSON-like string
    final String encodedBedrooms = jsonEncode(bedroomList);
    final String encodedBathrooms = jsonEncode(bathroomList);
    final String encodedAmenities = jsonEncode(amenitiesList);

    // Prepare query parameters
    final queryParams = {
      'purpose': tabValue,
      'rooms': encodedBedrooms,


      'location': locationId,
      'min_price': minBudget.toString(),
      'max_price': maxBudget.toString(),
      'min_area': minArea.toString(),
      'max_area': maxArea.toString(),
      'type': propertyTypeId,
      'bath_rooms': encodedBathrooms, // Convert list to comma-separated string
      'amenities': encodedAmenities, // Convert list to comma-separated string
      'furnishing_value': furnishingValue,
      // Pass the JSON string instead of a comma-separated value
    };

    // Build URI with query parameters
    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    // Print the final URL for debugging
    print("Final URL: ${uri.toString()}");

    try {
      // Send GET request
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);
        print("API Response: $data");

        // Parse into PropertyResponse model
        PropertyResponse propertyResponse = PropertyResponse.fromJson(data);
        print("--------------${propertyResponse.data.length}");

        return propertyResponse;  // Return the parsed response

      } else {
        print("Failed to load properties. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while fetching properties: $e");
    }

    return null; // In case of failure, return null
  }

  void updateProperty(int index) {
    selectProperty.value = index;
  }

  void updatePropertyLooking(int index) {
    selectPropertyLooking.value = index;
  }
  void filterLocations(String query) {
    print("Filtering with query: $query"); // Debugging
    if (query.isEmpty) {
      // If the query is empty, show all locations
      locations.value = allLocations;
    } else {
      // Filter the locations based on the query
      locations.value = allLocations.where((location) {
        final containsQuery = location.name.toLowerCase().contains(query.toLowerCase());
        print("Location: ${location.name}, Contains Query: $containsQuery"); // Debugging
        return containsQuery;
      }).toList();
    }
    print("Filtered Locations: ${locations.length}"); // Debugging
  }
  void updateBedrooms(int index) {
    String selectedBedroom = bedroomsList[index]; // Get the actual value from bedroomsList
    if (selectBedrooms.contains(selectedBedroom)) {
      selectBedrooms.remove(selectedBedroom); // Deselect if already selected
    } else {
      selectBedrooms.add(selectedBedroom); // Select if not already selected
    }
    print('Selected Bedrooms: $selectBedrooms');
  }



  void updateAmenities(int index) {
    final amenityId = amenities[index].id;

    if (selectedAmenitiesIds.contains(amenityId)) {
      // If already selected, deselect
      selectedAmenitiesIds.remove(amenityId);
    } else {
      // If not selected, add to the list
      selectedAmenitiesIds.add(amenityId);
    }

    print('Selected Amenity IDs: $selectedAmenitiesIds');
  }

  void updateBathrooms(int index) {
    String selectedBathroom = bathroomList[index]; // Get the actual value from bathroomsList
    if (selectbathrooms.contains(selectedBathroom)) {
      selectbathrooms.remove(selectedBathroom); // Deselect if already selected
    } else {
      selectbathrooms.add(selectedBathroom); // Select if not already selected
    }
    print('Selected Bathrooms: $selectbathrooms');
  }



  void updateLookingFor(int index) {
    selectLookingFor.value = index;
    print("Selected Looking For: ${selectLookingFor.value}");  // Debugging line
  }

  void updateTypesOfProperty(int index) {
    // Ensure index is valid before updating
    if (index >= 0 && index < propertyTypes.length) {
      selectTypesOfProperty.value = index;
      selectedPropertyTypeId.value = propertyTypes[index].id; // Ensure id is an integer
      print("Selected Property Type ID: ${selectedPropertyTypeId.value}");
    } else {
      print("Invalid index: $index");
    }
  }


  void updateValues(RangeValues newValues) {
    values.value = newValues;
  }

  void updateValues1(RangeValues newValues) {
    values1.value = newValues;
  }

  void updateValues2(RangeValues newValues) {
    values2.value = newValues;
  }
  void updateValues3(RangeValues newValues) {
    values3.value = newValues;
  }



  RxList<String> propertyList = [
    AppString.residential,
    AppString.commercial,
  ].obs;

  RxList<String> propertyLookingList = [
    AppString.buy,
    AppString.rentPg,
    AppString.room,
  ].obs;

  RxList<String> propertyTypeList = [
    AppString.residentialApartment,
    AppString.independentVilla,
    AppString.plotLandAdd,
  ].obs;

  RxList<String> bedroomsList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ].obs;
  RxList<String> amenitiesList = [
    'Balcony',
    'Central AC',
    'Maids Room',
    'Private Pool',
    'Pets allowed',
  ].obs;
  RxList<String> bathroomList = [
    '1',
    '2',
    '3',
    '4',
  ].obs;
  RxList<String> propertyLookingForList = [
    AppString.furnished,
    AppString.semiFurnished,
    AppString.unFurnished,
  ].obs;

  RxList<String> recentSearchedList = [
    AppString.amroli,
    AppString.palanpura,
  ].obs;

  RxList<String> recentSearched2List = [
    AppString.vesu,
    AppString.palanpura,
    AppString.pal,
    AppString.adajan,
    AppString.althana,
    // AppString.dindoli,
    // AppString.vipRoad,
    // AppString.piplod,
  ].obs;
  @override
  void onInit() {
    super.onInit();
    fetchLocations(); // Fetch all locations when the controller initializes
    print("All Locations: ${allLocations.length}"); // Debugging

    fetchAmenities();
    fetchPropertyTypes();

    setContentBasedOnTab();



    selectBedrooms.add(bedroomsList[0]);
    selectbathrooms.add(bathroomList[0]);

    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        // Call filterLocations instead of fetchLocations
        filterLocations(searchController.text);
      });
    });
  }
  void setContentBasedOnTab() {
    if (selectedTabIndex.value == 0) {
      setContent(SearchContentType.searchFilter); // Rent tab
    } else if (selectedTabIndex.value == 1) {
      setContent(SearchContentType.searchFilter); // Buy tab
    }
  }

  void setContent(SearchContentType type) {
    contentType.value = type;
    print("Content Type Set to: $type"); // Debugging
  }
  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
    searchController.dispose();
  }
}
