import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/common/common_status_bar.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/bottom_bar_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/home_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/widget/explore_city_bottom_sheet.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/widget/manage_property_bottom_sheet.dart';

class VendorHomeView extends StatefulWidget {
  const VendorHomeView({super.key});

  @override
  State<VendorHomeView> createState() => _VendorHomeViewState();
}

class _VendorHomeViewState extends State<VendorHomeView>
    with SingleTickerProviderStateMixin {
  HomeController homeController = Get.put(HomeController());
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildStatusContainer({
    required String title,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width * 0.43,
        padding: EdgeInsets.all(AppSize.appSize16),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 240, 178, 192)
              .withOpacity(0.1), //color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                Color.fromARGB(255, 241, 177, 198), /*color.withOpacity(0.3)*/
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor),
              // style: AppStyle.appHeading(
              //     color: AppColor.primaryColor,
              //     letterSpacing:
              //         0) //(color: AppColor.primaryColor /*color*/),
            ),
            SizedBox(height: AppSize.appSize2),
            Text(
              title,
              style: AppStyle.heading5SemiBold(
                  color: AppColor.primaryColor /*color*/),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusGrid({required bool isProperties}) {
    return Wrap(
      spacing: AppSize.appSize16,
      runSpacing: AppSize.appSize16,
      children: [
        _buildStatusContainer(
          title: isProperties ? 'Published Properties' : 'Published Services',
          count: '12',
          color: Colors.green,
          onTap: () {},
        ),
        _buildStatusContainer(
          title: isProperties ? 'Pending Properties' : 'Pending Services',
          count: '05',
          color: Colors.orange,
          onTap: () {},
        ),
        _buildStatusContainer(
          title: isProperties ? 'Rejected Properties' : 'Rejected Services',
          count: '02',
          color: Colors.red,
          onTap: () {},
        ),
        _buildStatusContainer(
          title: 'Booking Requests',
          count: '08',
          color: Colors.blue,
          onTap: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('${AppString().userType}-------------------------------------');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Your existing header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.hiFrancis,
                          style: AppStyle.heading5Medium(
                              color: AppColor.descriptionColor),
                        ),
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

            // TabBar
            Container(
              margin: EdgeInsets.all(AppSize.appSize16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColor.descriptionColor,
                tabs: const [
                  Tab(text: 'Properties'),
                  Tab(text: 'Services'),
                ],
              ),
            ),

            // TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Properties Tab
                  SingleChildScrollView(
                    padding: EdgeInsets.all(AppSize.appSize16),
                    child: _buildStatusGrid(isProperties: true),
                  ),

                  // Services Tab
                  SingleChildScrollView(
                    padding: EdgeInsets.all(AppSize.appSize16),
                    child: _buildStatusGrid(isProperties: false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class _VendorHomeViewState extends State<VendorHomeView> {
//   HomeController homeController = Get.put(HomeController());
//   final ScrollController _scrollController = ScrollController();

//   void _scrollToBottom() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       // GestureDetector(
//                       //   onTap: () {
//                       //     Scaffold.of(context).openDrawer();
//                       //   },
//                       //   child: Image.asset(
//                       //     Assets.images.drawer.path,
//                       //     width: AppSize.appSize40,
//                       //     height: AppSize.appSize40,
//                       //   ).paddingOnly(right: AppSize.appSize16),
//                       // ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             AppString.hiFrancis,
//                             style: AppStyle.heading5Medium(
//                                 color: AppColor.descriptionColor),
//                           ),
//                           Text(
//                             AppString.welcome,
//                             style: AppStyle.heading3Medium(
//                                 color: AppColor.primaryColor),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Get.toNamed(AppRoutes.notificationView);
//                     },
//                     child: Image.asset(
//                       Assets.images.notification.path,
//                       width: AppSize.appSize40,
//                       height: AppSize.appSize40,
//                     ),
//                   )
//                 ],
//               ).paddingOnly(
//                 left: AppSize.appSize16,
//                 right: AppSize.appSize16,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//     // homeController.isTrendPropertyLiked.value = List<bool>.generate(
//     //     homeController.searchImageList.length, (index) => false);
//     // return Stack(
//     //   children: [
//     //     Scaffold(
//     //       backgroundColor: AppColor.whiteColor,
//     //       body: buildHome(context),
//     //     ),
//     //     const CommonStatusBar(),
//     //   ],
//     // );
//   }

//   Widget buildHome(BuildContext context) {
//     var querySize = MediaQuery.of(context).size;
//     return SingleChildScrollView(
//       controller: _scrollController,
//       physics: const ClampingScrollPhysics(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Scaffold.of(context).openDrawer();
//                     },
//                     child: Image.asset(
//                       Assets.images.drawer.path,
//                       width: AppSize.appSize40,
//                       height: AppSize.appSize40,
//                     ).paddingOnly(right: AppSize.appSize16),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         AppString.hiFrancis,
//                         style: AppStyle.heading5Medium(
//                             color: AppColor.descriptionColor),
//                       ),
//                       Text(
//                         AppString.welcome,
//                         style: AppStyle.heading3Medium(
//                             color: AppColor.primaryColor),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Get.toNamed(AppRoutes.notificationView);
//                 },
//                 child: Image.asset(
//                   Assets.images.notification.path,
//                   width: AppSize.appSize40,
//                   height: AppSize.appSize40,
//                 ),
//               )
//             ],
//           ).paddingOnly(
//             left: AppSize.appSize16,
//             right: AppSize.appSize16,
//           ),
//           // SingleChildScrollView(
//           //   physics: const ClampingScrollPhysics(),
//           //   padding: const EdgeInsets.only(left: AppSize.appSize16),
//           //   scrollDirection: Axis.horizontal,
//           //   child: Row(
//           //     children: List.generate(homeController.propertyOptionList.length,
//           //         (index) {
//           //       return GestureDetector(
//           //         onTap: () {
//           //           homeController.updateProperty(index);
//           //           if (index == AppSize.size7) {
//           //             Get.toNamed(AppRoutes.postPropertyView);
//           //           }
//           //         },
//           //         child: Obx(() => Container(
//           //               height: AppSize.appSize37,
//           //               margin: const EdgeInsets.only(right: AppSize.appSize16),
//           //               padding: const EdgeInsets.symmetric(
//           //                   horizontal: AppSize.appSize14),
//           //               decoration: BoxDecoration(
//           //                 borderRadius:
//           //                     BorderRadius.circular(AppSize.appSize12),
//           //                 color: homeController.selectProperty.value == index
//           //                     ? AppColor.primaryColor
//           //                     : AppColor.backgroundColor,
//           //               ),
//           //               child: Center(
//           //                 child: Text(
//           //                   homeController.propertyOptionList[index],
//           //                   style: AppStyle.heading5Regular(
//           //                     color:
//           //                         homeController.selectProperty.value == index
//           //                             ? AppColor.whiteColor
//           //                             : AppColor.descriptionColor,
//           //                   ),
//           //                 ),
//           //               ),
//           //             )),
//           //       );
//           //     }),
//           //   ).paddingOnly(top: AppSize.appSize26),
//           // ),
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(AppSize.appSize12),
//               color: AppColor.whiteColor,
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   spreadRadius: AppSize.appSizePoint1,
//                   blurRadius: AppSize.appSize2,
//                 ),
//               ],
//             ),
//             child: TextFormField(
//               controller: homeController.searchController,
//               cursorColor: AppColor.primaryColor,
//               style: AppStyle.heading4Regular(color: AppColor.textColor),
//               readOnly: true,
//               onTap: () {
//                 Get.toNamed(AppRoutes.searchView);
//               },
//               decoration: InputDecoration(
//                 hintText: AppString.searchCity,
//                 hintStyle:
//                     AppStyle.heading4Regular(color: AppColor.descriptionColor),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(AppSize.appSize12),
//                   borderSide: BorderSide.none,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(AppSize.appSize12),
//                   borderSide: BorderSide.none,
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(AppSize.appSize12),
//                   borderSide: BorderSide.none,
//                 ),
//                 prefixIcon: Padding(
//                   padding: const EdgeInsets.only(
//                     left: AppSize.appSize16,
//                     right: AppSize.appSize16,
//                   ),
//                   child: Image.asset(
//                     Assets.images.search.path,
//                   ),
//                 ),
//                 prefixIconConstraints: const BoxConstraints(
//                   maxWidth: AppSize.appSize51,
//                 ),
//               ),
//             ),
//           ).paddingOnly(
//             top: AppSize.appSize20,
//             left: AppSize.appSize16,
//             right: AppSize.appSize16,
//           ),
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     Text(
//           //       AppString.yourListing,
//           //       style: AppStyle.heading3SemiBold(color: AppColor.textColor),
//           //     ),
//           //     GestureDetector(
//           //       onTap: () {
//           //         BottomBarController bottomBarController =
//           //             Get.put(BottomBarController());
//           //         bottomBarController.pageController.jumpToPage(AppSize.size1);
//           //       },
//           //       child: Text(
//           //         AppString.viewAll,
//           //         style:
//           //             AppStyle.heading5Medium(color: AppColor.descriptionColor),
//           //       ),
//           //     ),
//           //   ],
//           // ).paddingOnly(
//           //   top: AppSize.appSize26,
//           //   left: AppSize.appSize16,
//           //   right: AppSize.appSize16,
//           // ),
//           // Container(
//           //   padding: const EdgeInsets.all(AppSize.appSize10),
//           //   margin: const EdgeInsets.only(top: AppSize.appSize16),
//           //   decoration: BoxDecoration(
//           //     color: AppColor.primaryColor,
//           //     borderRadius: BorderRadius.circular(AppSize.appSize12),
//           //   ),
//           //   child: IntrinsicHeight(
//           //     child: Row(
//           //       children: [
//           //         Image.asset(
//           //           Assets.images.property1.path,
//           //           width: AppSize.appSize112,
//           //         ).paddingOnly(right: AppSize.appSize16),
//           //         Expanded(
//           //           child: Column(
//           //             crossAxisAlignment: CrossAxisAlignment.start,
//           //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //             mainAxisSize: MainAxisSize.max,
//           //             children: [
//           //               Text(
//           //                 AppString.rupees50Lac,
//           //                 style: AppStyle.heading5Medium(
//           //                     color: AppColor.whiteColor),
//           //               ),
//           //               Column(
//           //                 crossAxisAlignment: CrossAxisAlignment.start,
//           //                 children: [
//           //                   Text(
//           //                     AppString.sellFlat,
//           //                     style: AppStyle.heading5SemiBold(
//           //                         color: AppColor.whiteColor),
//           //                   ),
//           //                   Text(
//           //                     AppString.northBombaySociety,
//           //                     style: AppStyle.heading5Regular(
//           //                         color: AppColor.whiteColor),
//           //                   ),
//           //                 ],
//           //               ),
//           //               IntrinsicWidth(
//           //                 child: GestureDetector(
//           //                   onTap: () {
//           //                     managePropertyBottomSheet(context);
//           //                   },
//           //                   child: Column(
//           //                     crossAxisAlignment: CrossAxisAlignment.start,
//           //                     children: [
//           //                       Text(
//           //                         AppString.manageProperty,
//           //                         style: AppStyle.heading5Medium(
//           //                             color: AppColor.whiteColor),
//           //                       ),
//           //                       Container(
//           //                         margin: const EdgeInsets.only(
//           //                             top: AppSize.appSize3),
//           //                         height: AppSize.appSize1,
//           //                         color: AppColor.whiteColor,
//           //                       ),
//           //                     ],
//           //                   ),
//           //                 ),
//           //               ),
//           //             ],
//           //           ),
//           //         ),
//           //       ],
//           //     ),
//           //   ),
//           // ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
//           SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             padding: const EdgeInsets.only(
//               left: AppSize.appSize16,
//               right: AppSize.appSize16,
//             ),
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: List.generate(homeController.countryOptionList.length,
//                   (index) {
//                 return GestureDetector(
//                   onTap: () {
//                     homeController.updateCountry(index);
//                     if (index == AppSize.size2) {
//                       _scrollToBottom();
//                     }
//                     if (index == AppSize.size3) {
//                       Get.toNamed(AppRoutes.searchView);
//                     }
//                   },
//                   child: Obx(() => Container(
//                         height: AppSize.appSize25,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: AppSize.appSize14),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(
//                               color: homeController.selectCountry.value == index
//                                   ? AppColor.primaryColor
//                                   : AppColor.borderColor,
//                               width: AppSize.appSize1,
//                             ),
//                             right: BorderSide(
//                               color: index == AppSize.size3
//                                   ? Colors.transparent
//                                   : AppColor.borderColor,
//                               width: AppSize.appSize1,
//                             ),
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             homeController.countryOptionList[index],
//                             style: AppStyle.heading5Medium(
//                               color: homeController.selectCountry.value == index
//                                   ? AppColor.primaryColor
//                                   : AppColor.textColor,
//                             ),
//                           ),
//                         ),
//                       )),
//                 );
//               }),
//             ).paddingOnly(top: AppSize.appSize36),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 AppString.recommendedProject,
//                 style: AppStyle.heading3SemiBold(color: AppColor.textColor),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Get.toNamed(AppRoutes.propertyListView);
//                 },
//                 child: Text(
//                   AppString.viewAll,
//                   style:
//                       AppStyle.heading5Medium(color: AppColor.descriptionColor),
//                 ),
//               ),
//             ],
//           ).paddingOnly(
//             top: AppSize.appSize26,
//             left: AppSize.appSize16,
//             right: AppSize.appSize16,
//           ),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             physics: const ClampingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: AppSize.appSize282,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     padding: const EdgeInsets.only(left: AppSize.appSize16),
//                     itemCount: homeController.projectImageList.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           Get.toNamed(AppRoutes.propertyDetailsView);
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(AppSize.appSize10),
//                           margin:
//                               const EdgeInsets.only(right: AppSize.appSize16),
//                           decoration: BoxDecoration(
//                             color: AppColor.secondaryColor,
//                             borderRadius:
//                                 BorderRadius.circular(AppSize.appSize12),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Image.asset(
//                                 homeController.projectImageList[index],
//                                 height: AppSize.appSize130,
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.all(AppSize.appSize6),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: AppColor.primaryColor,
//                                   ),
//                                   borderRadius:
//                                       BorderRadius.circular(AppSize.appSize12),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     homeController.projectPriceList[index],
//                                     style: AppStyle.heading5Medium(
//                                         color: AppColor.primaryColor),
//                                   ),
//                                 ),
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     homeController.projectTitleList[index],
//                                     style: AppStyle.heading5SemiBold(
//                                         color: AppColor.textColor),
//                                   ),
//                                   Text(
//                                     homeController.projectAddressList[index],
//                                     style: AppStyle.heading5Regular(
//                                         color: AppColor.descriptionColor),
//                                   ).paddingOnly(top: AppSize.appSize6),
//                                 ],
//                               ),
//                               Text(
//                                 homeController.projectTimingList[index],
//                                 style: AppStyle.heading6Regular(
//                                     color: AppColor.descriptionColor),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ).paddingOnly(top: AppSize.appSize16),
//                 SizedBox(
//                   height: AppSize.appSize282,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     padding: const EdgeInsets.only(left: AppSize.appSize16),
//                     itemCount: homeController.project2ImageList.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         padding: const EdgeInsets.all(AppSize.appSize10),
//                         margin: const EdgeInsets.only(right: AppSize.appSize16),
//                         decoration: BoxDecoration(
//                           color: AppColor.secondaryColor,
//                           borderRadius:
//                               BorderRadius.circular(AppSize.appSize12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Image.asset(
//                               homeController.project2ImageList[index],
//                               height: AppSize.appSize130,
//                             ),
//                             Container(
//                               padding: const EdgeInsets.all(AppSize.appSize6),
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: AppColor.primaryColor,
//                                 ),
//                                 borderRadius:
//                                     BorderRadius.circular(AppSize.appSize12),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   homeController.project2PriceList[index],
//                                   style: AppStyle.heading5Medium(
//                                       color: AppColor.primaryColor),
//                                 ),
//                               ),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   homeController.project2TitleList[index],
//                                   style: AppStyle.heading5SemiBold(
//                                       color: AppColor.textColor),
//                                 ),
//                                 Text(
//                                   homeController.project2AddressList[index],
//                                   style: AppStyle.heading5Regular(
//                                       color: AppColor.descriptionColor),
//                                 ).paddingOnly(top: AppSize.appSize6),
//                               ],
//                             ),
//                             Text(
//                               homeController.project2TimingList[index],
//                               style: AppStyle.heading6Regular(
//                                   color: AppColor.descriptionColor),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ).paddingOnly(top: AppSize.appSize16),
//               ],
//             ),
//           ),
//           // Text(
//           //   AppString.recentResponse,
//           //   style: AppStyle.heading3SemiBold(color: AppColor.textColor),
//           // ).paddingOnly(
//           //   top: AppSize.appSize26,
//           //   left: AppSize.appSize16,
//           //   right: AppSize.appSize16,
//           // ),
//           // SizedBox(
//           //   height: AppSize.appSize150,
//           //   child: ListView.builder(
//           //     shrinkWrap: true,
//           //     scrollDirection: Axis.horizontal,
//           //     physics: const ClampingScrollPhysics(),
//           //     padding: const EdgeInsets.only(left: AppSize.appSize16),
//           //     itemCount: homeController.responseImageList.length,
//           //     itemBuilder: (context, index) {
//           //       return Container(
//           //         padding: const EdgeInsets.all(AppSize.appSize10),
//           //         margin: const EdgeInsets.only(right: AppSize.appSize16),
//           //         decoration: BoxDecoration(
//           //           border: Border.all(
//           //             color: AppColor.descriptionColor
//           //                 .withOpacity(AppSize.appSizePoint50),
//           //           ),
//           //           borderRadius: BorderRadius.circular(AppSize.appSize12),
//           //         ),
//           //         child: Column(
//           //           crossAxisAlignment: CrossAxisAlignment.start,
//           //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //           children: [
//           //             Container(
//           //               padding: const EdgeInsets.all(AppSize.appSize10),
//           //               decoration: BoxDecoration(
//           //                 color: AppColor.backgroundColor,
//           //                 borderRadius:
//           //                     BorderRadius.circular(AppSize.appSize16),
//           //               ),
//           //               child: Row(
//           //                 children: [
//           //                   Image.asset(
//           //                     homeController.responseImageList[index],
//           //                     width: AppSize.appSize50,
//           //                     height: AppSize.appSize50,
//           //                   ).paddingOnly(right: AppSize.appSize10),
//           //                   Column(
//           //                     crossAxisAlignment: CrossAxisAlignment.start,
//           //                     children: [
//           //                       Text(
//           //                         homeController.responseNameList[index],
//           //                         style: AppStyle.heading4Medium(
//           //                             color: AppColor.textColor),
//           //                       ).paddingOnly(bottom: AppSize.appSize4),
//           //                       IntrinsicHeight(
//           //                         child: Row(
//           //                           children: [
//           //                             Text(
//           //                               AppString.buyer,
//           //                               style: AppStyle.heading5Regular(
//           //                                   color: AppColor.descriptionColor),
//           //                             ),
//           //                             const VerticalDivider(
//           //                               color: AppColor.borderColor,
//           //                               width: AppSize.appSize20,
//           //                               indent: AppSize.appSize2,
//           //                               endIndent: AppSize.appSize2,
//           //                             ),
//           //                             Text(
//           //                               homeController
//           //                                   .responseTimingList[index],
//           //                               style: AppStyle.heading5Regular(
//           //                                   color: AppColor.descriptionColor),
//           //                             ),
//           //                           ],
//           //                         ),
//           //                       ),
//           //                     ],
//           //                   ),
//           //                 ],
//           //               ),
//           //             ),
//           //             Column(
//           //               crossAxisAlignment: CrossAxisAlignment.start,
//           //               children: [
//           //                 Row(
//           //                   children: [
//           //                     Image.asset(
//           //                       Assets.images.call.path,
//           //                       width: AppSize.appSize14,
//           //                     ).paddingOnly(right: AppSize.appSize6),
//           //                     Text(
//           //                       AppString.number1,
//           //                       style: AppStyle.heading6Regular(
//           //                           color: AppColor.primaryColor),
//           //                     ),
//           //                   ],
//           //                 ),
//           //                 Row(
//           //                   children: [
//           //                     Image.asset(
//           //                       Assets.images.email.path,
//           //                       width: AppSize.appSize14,
//           //                     ).paddingOnly(right: AppSize.appSize6),
//           //                     Text(
//           //                       homeController.responseEmailList[index],
//           //                       style: AppStyle.heading6Regular(
//           //                           color: AppColor.primaryColor),
//           //                     ),
//           //                   ],
//           //                 ).paddingOnly(top: AppSize.appSize8),
//           //               ],
//           //             ),
//           //           ],
//           //         ),
//           //       );
//           //     },
//           //   ),
//           // ).paddingOnly(top: AppSize.appSize16),
//           Text(
//             AppString.basedOnSearchTrends,
//             style: AppStyle.heading3SemiBold(color: AppColor.textColor),
//           ).paddingOnly(
//             top: AppSize.appSize26,
//             left: AppSize.appSize16,
//             right: AppSize.appSize16,
//           ),
//           SizedBox(
//             height: AppSize.appSize372,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               shrinkWrap: true,
//               physics: const ClampingScrollPhysics(),
//               padding: const EdgeInsets.only(left: AppSize.appSize16),
//               itemCount: homeController.searchImageList.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     Get.toNamed(AppRoutes.propertyDetailsView);
//                   },
//                   child: Container(
//                     width: AppSize.appSize300,
//                     padding: const EdgeInsets.all(AppSize.appSize10),
//                     margin: const EdgeInsets.only(right: AppSize.appSize16),
//                     decoration: BoxDecoration(
//                       color: AppColor.secondaryColor,
//                       borderRadius: BorderRadius.circular(AppSize.appSize12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Stack(
//                           children: [
//                             Image.asset(
//                               homeController.searchImageList[index],
//                               height: AppSize.appSize200,
//                             ),
//                             Positioned(
//                               right: AppSize.appSize6,
//                               top: AppSize.appSize6,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   homeController.isTrendPropertyLiked[index] =
//                                       !homeController
//                                           .isTrendPropertyLiked[index];
//                                 },
//                                 child: Container(
//                                   width: AppSize.appSize32,
//                                   height: AppSize.appSize32,
//                                   decoration: BoxDecoration(
//                                     color: AppColor.whiteColor
//                                         .withOpacity(AppSize.appSizePoint50),
//                                     borderRadius:
//                                         BorderRadius.circular(AppSize.appSize6),
//                                   ),
//                                   child: Center(
//                                     child: Obx(() => Image.asset(
//                                           homeController
//                                                   .isTrendPropertyLiked[index]
//                                               ? Assets.images.saved.path
//                                               : Assets.images.save.path,
//                                           width: AppSize.appSize24,
//                                         )),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               homeController.searchTitleList[index],
//                               style: AppStyle.heading5SemiBold(
//                                   color: AppColor.textColor),
//                             ),
//                             Text(
//                               homeController.searchAddressList[index],
//                               style: AppStyle.heading5Regular(
//                                   color: AppColor.descriptionColor),
//                             ).paddingOnly(top: AppSize.appSize6),
//                           ],
//                         ).paddingOnly(top: AppSize.appSize8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               homeController.searchRupeesList[index],
//                               style: AppStyle.heading5Medium(
//                                   color: AppColor.primaryColor),
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   AppString.rating4Point5,
//                                   style: AppStyle.heading5Medium(
//                                       color: AppColor.primaryColor),
//                                 ).paddingOnly(right: AppSize.appSize6),
//                                 Image.asset(
//                                   Assets.images.star.path,
//                                   width: AppSize.appSize18,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ).paddingOnly(top: AppSize.appSize6),
//                         Divider(
//                           color: AppColor.descriptionColor
//                               .withOpacity(AppSize.appSizePoint3),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: List.generate(
//                               homeController.searchPropertyImageList.length,
//                               (index) {
//                             return Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: AppSize.appSize6,
//                                 horizontal: AppSize.appSize16,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.circular(AppSize.appSize12),
//                                 border: Border.all(
//                                   color: AppColor.primaryColor,
//                                   width: AppSize.appSizePoint50,
//                                 ),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Image.asset(
//                                     homeController
//                                         .searchPropertyImageList[index],
//                                     width: AppSize.appSize18,
//                                     height: AppSize.appSize18,
//                                   ).paddingOnly(right: AppSize.appSize6),
//                                   Text(
//                                     homeController
//                                         .searchPropertyTitleList[index],
//                                     style: AppStyle.heading5Medium(
//                                         color: AppColor.textColor),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ).paddingOnly(top: AppSize.appSize16),
//           Row(
//             children: [
//               Text(
//                 AppString.popularBuilders,
//                 style: AppStyle.heading3SemiBold(color: AppColor.textColor),
//               ),
//               Text(
//                 AppString.inWesternMumbai,
//                 style:
//                     AppStyle.heading5Regular(color: AppColor.descriptionColor),
//               ),
//             ],
//           ).paddingOnly(
//             top: AppSize.appSize26,
//             left: AppSize.appSize16,
//             right: AppSize.appSize16,
//           ),
//           SizedBox(
//             height: AppSize.appSize95,
//             child: ListView.builder(
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               physics: const ClampingScrollPhysics(),
//               padding: const EdgeInsets.only(left: AppSize.appSize16),
//               itemCount: homeController.popularBuilderImageList.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     if (index == AppSize.size0) {
//                       Get.toNamed(AppRoutes.popularBuildersView);
//                     }
//                   },
//                   child: Container(
//                     width: AppSize.appSize160,
//                     padding: const EdgeInsets.symmetric(
//                       vertical: AppSize.appSize16,
//                       horizontal: AppSize.appSize10,
//                     ),
//                     margin: const EdgeInsets.only(right: AppSize.appSize16),
//                     decoration: BoxDecoration(
//                       color: AppColor.secondaryColor,
//                       borderRadius: BorderRadius.circular(AppSize.appSize12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Center(
//                           child: Image.asset(
//                             homeController.popularBuilderImageList[index],
//                             width: AppSize.appSize30,
//                             height: AppSize.appSize30,
//                           ),
//                         ),
//                         Center(
//                           child: Text(
//                             homeController.popularBuilderTitleList[index],
//                             style: AppStyle.heading5Medium(
//                                 color: AppColor.textColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ).paddingOnly(top: AppSize.appSize16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 AppString.upcomingProject,
//                 style: AppStyle.heading3SemiBold(color: AppColor.textColor),
//               ),
//               Text(
//                 AppString.viewAll,
//                 style:
//                     AppStyle.heading5Medium(color: AppColor.descriptionColor),
//               ),
//             ],
//           ).paddingOnly(
//             top: AppSize.appSize26,
//             left: AppSize.appSize16,
//             right: AppSize.appSize16,
//           ),
//           SizedBox(
//             height: AppSize.appSize200,
//             child: ListView.builder(
//               shrinkWrap: true,
//               physics: const ClampingScrollPhysics(),
//               padding: const EdgeInsets.only(left: AppSize.appSize16),
//               scrollDirection: Axis.horizontal,
//               itemCount: homeController.upcomingProjectImageList.length,
//               itemBuilder: (context, index) {
//                 return Stack(
//                   children: [
//                     Container(
//                       width: AppSize.appSize300,
//                       margin: const EdgeInsets.only(right: AppSize.appSize16),
//                       padding: const EdgeInsets.all(AppSize.appSize10),
//                       decoration: BoxDecoration(
//                         color: AppColor.textColor,
//                         borderRadius: BorderRadius.circular(AppSize.appSize12),
//                         image: DecorationImage(
//                           fit: BoxFit.cover,
//                           image: AssetImage(
//                               homeController.upcomingProjectImageList[index]),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: AppSize.appSize300,
//                       decoration: BoxDecoration(
//                         color: Color.fromARGB(101, 0, 0, 0),
//                         borderRadius: BorderRadius.circular(AppSize.appSize12),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: querySize.width * 0.025),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   homeController
//                                       .upcomingProjectTitleList[index],
//                                   style: AppStyle.heading3(
//                                       color: AppColor.whiteColor),
//                                 ),
//                                 Text(
//                                   homeController
//                                       .upcomingProjectPriceList[index],
//                                   style: AppStyle.heading5(
//                                       color: AppColor.whiteColor),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: querySize.height * 0.03,
//                           )
//                           // Text(
//                           //   homeController.upcomingProjectAddressList[index],
//                           //   style: AppStyle.heading5Regular(
//                           //       color: AppColor.whiteColor),
//                           // ).paddingOnly(top: AppSize.appSize6),
//                           // Text(
//                           //   homeController.upcomingProjectFlatSizeList[index],
//                           //   style:
//                           //       AppStyle.heading6Medium(color: AppColor.whiteColor),
//                           // ).paddingOnly(top: AppSize.appSize6),
//                         ],
//                       ),
//                     )
//                   ],
//                 );
//               },
//             ),
//           ).paddingOnly(top: AppSize.appSize16),
//           // Text(
//           //   AppString.explorePopularCity,
//           //   style: AppStyle.heading3SemiBold(color: AppColor.textColor),
//           // ).paddingOnly(
//           //   top: AppSize.appSize26,
//           //   left: AppSize.appSize16, right: AppSize.appSize16,
//           // ),
//           // SizedBox(
//           //   height: AppSize.appSize100,
//           //   child: ListView.builder(
//           //     shrinkWrap: true,
//           //     physics: const ClampingScrollPhysics(),
//           //     padding: const EdgeInsets.only(left: AppSize.appSize16),
//           //     scrollDirection: Axis.horizontal,
//           //     itemCount: homeController.popularCityImageList.length,
//           //     itemBuilder: (context, index) {
//           //       return GestureDetector(
//           //         onTap: () {
//           //           exploreCityBottomSheet(context);
//           //         },
//           //         child: Container(
//           //           width: AppSize.appSize100,
//           //           margin: const EdgeInsets.only(right: AppSize.appSize16),
//           //           padding: const EdgeInsets.only(bottom: AppSize.appSize10),
//           //           decoration: BoxDecoration(
//           //             color: AppColor.whiteColor,
//           //             borderRadius: BorderRadius.circular(AppSize.appSize16),
//           //             image: DecorationImage(
//           //               image: AssetImage(homeController.popularCityImageList[index]),
//           //             ),
//           //           ),
//           //           child: Align(
//           //             alignment: Alignment.bottomCenter,
//           //             child: Text(
//           //               homeController.popularCityTitleList[index],
//           //               style: AppStyle.heading5Medium(color: AppColor.whiteColor),
//           //             ),
//           //           ),
//           //         ),
//           //       );
//           //     },
//           //   ),
//           // ).paddingOnly(top: AppSize.appSize16),
//         ],
//       ).paddingOnly(top: AppSize.appSize50, bottom: AppSize.appSize20),
//     );
//   }
// }
