import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/model/propertytype_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/servicetype_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/featuredproperty_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/typemodel.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/serviceresponse_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/agent_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/newproperty_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/map_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/profile_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/share_pref.dart';
import 'saved_properties_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/banner_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/propertytype_list_Contoller.dart';


class HomeController extends GetxController {
  final PropertyTypeListController propertyTypeListController = Get.put(PropertyTypeListController());
  TextEditingController searchController = TextEditingController();
  RxInt selectProperty = 0.obs;
  RxInt selectCountry = 0.obs;
  RxList<bool> isTrendPropertyLiked = <bool>[].obs;
  RxList<PropertyType> propertyTypes = <PropertyType>[].obs;
  RxList<ServiceType> serviceTypes = <ServiceType>[].obs;
  RxList<Property> featuredProperties = <Property>[].obs;
  RxList<NewProperty> newProperties = <NewProperty>[].obs;
  RxList<Property> types = <Property>[].obs;
  RxBool isLoading = false.obs;
  RxList<Service> services = <Service>[].obs;
  RxList<int> serviceIds = <int>[].obs;
  String purpose = 'rent';
  RxList<AgentData> agentsList = <AgentData>[].obs;
  RxList<bool> isSavedList = <bool>[].obs;
  //RxBool isLoading = false.obs;  // To show loading state if required
 // RxString apiResponse = ''.obs;
  var mapDataResponse = Rx<MapDataResponse?>(null);
  RxMap<int, bool> isSavedMap = RxMap<int, bool>();
  Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  var homeBanner = Rx<HomeBannerResponse?>(null);
  var isLoadingBanner = false.obs;

  @override

  void onInit() {
    super.onInit();
    fetchPropertyTypes();
    fetchServiceTypes();
    fetchFeaturedProperty(purpose);
    fetchAgents();
    fetchNewProperty(purpose);
    checkTokenAndFetchProfile();
    fetchHomeBanner();
    print("Current purpose: $purpose");// Fetch property types when the controller initializes
  }



