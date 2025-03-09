import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/servicetype_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:luxury_real_estate_flutter_ui_kit/model/servicedetails_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityController extends GetxController {
  TextEditingController searchListController = TextEditingController();

  RxInt selectListing = 0.obs;
  RxInt selectSorting = 0.obs;
  RxBool deleteShowing = false.obs;
  RxList<ServiceType> serviceTypes = <ServiceType>[].obs;
  ServiceDetails? serviceDetails;



  void onInit() {
    super.onInit();
    fetchServiceTypes();// Fetch property types when the controller initializes
  }

  void launchDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+974$phoneNumber');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  Future<void> openWhatsApp(String whatsapp) async {
    final whatsappUrl = Uri.parse('https://wa.me/+974$whatsapp'); // Convert the string to Uri
    await launchUrl(whatsappUrl);  // Launch the URL

  }


  Future<void> openGmail(String agentEmail) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: agentEmail,
      // query:
      //     'subject=Your Subject&body=Hello, this is the email body', // Optional query parameters
    );

    await launchUrl(emailUri);
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

  Future<void> fetchServiceDetails(int serviceId) async {
    final url = 'https://project.artisans.qa/realestate/api/service-details/$serviceId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        // Parse the response into the ServiceDetails object
        serviceDetails = ServiceDetails.fromJson(responseData); // Update the controller's serviceDetails

        // Debugging: Print details
        print('Service Title: ${serviceDetails!.title}');
      } else {
        print('Failed to load service details');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


 /* Future<void> fetchServiceDetails(int serviceId) async {
    final url = 'https://project.artisans.qa/realestate/api/service-details/$serviceId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        // Parse the response into the ServiceDetails object
        ServiceDetails serviceDetails = ServiceDetails.fromJson(responseData);

        // Print all the details
        print('Service Title: ${serviceDetails.title}');
        print('Service Description: ${serviceDetails.description}');
        print('Service Starting Price: ${serviceDetails.startingPrice}');
        print('Service Vendor Name: ${serviceDetails.vendorName.name}');
        print('Service Image: ${serviceDetails.thumbImage}');
        print('Service Slider Images: ${serviceDetails.sliderImages}');
        print('Service Created At: ${serviceDetails.createdAt}');
        print('Vendor Phone: ${serviceDetails.vendorName.phone}');
      } else {
        print('Failed to load service details');
      }
    } catch (error) {
      print('Error: $error');
    }
  }*/



  void updateListing(int index) {
    selectListing.value = index;
  }

  void updateSorting(int index) {
    selectSorting.value = index;
  }

  RxList<String> listingStatesList = [
    AppString.active,
    AppString.expired,
    AppString.deleted,
    AppString.underScreening,
  ].obs;

  RxList<String> sortListingList = [
    AppString.newestFirst,
    AppString.oldestFirst,
    AppString.expiringFirst,
    AppString.expiringLast,
  ].obs;

  RxList<String> propertyListImage = [
    Assets.images.listing1.path,
    Assets.images.listing2.path,
    Assets.images.listing3.path,
    Assets.images.listing4.path,
  ].obs;

  RxList<String> propertyListRupee = [
    AppString.rupee50Lac,
    AppString.rupee50Lac,
    AppString.rupee45Lac,
    AppString.rupee45Lac,
  ].obs;

  RxList<String> propertyListTitle = [
    AppString.pestControl,
    AppString.shreenathjiResidency,
    AppString.pramukhDevelopersSurat,
    AppString.theWriteClub,
  ].obs;

  RxList<String> propertyListAddress = [
    AppString.northBombaySociety,
    AppString.roslynWalks,
    AppString.akshyaNagar,
    AppString.rammurthyNagar,
  ].obs;

  @override
  void dispose() {
    super.dispose();
    searchListController.clear();
  }
}
