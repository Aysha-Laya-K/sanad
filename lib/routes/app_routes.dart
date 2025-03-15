import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/activity/activity_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/bottom_bar/bottom_bar_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/agents_list/agents_details_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/agents_list/agents_list_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/contact_property/contact_property_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/intresting_reads/interesting_reads_details_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/intresting_reads/interesting_reads_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/recent_activity/recent_activity_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/responses/lead_details_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/responses/responses_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/terms_of_use/about_us_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/terms_of_use/privacy_policy_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/terms_of_use/terms_of_use_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/terms_of_use/termsconditions.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/drawer/viewed_property/viewed_property_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/delete_listing_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/home_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/vendor_home_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/login/login_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/notification/notification_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/onboard/onboard_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/otp/otp_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/popular_builders/popular_builders_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/post_property/add_amenities_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/post_property/add_photo_and_pricing_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/post_property/add_property_details_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/post_property/edit_property_details_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/post_property/edit_property_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/post_property/post_property_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/post_property/show_property_details_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/profile/community_settings/community_settings_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/profile/edit_profile_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/profile/feedback/feedback_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/profile/languages/languages_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/about_property_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/contact_owner_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/furnishing_details_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/gallery_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/property_details_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/property_list_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/register/register_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/reviews/add_reviews_for_broker_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/reviews/add_reviews_for_property_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/saved/saved_properties_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/search/search_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/splash/splash_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/propertytype_list_view.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/enquiryform.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/requirements/requirements.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/customer_needs/customer_needs.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/profile/my_needs/myneeds.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/requirement_update./req_update.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/customer_needs/needs_detail.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/property_map_screen.dart';

class AppRoutes {
  static const String splashView = "/splash_view";
  static const String needDetails = "/needs_detail";
  static const String onboardView = "/onboard_view";
  static const String loginView = "/login_view";
  static const String otpView = "/otp_view";
  static const String registerView = "/register_view";
  static const String myNeeds = "/myneeds";
  static const String homeView = "/home_view";
  static const String vendorHomeView = "/vendor_home_view";
  static const String bottomBarView = "/bottom_bar_view";
  static const String notificationView = "/notification_view";
  static const String searchView = "/search_view";
  static const String reqUpdate = "/req_update";
  static const String propertyListView = "/property_list_view";
  static const String propertyDetailsView = "/property_details_view";
  static const String galleryView = "/gallery_view";
  static const String map = "/property_map_screen";
  static const String furnishingDetailsView = "/furnishing_details_view";
  static const String aboutPropertyView = "/about_property_view";
  static const String contactOwnerView = "/contact_owner_view";
  static const String postPropertyView = "/post_property_view";
  static const String addPropertyDetailsView = "/add_property_details_view";
  static const String enquiryForm = "/enquiryform.dart";
  static const String addPhotosAndPricingView = "/add_photos_and_pricing_view";
  static const String addAmenitiesView = "/add_amenities_view";
  static const String showPropertyDetailsView = "/show_property_details_view";
  static const String editPropertyView = "/edit_property_view";
  static const String req = "/requirements";
  static const String editPropertyDetailsView = "/edit_property_details_view";
  static const String popularBuildersView = "/popular_builders_view";
  static const String savedPropertiesView = "/saved_properties_view";
  static const String contactPropertyView = "/contact_property_view";
  static const String viewedPropertyView = "/viewed_property_view";
  static const String recentActivityView = "/recent_activity_view";
  static const String responsesView = "/responses_view";
  static const String leadDetailsView = "/lead_details_view";
  static const String editProfileView = "/edit_profile_view";
  static const String agentsListView = "/agents_list_view";
  static const String agentsDetailsView = "/agents_details_view";
  static const String customerNeeds = "/customer_needs";
  static const String addReviewsForBrokerView = "/add_reviews_for_broker_view";
  static const String addReviewsForPropertyView =
      "/add_reviews_for_property_view";
  static const String interestingReadsView = "/interesting_reads_view";
  static const String interestingReadsDetailsView =
      "/interesting_reads_details_view";
  static const String communitySettingsView = "/community_settings_view";
  static const String feedbackView = "/feedback_view";
  static const String termsOfUseView = "/terms_of_use_view";
  static const String privacyPolicyView = "/privacy_policy_view";
  static const String termsconditionsView = "/termsconditions";
  static const String aboutUsView = "/about_us_view";
  static const String languagesView = "/languages_view";
  static const String deleteListingView = "/delete_listing_view";
  static const String activityView = "/activity_view";
  static const String propertyTypeListView = "/propertytype_list_view";