  // Function to check token and fetch profile data if token exists
  Future<void> checkTokenAndFetchProfile() async {
    final token = await UserTypeManager.getToken();
    if (token != null) {
      // If token exists, fetch the profile from the API
      await _fetchProfileData(token);
    } else {
      // If token is null, remain with the default greeting
      userProfile.value = null;
    }
  }
  Future<void> fetchHomeBanner() async {
    try {
      isLoadingBanner.value = true; // Show loading indicator
      final response = await http.get(
        Uri.parse("https://project.artisans.qa/realestate/api/get-home-banner"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        homeBanner.value = HomeBannerResponse.fromJson(data); // Parse and store banner data
      } else {
        Get.snackbar("Error", "Failed to load home banner");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoadingBanner.value = false; // Hide loading indicator
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



  Future<void> fetchMapData() async {
    final String url = "https://project.artisans.qa/realestate/api/map-data";

    try {
      // Set loading state to tru

      // Make the API call
      final response = await http.get(Uri.parse(url));
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {

        // If the server returns a 200 OK response

        // Store the parsed data in an observable
        final data = json.decode(response.body);
        final mapDataResponseObj = MapDataResponse.fromJson(data);

        // Update the observable with the response data
        mapDataResponse.value = mapDataResponseObj;

        print('API Response: ${response.body}');
        // Print response for debugging
      } else {
        // If the server returns an error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any errors in the API call
      print('Error occurred: $e');
    } finally {
      // Set loading state to false
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
      } else {
        print("failed1");
        Get.snackbar("Error", "Failed to load property types");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> fetchServiceTypes({int limit = 10, int offset = 0}) async {
    try {
      final response = await http.get(
        Uri.parse("https://project.artisans.qa/realestate/api/service-masters?limit=10&offset=0"),
      );

      if (response.statusCode == 200) {
        print("success2");
        final data = json.decode(response.body);
        final serviceTypeResponse = ServiceTypeResponse.fromJson(data);
        serviceTypes.assignAll(serviceTypeResponse.services); // Updated this line
      } else {
        print("failed2");
        Get.snackbar("Error", "Failed to load service types");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }


  Future<void> fetchServiceList(int serviceId) async {
    try {
      final response = await http.get(
        Uri.parse("https://project.artisans.qa/realestate/api/service-list?servive_master_id=$serviceId"),
      );

      if (response.statusCode == 200) {
        print("API Call Success");
        print("Response: ${response.body}");

        // Parse API response
        ServiceListModel serviceList = ServiceListModel.fromJson(response.body);
        services.value = serviceList.services;

        // Clear previous ids and populate with new ones
        serviceIds.clear();
        for (var service in serviceList.services) {
          serviceIds.add(service.id); // Store the service ID separately
          print("Service Title: ${service.title}");
          print("Starting Price: ${service.startingPrice}");
        }
      } else {
        print("API Call Failed");
        Get.snackbar("Error", "Failed to load services");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }


  // Fetch featured properties
  Future<void> fetchFeaturedProperty(String purpose) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse("https://project.artisans.qa/realestate/api/featured-properties?purpose=$purpose"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final featuredPropertyResponse = PropertyListResponse.fromJson(data);
        featuredProperties.assignAll(featuredPropertyResponse.data);

        // Check wishlist status for each property
        for (var property in featuredProperties) {
          await checkWishlistStatus(property.id);
        }
      } else {
        Get.snackbar("Error", "Failed to load featured properties");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Check if a property is in the wishlist
  Future<void> checkWishlistStatus(int propertyId) async {
    final token = await UserTypeManager.getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse("https://project.artisans.qa/realestate/api/user/check-in-wishlist?property_id=$propertyId"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isInWishlist = data['status'] == true;
        isSavedMap[propertyId] = isInWishlist;
      }
    } catch (e) {
      print("Error checking wishlist status: $e");
    }
  }
  // In HomeController
  Future<void> addToWishlist(int propertyId) async {
    final token = await UserTypeManager.getToken();
    if (token == null) {
      Get.snackbar("Login Required", "Please login to add properties to your wishlist.");
      Get.toNamed(AppRoutes.loginView);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("https://project.artisans.qa/realestate/api/user/add-to-wishlist/$propertyId"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        isSavedMap[propertyId] = true; // Update isSavedMap
        update(); // Notify listeners
        print("Successfully added property $propertyId to wishlist.");
      }
    } catch (e) {
      print("Error adding to wishlist: $e");
      Get.snackbar("Error", "Failed to add property to wishlist: $e");
    }
  }

  Future<void> removeFromWishlist(int propertyId, {bool isFromSavedPage = false}) async {
    final token = await UserTypeManager.getToken();
    if (token == null) {
      Get.snackbar("Login Required", "Please login to remove properties from your wishlist.");
      Get.toNamed(AppRoutes.loginView);
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse("https://project.artisans.qa/realestate/api/user/remove-wishlist/$propertyId"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        isSavedMap[propertyId] = false; // Update isSavedMap
        update(); // Notify listeners
        print("Successfully removed property $propertyId from wishlist.");

        if (isFromSavedPage) {
          Get.find<SavedPropertiesController>().removePropertyFromWishlist(propertyId);
        }
      }
    } catch (e) {
      print("Error removing from wishlist: $e");
      Get.snackbar("Error", "Failed to remove property from wishlist: $e");
    }
  }

  // Add a property to the wishlist
 /* Future<void> addToWishlist(int propertyId) async {
    final token = await UserTypeManager.getToken();
    if (token == null) {
      Get.snackbar("Login Required", "Please login to add properties to your wishlist.");
      Get.toNamed(AppRoutes.loginView);
      return;

    }

    try {
      final response = await http.get(
        Uri.parse("https://project.artisans.qa/realestate/api/user/add-to-wishlist/$propertyId"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        isSavedMap[propertyId] = true;
        print("Successfully added property $propertyId to wishlist.");
        print("API Response for adding to Wishlist: ${response.body}");
      }
    } catch (e) {
      print("Caught error while adding property $propertyId to wishlist:");
      print("Error type: ${e.runtimeType}"); // Print the type of exception
      print("Error message: ${e.toString()}"); // Print the error message
      Get.snackbar("Error", "Failed to add property to wishlist: $e");
    }
  }

  // Remove a property from the wishlist
  Future<void> removeFromWishlist(int propertyId,{bool isFromSavedPage = false}) async {
    final token = await UserTypeManager.getToken();
    if (token == null) {
      Get.snackbar("Login Required", "Please login to remove properties from your wishlist.");
      Get.toNamed(AppRoutes.loginView);
      return;

    }

    try {
      final response = await http.delete(
        Uri.parse("https://project.artisans.qa/realestate/api/user/remove-wishlist/$propertyId"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        isSavedMap[propertyId] = false;
        print("Successfully removed property $propertyId to wishlist.");
        print("API Response for removed from Wishlist: ${response.body}");

        if (isFromSavedPage) {
          Get.find<SavedPropertiesController>().removePropertyFromWishlist(propertyId);
        }

       // Get.find<SavedPropertiesController>().removePropertyFromWishlist(propertyId);
        print("hii");


      }
    } catch (e) {
      print("Caught error while removing property $propertyId to wishlist:");
      print("Error type: ${e.runtimeType}"); // Print the type of exception
      print("Error message: ${e.toString()}"); // Print the error message
     Get.snackbar("Error", "Failed to remove property from wishlist: $e");
    }
  }*/


 /* Future<void> fetchFeaturedProperty(String purpose) async {
    try {
      isLoading.value = true;
      // Using the dynamic limit and offset values in the API URL
      final response = await http.get(
        Uri.parse("https://project.artisans.qa/realestate/api/featured-properties?purpose=$purpose"),
      );

      if (response.statusCode == 200) {
        print("success26");
        print("API Response: ${response.body}");
        final data = json.decode(response.body);


        // Assuming PropertyListResponse has a 'fromJson' method
        final featuredPropertyResponse = PropertyListResponse.fromJson(data);

        // Assigning the 'data' list to 'featuredProperties'
        featuredProperties.assignAll(featuredPropertyResponse.data);
        isSavedList.assignAll(List.generate(featuredProperties.length, (index) => false));
        // Updated this line
      } else {
        print("failed2");
        Get.snackbar("Error", "Failed to load featured properties");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
    finally{
      isLoading.value = false;
    }
  }*/




  Future<void> fetchNewProperty(String purpose) async {
    try {
      isLoading.value = true;
      // Using the dynamic limit and offset values in the API URL
      final response = await http.get(
        Uri.parse("https://project.artisans.qa/realestate/api/new-properties?purpose=$purpose"),
        headers: {
          "Content-Type": "application/json",
        },

      );

      if (response.statusCode == 200) {
        print("test");
        print("API Response: ${response.body}");
        final data = json.decode(response.body);
        final newPropertyResponse = NewPropertyResponse.fromJson(data);
        newProperties.assignAll(newPropertyResponse.data);
        for (var property in newProperties) {
          await checkWishlistStatus(property.id);
        }
      //  isSavedList.assignAll(List.generate(newProperties.length, (index) => false));



        //final data = json.decode(response.body);
       /* final Map<String, dynamic> data = json.decode(response.body);

        // Parse the data into the model
        NewPropertyResponse propertyResponse = NewPropertyResponse.fromJson(data);*/

        // Now you can access the property response data

        // Loop through each property and print the title
        for (var property in newPropertyResponse.data) {
          print("Property Title: ${property.title}");
        }


        // Assuming PropertyListResponse has a 'fromJson' method
        // Updated this line
      } else {
        print("failed2");
        Get.snackbar("Error", "Failed to load featured properties");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
    finally{
      isLoading.value = false;
    }
  }



/*  Future<TypeResponse?> fetchTypeProperties({
    required String id,

  }) async {


    const String apiUrl = "https://project.artisans.qa/realestate/api/properties";

    // Encode the bedroomList as a JSON-like string


    // Prepare query parameters
    final queryParams = {
      'type': id,
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

        // Parse into TypeResponse model
        TypeResponse typeResponse = TypeResponse.fromJson(data);

        print("--------------${typeResponse.data.length}");
        for (var property in typeResponse.data) {
          await checkWishlistStatus(property.id);
        }// Access the data property correctly

        return typeResponse;  // Return the parsed response

      } else {
        print("Failed to load properties. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while fetching properties: $e");
    }

    return null; // In case of failure, return null
  }*/

  Future<void> fetchPropertyDetails(int propertyId) async {
    print('Fetching details for property ID: $propertyId');  // Debugging print

    // Construct the URL by embedding the propertyId directly into the endpoint
    final String url = 'https://project.artisans.qa/realestate/api/property/$propertyId';

    try {
      // Make the GET request
      final response = await http.get(Uri.parse(url));

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('API Response: ${response.body}');

        // Parse the response if it's in JSON format
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Decoded API Data: $data');

        // Process the data here (e.g., update state, pass it to the UI, etc.)
      } else {
        // Handle non-successful status codes (e.g., 404, 500)
        print('Error: API returned status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors (e.g., network errors, timeout, etc.)
      print('Error occurred while fetching property details: $error');
    }
  }



  Future<void> fetchAgents() async {
    const String url = 'https://project.artisans.qa/realestate/api/agents';

    print('Fetching agents data...');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('API Response: ${response.body}');

        // Parse JSON response
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Decoded API Data: $data');

        // Convert to model class
        final agentsResponse = AgentsResponse.fromJson(data);

        // Update agentsList with the agent data
        agentsList.value = agentsResponse.agents.data;

        // Debugging: Print agent names
        for (var agent in agentsResponse.agents.data) {
          print('Agent Name: ${agent.name}');
        }

        // You can now use agentsResponse in your UI or state management
      } else {
        print('Error: API returned status code ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred while fetching agents: $error');
    }
  }



  void updateProperty(int index) {
    selectProperty.value = index;
  }

  /*void updateCountry(int index) {
    selectCountry.value = index;
  }*/

  void updateCountry(int index) {
    selectCountry.value = index;
    // Dynamically set the purpose based on the index
    purpose = (index == 0) ? 'rent' : 'sale';
    print("Current purpose: $purpose"); // Index 0 is for rent, index 1 is for buy

    // Skip fetching featuredProperties and newProperties if index is AppSize.size2
    if (index != AppSize.size2) {
      fetchFeaturedProperty(purpose);
      fetchNewProperty(purpose);

      // Ensure propertyTypes is not empty and index is within bounds
      if (propertyTypes.isNotEmpty && index < propertyTypes.length) {
        // Get the property type ID from the propertyTypes list
        final propertyTypeId = propertyTypes[index].id.toString();

        // Call fetchTypeProperties from PropertyTypeListController
        propertyTypeListController.fetchTypeProperties(
          id: propertyTypeId, // Pass the property type ID
          purpose: purpose,
        );
      } else {
        print("Property types list is empty or index is out of bounds.");
      }
    }
  }


  RxList<String> propertyOptionList = [
    AppString.buy,
    AppString.rent,
    AppString.plotLand,
    AppString.pg,
    AppString.coWorkingSpace,
    AppString.byCommercial,
    AppString.leaseCommercial,
    AppString.postAProperty,
  ].obs;

  RxList<String> countryOptionList = [
    AppString.westernMumbai,
    AppString.switzerland,
    AppString.nepal,
    AppString.exploreNew,
  ].obs;

  RxList<String> projectImageList = [
    Assets.images.project1.path,
    Assets.images.project2.path,
    Assets.images.project1.path,
  ].obs;

  RxList<String> projectPriceList = [
    AppString.rupees4Cr,
    AppString.priceOnRequest,
    AppString.priceOnRequest,
  ].obs;

  RxList<String> projectTitleList = [
    AppString.residentialApart,
    AppString.residentialApart2,
    AppString.plot2000ft,
  ].obs;

  RxList<String> projectAddressList = [
    AppString.address1,
    AppString.address2,
    AppString.address3,
  ].obs;

  RxList<String> projectTimingList = [
    AppString.days2Ago,
    AppString.month2Ago,
    AppString.month2Ago,
  ].obs;

  RxList<String> project2ImageList = [
    Assets.images.project3.path,
    Assets.images.project4.path,
    Assets.images.project3.path,
  ].obs;

  RxList<String> project2PriceList = [
    AppString.rupees2Cr,
    AppString.rupees5Cr,
    AppString.rupees2Cr,
  ].obs;

  RxList<String> project2TitleList = [
    AppString.residentialApart,
    AppString.plot2000ft,
    AppString.residentialApart,
  ].obs;

  RxList<String> project2AddressList = [
    AppString.address4,
    AppString.address5,
    AppString.address4,
  ].obs;

  RxList<String> project2TimingList = [
    AppString.days2Ago,
    AppString.month2Ago,
    AppString.days2Ago,
  ].obs;

  RxList<String> responseImageList = [
    Assets.images.response1.path,
    Assets.images.response2.path,
    Assets.images.response3.path,
    Assets.images.response4.path,
  ].obs;

  RxList<String> responseNameList = [
    AppString.rudraProperties,
    AppString.claudeAnderson,
    AppString.rohitBhati,
    AppString.heerKher,
  ].obs;

  RxList<String> responseTimingList = [
    AppString.today,
    AppString.today,
    AppString.yesterday,
    AppString.days4Ago,
  ].obs;

  RxList<String> responseEmailList = [
    AppString.rudraEmail,
    AppString.rudraEmail,
    AppString.rudraEmail,
    AppString.heerEmail,
  ].obs;

  RxList<String> searchImageList = [
    Assets.images.searchProperty1.path,
    Assets.images.searchProperty2.path,
    Assets.images.searchProperty1.path,
    Assets.images.searchProperty2.path,
  ].obs;

  RxList<String> searchTitleList = [
    AppString.semiModernHouse,
    AppString.modernHouse,
    AppString.semiModernHouse,
    AppString.modernHouse,
  ].obs;

  RxList<String> searchAddressList = [
    AppString.address6,
    AppString.address7,
    AppString.address6,
    AppString.address7,
  ].obs;

  RxList<String> searchRupeesList = [
    AppString.rupees58Lakh,
    AppString.rupees22Lakh,
    AppString.rupees58Lakh,
    AppString.rupees22Lakh,
  ].obs;

  RxList<String> searchPropertyImageList = [
    Assets.images.bath.path,
    Assets.images.bed.path,
    Assets.images.plot.path,
  ].obs;

  RxList<String> searchPropertyTitleList = [
    AppString.point2,
    AppString.point1,
    AppString.sq456,
  ].obs;


  RxList<String> popularBuilderImageList = [
    Assets.images.builder1.path,
    Assets.images.builder2.path,
    Assets.images.builder3.path,
    Assets.images.builder4.path,
    Assets.images.builder5.path,
    Assets.images.builder6.path,
  ].obs;

  RxList<String> popularBuilderTitleList = [
    AppString.sobhaDevelopers,
    AppString.kalpataru,
    AppString.godrej,
    AppString.unitech,
    AppString.casagrand,
    AppString.brigade,
  ].obs;

  RxList<String> upcomingProjectImageList = [
    Assets.images.upcomingProject1.path,
    Assets.images.upcomingProject2.path,
    Assets.images.upcomingProject3.path,
  ].obs;

  RxList<String> upcomingProjectTitleList = [
    AppString.pestControl,
    AppString.shreenathjiResidency,
    AppString.pramukhDevelopersSurat,
  ].obs;

  RxList<String> upcomingProjectAddressList = [
    AppString.address8,
    AppString.address9,
    AppString.address10,
  ].obs;

  RxList<String> upcomingProjectFlatSizeList = [
    AppString.bhk3Apartment,
    AppString.bhk4Apartment,
    AppString.bhk5Apartment,
  ].obs;

  RxList<String> upcomingProjectPriceList = [
    AppString.lakh45,
    AppString.lakh85,
    AppString.lakh85,
  ].obs;

  RxList<String> popularCityImageList = [
    Assets.images.city1.path,
    Assets.images.city2.path,
    Assets.images.city3.path,
    Assets.images.city4.path,
    Assets.images.city5.path,
    Assets.images.city6.path,
    Assets.images.city7.path,
  ].obs;

  RxList<String> popularCityTitleList = [
    AppString.mumbai,
    AppString.newDelhi,
    AppString.gurgaon,
    AppString.noida,
    AppString.bangalore,
    AppString.ahmedabad,
    AppString.kolkata,
  ].obs;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
