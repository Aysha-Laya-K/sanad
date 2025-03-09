import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/bottom_bar_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/home_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/popular_builders_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/activity/service_detail_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/agent_model.dart';

class PopularBuildersView extends StatelessWidget {
  PopularBuildersView({super.key});
  final agent = Get.arguments as AgentData;

  PopularBuildersController popularBuildersController =
      Get.put(PopularBuildersController());

  @override
  Widget build(BuildContext context) {

    var querySize = MediaQuery.of(context).size;
    popularBuildersController.isSimilarPropertyLiked.value =
        List<bool>.generate(
            popularBuildersController.searchImageList.length, (index) => false);
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildPopularBuildersList(querySize, AgentData),
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
       " Agent Details",
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    /*  actions: [
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.searchView);
          },
          child: Image.asset(
            Assets.images.search.path,
            width: AppSize.appSize24,
          ).paddingOnly(right: AppSize.appSize22),
        ),
        GestureDetector(
          onTap: () {
            Get.back();
            Future.delayed(
              const Duration(milliseconds: AppSize.size400),
              () {
                BottomBarController bottomBarController =
                    Get.put(BottomBarController());
                bottomBarController.pageController.jumpToPage(AppSize.size3);
              },
            );
          },
          child: Image.asset(
            Assets.images.save.path,
            width: AppSize.appSize24,
            color: AppColor.descriptionColor,
          ).paddingOnly(right: AppSize.appSize22),
        ),
        GestureDetector(
          onTap: () {
            Share.share(AppString.appName);
          },
          child: Image.asset(
            Assets.images.share.path,
            width: AppSize.appSize24,
          ).paddingOnly(right: AppSize.appSize16),
        ),
      ],*/
    );
  }

  Widget buildPopularBuildersList(Size querySize, AgentData) {
    HomeController homeController = Get.put(HomeController());
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSize.appSize20),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSize.appSize10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.appSize16),
              border: Border.all(
                color: AppColor.descriptionColor,
                width: AppSize.appSizePoint7,
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: AppSize.appSize80,
                  padding: const EdgeInsets.all(AppSize.appSize16),
                  decoration: BoxDecoration(
                    color: AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(AppSize.appSize12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.images.builder1.path,
                        width: AppSize.appSize48,
                      ).paddingOnly(right: AppSize.appSize10),
                      Text(
                        '${agent.name}',
                        style:
                            AppStyle.heading4Medium(color: AppColor.textColor),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      Assets.images.user.path,
                      width: AppSize.appSize20,
                    ).paddingOnly(right: AppSize.appSize6),
                    Text(
                      '${agent.name}',
                      style: AppStyle.heading5Regular(
                          color: AppColor.primaryColor),
                    ),
                  ],
                ).paddingOnly(top: AppSize.appSize12),
                Row(
                  children: [
                    Image.asset(
                      Assets.images.call.path,
                      width: AppSize.appSize20,
                    ).paddingOnly(right: AppSize.appSize6),
                    Text(
                      '${agent.phone}',
                      style: AppStyle.heading5Regular(
                          color: AppColor.primaryColor),
                    ),
                  ],
                ).paddingOnly(top: AppSize.appSize16),
                Row(
                  children: [
                    Image.asset(
                      Assets.images.email.path,
                      width: AppSize.appSize20,
                    ).paddingOnly(right: AppSize.appSize6),
                    Text(
                      '${agent.email}',
                      style: AppStyle.heading5Regular(
                          color: AppColor.primaryColor),
                    ),
                  ],
                ).paddingOnly(top: AppSize.appSize16),
              ],
            ),
          ).paddingOnly(left: AppSize.appSize16, right: AppSize.appSize16),
          // Text(
          //   AppString.properties,
          //   style: AppStyle.heading3SemiBold(color: AppColor.textColor),
          // ).paddingOnly(
          //   top: AppSize.appSize36,
          //   left: AppSize.appSize16, right: AppSize.appSize16,
          // ),
          // SizedBox(
          //   height: AppSize.appSize372,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     shrinkWrap: true,
          //     physics: const ClampingScrollPhysics(),
          //     padding: const EdgeInsets.only(left: AppSize.appSize16),
          //     itemCount: popularBuildersController.searchImageList.length,
          //     itemBuilder: (context, index) {
          //       return Container(
          //         width: AppSize.appSize300,
          //         padding: const EdgeInsets.all(AppSize.appSize10),
          //         margin: const EdgeInsets.only(right: AppSize.appSize16),
          //         decoration: BoxDecoration(
          //           color: AppColor.secondaryColor,
          //           borderRadius: BorderRadius.circular(AppSize.appSize12),
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Stack(
          //               children: [
          //                 Image.asset(
          //                   popularBuildersController.searchImageList[index],
          //                   height: AppSize.appSize200,
          //                 ),
          //                 Positioned(
          //                   right: AppSize.appSize6,
          //                   top: AppSize.appSize6,
          //                   child: GestureDetector(
          //                     onTap: () {
          //                       popularBuildersController.isSimilarPropertyLiked[index] =
          //                       !popularBuildersController.isSimilarPropertyLiked[index];
          //                     },
          //                     child: Container(
          //                       width: AppSize.appSize32,
          //                       height: AppSize.appSize32,
          //                       decoration: BoxDecoration(
          //                         color: AppColor.whiteColor.withOpacity(AppSize.appSizePoint50),
          //                         borderRadius: BorderRadius.circular(AppSize.appSize6),
          //                       ),
          //                       child: Center(
          //                         child: Obx(() => Image.asset(
          //                           popularBuildersController.isSimilarPropertyLiked[index]
          //                               ? Assets.images.saved.path
          //                               : Assets.images.save.path,
          //                           width: AppSize.appSize24,
          //                         )),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   popularBuildersController.searchTitleList[index],
          //                   style: AppStyle.heading5SemiBold(color: AppColor.textColor),
          //                 ),
          //                 Text(
          //                   popularBuildersController.searchAddressList[index],
          //                   style: AppStyle.heading5Regular(color: AppColor.descriptionColor),
          //                 ).paddingOnly(top: AppSize.appSize6),
          //               ],
          //             ).paddingOnly(top: AppSize.appSize8),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   popularBuildersController.searchRupeesList[index],
          //                   style: AppStyle.heading5Medium(color: AppColor.primaryColor),
          //                 ),
          //                 Row(
          //                   children: [
          //                     Text(
          //                       AppString.rating4Point5,
          //                       style: AppStyle.heading5Medium(color: AppColor.primaryColor),
          //                     ).paddingOnly(right: AppSize.appSize6),
          //                     Image.asset(
          //                       Assets.images.star.path,
          //                       width: AppSize.appSize18,
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ).paddingOnly(top: AppSize.appSize6),
          //             Divider(
          //               color: AppColor.descriptionColor.withOpacity(AppSize.appSizePoint3),
          //             ),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: List.generate(popularBuildersController.searchPropertyImageList.length, (index) {
          //                 return Container(
          //                   padding: const EdgeInsets.symmetric(
          //                     vertical: AppSize.appSize6, horizontal: AppSize.appSize16,
          //                   ),
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(AppSize.appSize12),
          //                     border: Border.all(
          //                       color: AppColor.primaryColor,
          //                       width: AppSize.appSizePoint50,
          //                     ),
          //                   ),
          //                   child: Row(
          //                     children: [
          //                       Image.asset(
          //                         popularBuildersController.searchPropertyImageList[index],
          //                         width: AppSize.appSize18,
          //                         height: AppSize.appSize18,
          //                       ).paddingOnly(right: AppSize.appSize6),
          //                       Text(
          //                         popularBuildersController.searchPropertyTitleList[index],
          //                         style: AppStyle.heading5Medium(color: AppColor.textColor),
          //                       ),
          //                     ],
          //                   ),
          //                 );
          //               }),
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ).paddingOnly(top: AppSize.appSize16),
         /* Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.upcomingProject,
                style: AppStyle.heading3SemiBold(color: AppColor.textColor),
              ),
              // Text(
              //   AppString.viewAll,
              //   style:
              //       AppStyle.heading5Medium(color: AppColor.descriptionColor),
              // ),
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
              itemCount: homeController.upcomingProjectImageList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                   /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceDetailScreen(),
                        ));*/
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: AppSize.appSize300,
                        margin: const EdgeInsets.only(right: AppSize.appSize16),
                        padding: const EdgeInsets.all(AppSize.appSize10),
                        decoration: BoxDecoration(
                          color: AppColor.textColor,
                          borderRadius:
                              BorderRadius.circular(AppSize.appSize12),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                homeController.upcomingProjectImageList[index]),
                          ),
                        ),
                      ),
                      Container(
                        width: AppSize.appSize300,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(101, 0, 0, 0),
                          borderRadius:
                              BorderRadius.circular(AppSize.appSize12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: querySize.width * 0.025),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    homeController
                                        .upcomingProjectTitleList[index],
                                    style: AppStyle.heading3(
                                        color: AppColor.whiteColor),
                                  ),
                                  Text(
                                    homeController
                                        .upcomingProjectPriceList[index],
                                    style: AppStyle.heading5(
                                        color: AppColor.whiteColor),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: querySize.height * 0.03,
                            )
                            // Text(
                            //   homeController.upcomingProjectAddressList[index],
                            //   style: AppStyle.heading5Regular(
                            //       color: AppColor.whiteColor),
                            // ).paddingOnly(top: AppSize.appSize6),
                            // Text(
                            //   homeController.upcomingProjectFlatSizeList[index],
                            //   style:
                            //       AppStyle.heading6Medium(color: AppColor.whiteColor),
                            // ).paddingOnly(top: AppSize.appSize6),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ).paddingOnly(top: AppSize.appSize16),*/
          // Text(
          //   AppString.upcomingProject,
          //   style: AppStyle.heading3SemiBold(color: AppColor.textColor),
          // ).paddingOnly(
          //   top: AppSize.appSize36,
          //   left: AppSize.appSize16,
          //   right: AppSize.appSize16,
          // ),
          // SizedBox(
          //   height: AppSize.appSize320,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     physics: const ClampingScrollPhysics(),
          //     padding: const EdgeInsets.only(left: AppSize.appSize16),
          //     scrollDirection: Axis.horizontal,
          //     itemCount:
          //         popularBuildersController.upcomingProjectImageList.length,
          //     itemBuilder: (context, index) {
          //       return Container(
          //         width: AppSize.appSize343,
          //         margin: const EdgeInsets.only(right: AppSize.appSize16),
          //         padding: const EdgeInsets.all(AppSize.appSize10),
          //         decoration: BoxDecoration(
          //           color: AppColor.whiteColor,
          //           borderRadius: BorderRadius.circular(AppSize.appSize12),
          //           image: DecorationImage(
          //             image: AssetImage(popularBuildersController
          //                 .upcomingProjectImageList[index]),
          //           ),
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.end,
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   popularBuildersController
          //                       .upcomingProjectTitleList[index],
          //                   style:
          //                       AppStyle.heading3(color: AppColor.whiteColor),
          //                 ),
          //                 Text(
          //                   popularBuildersController
          //                       .upcomingProjectPriceList[index],
          //                   style:
          //                       AppStyle.heading5(color: AppColor.whiteColor),
          //                 ),
          //               ],
          //             ),
          //             Text(
          //               popularBuildersController
          //                   .upcomingProjectAddressList[index],
          //               style: AppStyle.heading5Regular(
          //                   color: AppColor.whiteColor),
          //             ).paddingOnly(top: AppSize.appSize6),
          //             Text(
          //               popularBuildersController
          //                   .upcomingProjectFlatSizeList[index],
          //               style:
          //                   AppStyle.heading6Medium(color: AppColor.whiteColor),
          //             ).paddingOnly(top: AppSize.appSize6),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ).paddingOnly(top: AppSize.appSize16),
        ],
      ).paddingOnly(top: AppSize.appSize10),
    );
  }
}