  static List<GetPage> pages = [
    GetPage(name: splashView, page: () => SplashView()),
    GetPage(name: onboardView, page: () => OnboardView()),
    GetPage(name: loginView, page: () => LoginView()),
    GetPage(name: otpView, page: () => OtpView()),
    GetPage(name: registerView, page: () => RegisterView()),
    GetPage(name: homeView, page: () => HomeView()),
    GetPage(name: enquiryForm, page: () => EnquiryForm()),
    GetPage(name: vendorHomeView, page: () => VendorHomeView()),
    GetPage(name: bottomBarView, page: () => BottomBarView()),
    GetPage(name: notificationView, page: () => NotificationView()),
    GetPage(name: searchView, page: () => SearchView()),
    GetPage(name: propertyListView, page: () => PropertyListView()),
    GetPage(
      name: AppRoutes.propertyTypeListView,
      page: () {
        final arguments = Get.arguments as Map<String, dynamic>; // Retrieve arguments as a map
        final String propertyTypeId = arguments['propertyTypeId']; // Extract propertyTypeId
        final String purpose = arguments['purpose']; // Extract purpose
        return PropertyTypeListView(
          propertyTypeId: propertyTypeId,
          purpose: purpose, // Pass the purpose parameter
        );
      },
    ),
    GetPage(name: propertyDetailsView, page: () => PropertyDetailsView(/*propertyId:Get.arguments ,*/)),
    GetPage(name: galleryView, page: () => GalleryView()),
    GetPage(name: furnishingDetailsView, page: () => FurnishingDetailsView()),
    GetPage(name: aboutPropertyView, page: () => AboutPropertyView()),
    GetPage(name: contactOwnerView, page: () => ContactOwnerView()),
    GetPage(name: postPropertyView, page: () => PostPropertyView()),
    GetPage(name: addPropertyDetailsView, page: () => AddPropertyDetailsView()),
    GetPage(
        name: addPhotosAndPricingView, page: () => AddPhotoAndPricingView()),
    GetPage(name: addAmenitiesView, page: () => AddAmenitiesView()),
    GetPage(
        name: showPropertyDetailsView, page: () => ShowPropertyDetailsView()),
    GetPage(name: editPropertyView, page: () => EditPropertyView()),
    GetPage(
        name: editPropertyDetailsView, page: () => EditPropertyDetailsView()),
    GetPage(name: popularBuildersView, page: () => PopularBuildersView()),
    GetPage(name: savedPropertiesView, page: () => SavedPropertiesView()),
    GetPage(name: contactPropertyView, page: () => ContactPropertyView()),
    GetPage(
      name: AppRoutes.map,
      page: () => PropertyMapScreen(propertyResponse: Get.arguments), // Pass arguments
    ),
    GetPage(name: myNeeds, page: () => MyNeedsView()),
    GetPage(name: viewedPropertyView, page: () => ViewedPropertyView()),
    GetPage(name: recentActivityView, page: () => RecentActivityView()),
    GetPage(name: responsesView, page: () => ResponsesView()),
    GetPage(name: leadDetailsView, page: () => const LeadDetailsView()),
    GetPage(name: editProfileView, page: () => EditProfileView()),
    GetPage(name: agentsListView, page: () => AgentsListView()),
    GetPage(name: needDetails, page: () => CustomerNeedDetailView(need: Get.arguments)),

    GetPage(name: agentsDetailsView, page: () => AgentsDetailsView()),
    GetPage(
        name: addReviewsForBrokerView, page: () => AddReviewsForBrokerView()),
    GetPage(
        name: addReviewsForPropertyView,
        page: () => AddReviewsForPropertyView()),
    GetPage(name: interestingReadsView, page: () => InterestingReadsView()),
    GetPage(
        name: interestingReadsDetailsView,
        page: () => InterestingReadsDetailsView()),
    GetPage(name: communitySettingsView, page: () => CommunitySettingsView()),
    GetPage(name: feedbackView, page: () => FeedbackView()),
    GetPage(name: termsOfUseView, page: () => const TermsOfUseView()),
    GetPage(name: privacyPolicyView, page: () => const PrivacyPolicyView()),
    GetPage(name: termsconditionsView, page: () => const TermsConditionsView()),
    GetPage(name: aboutUsView, page: () => const AboutUsView()),
    GetPage(name: languagesView, page: () => LanguagesView()),
    GetPage(name: deleteListingView, page: () => DeleteListingView()),
    GetPage(name: activityView, page: () => ActivityView()),
  ];
}
