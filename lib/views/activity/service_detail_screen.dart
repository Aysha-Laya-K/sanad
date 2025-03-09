import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/activity/widgets/custom_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/servicedetails_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/activity_controller.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html;
import 'package:html_unescape/html_unescape.dart';
import 'package:html/parser.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/flutter_html.dart';



class ServiceDetailScreen extends StatefulWidget {
   // Declare the serviceDetails as required
  final ServiceDetails serviceDetails;
  //final ActivityController activityController = Get.put(ActivityController()); // Add this line before using the controller// Accept service details

  const ServiceDetailScreen({Key? key, required this.serviceDetails}) : super(key: key);





  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int detailActiveIndex = 0;
  late ActivityController activityController;

  String cleanDescription(String htmlString) {
    // Decode HTML entities multiple times
    HtmlUnescape unescape = HtmlUnescape();
    String decodedString = unescape.convert(htmlString);
    decodedString = unescape.convert(decodedString); // Double decoding

    // Parse the decoded HTML string and extract text content
    final document = html.parse(decodedString);
    String parsedString = document.body?.text ?? '';

    // Ensure no HTML tags remain
    parsedString = parsedString.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove extra spaces, new lines, and trim
    parsedString = parsedString.replaceAll(RegExp(r'\s+'), ' ').trim();

    return parsedString;
  }





  @override
  void initState() {
    // print('---------------------------------${widget.productId}');
    // Initialize TabController in initState and use vsync: this
    _tabController = TabController(length: 2, vsync: this);
    activityController = Get.put(ActivityController());
    // Provider.of<ProductDetailProvider>(context, listen: false)
    //     .fetchProductDetails(id: widget.productId);
    // _fetchWishlistStatus();
    super.initState();
  }

  // Future<void> _fetchWishlistStatus() async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   final token = await authProvider.getToken();

  //   if (token != null) {
  //     final wishlistProvider =
  //         Provider.of<WishlistProvider>(context, listen: false);
  //     await wishlistProvider.fetchWishlist(token);
  //   }
  // }

  @override
  void dispose() {
    // Dispose of the TabController when the widget is disposed
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  print('---------------------------------${widget.productId}');
    var querySize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.white,
        body:
            //  Consumer<ProductDetailProvider>(
            //   builder: (context, productDetailProvidervalue, child) {
            // if (productDetailProvidervalue.isLoading) {
            //   return multipleShimmerLoading(
            //       containerHeight: querySize.height * 0.06);
            //   // return lenoreGif(querySize);
            // }
            // if (productDetailProvidervalue.productDetails == null) {
            //   return Container(
            //     height: 200,
            //     width: 200,
            //     color: Colors.red,
            //   );
            // }

            //return
            Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: querySize.width * 0.03),
                      child: Column(
                        children: [
                          SizedBox(
                            height: querySize.height * 0.01,
                          ),
                          // customTopBar(querySize, context),
                          SizedBox(height: querySize.height * 0.02),
                          Stack(
                            children: [
                              // CarouselSlider and other elements
                              CarouselSlider.builder(
                                itemCount: widget.serviceDetails.sliderImages.length, // productDetailProvidervalue
                                //     .productDetails!.data!.images!.length,
                                itemBuilder: (context, index, realIndex) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: querySize.width * 0.025),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              querySize.height * 0.01),
                                          image: DecorationImage(
                                            image: NetworkImage(widget.serviceDetails.sliderImages[index]), // Dynamically use the image from sliderImages
                                             //NetworkImage(
                                            // productDetailProvidervalue
                                            //     .productDetails!
                                            //     .data!
                                            //     .images![index]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                options: CarouselOptions(
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      detailActiveIndex = index;
                                    });
                                  },
                                  viewportFraction: 1,
                                  height: querySize.height * 0.35,
                                  autoPlay: false,
                                  autoPlayInterval: const Duration(seconds: 4),
                                ),
                              ),
                              // Indicator or other widgets
                              Positioned(
                                bottom: querySize.height * 0.016,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: AnimatedSmoothIndicator(
                                    activeIndex: detailActiveIndex,
                                    count: widget.serviceDetails.sliderImages.length, //productDetailProvidervalue
                                    //.productDetails!.data!.images!.length,
                                    effect: SlideEffect(
                                      dotHeight: querySize.height * 0.008,
                                      dotWidth: querySize.width * 0.018,
                                      activeDotColor: Colors.amber,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )

                          // Container(
                          //   width: querySize.width * 0.94,
                          //   height: querySize.width * 0.9,
                          //   decoration: BoxDecoration(
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.black.withOpacity(0.3),
                          //         offset: const Offset(0, 4),
                          //         blurRadius: querySize.width * 0.008,
                          //         spreadRadius: 0,
                          //       ),
                          //     ],
                          //     color: const Color(0xFFE7E7E7),
                          //     borderRadius:
                          //         BorderRadius.circular(querySize.width * 0.02),
                          //     image: const DecorationImage(
                          //       image:
                          //           AssetImage("assets/images/wishlist_one.png"),
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Padding(
                          //         padding: EdgeInsets.only(
                          //             top: querySize.height * 0.008,
                          //             right: querySize.height * 0.012),
                          //         child: Row(
                          //           children: [
                          // Image.asset(
                          //   'assets/images/product_detail_image/share.png',
                          //   width: querySize.width * 0.04,
                          //   height: querySize.height * 0.017,
                          // ),
                          // SizedBox(
                          //   width: querySize.width * 0.03,
                          // ),
                          // Image.asset(
                          //   'assets/images/home/favourite.png',
                          //   width: querySize.width * 0.075,
                          //   height: querySize.height * 0.037,
                          // ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: querySize.width * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [],
                          ),
                          SizedBox(
                            height: querySize.height * 0.03,
                          ),
                          Text(
                            widget.serviceDetails.title,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.primaryColor,
                                fontFamily: 'Segoe',
                                fontSize: querySize.width * 0.049),
                          ),
                          SizedBox(
                            height: querySize.height * 0.01,
                          ),
                          Text(
                            'QAR  ${widget.serviceDetails.startingPrice} ',
                            style: TextStyle(
                                fontFamily: 'ElMessirisemibold',
                                fontSize: querySize.height * 0.020,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: querySize.height * 0.01,
                          ),
                          Row(
                            children: [
                              Text(
                                widget.serviceDetails.location ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily: 'Segoe',
                                    fontSize: querySize.width * 0.035),
                              ),
                             /* GestureDetector(
                                onTap: () async {
                                  // Replace these with your actual latitude and longitude
                                  final double latitude = 10.22;
                                  final double longitude = 10.22;

                                  final String googleMapsUrl =
                                      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

                                  if (await canLaunchUrl(
                                      Uri.parse(googleMapsUrl))) {
                                    await launchUrl(Uri.parse(googleMapsUrl));
                                  } else {
                                    // Handle error - unable to launch maps
                                    print('Could not launch Google Maps');
                                  }
                                },
                                child: Text(
                                  '    View On Map',
                                  style: TextStyle(
                                      color: AppColor.primaryColor,
                                      fontFamily: 'Segoe',
                                      fontSize: querySize.width * 0.035,
                                      fontWeight: FontWeight.w600),
                                ),
                              )*/
                              // Text(
                              //   '    View On Map',
                              //   style: TextStyle(
                              //       color: AppColor.primaryColor,
                              //       fontFamily: 'Segoe',
                              //       fontSize: querySize.width * 0.035,
                              //       fontWeight: FontWeight.w600),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: querySize.height * 0.01,
                          ),
                          Text(
                            "Description",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: 'Segoe',
                                fontSize: querySize.width * 0.042),
                          ),
                          SizedBox(
                            height: querySize.height * 0.01,
                          ),

                          Html(
                            data: cleanDescription(widget.serviceDetails.description), // Use the raw HTML response here
                            style: {
                              "p": Style(
                                fontSize: FontSize(16), // Adjust paragraph font size
                                lineHeight: LineHeight(1.6), // Adjust line spacing
                                color: AppColor.descriptionColor, // Customize text color
                              ),
                              "strong": Style(
                                fontWeight: FontWeight.bold, // Bold text for strong elements
                              ),
                              "ul": Style(
                                padding: HtmlPaddings.all(16), // Correct padding type for lists
                              ),
                              "li": Style(
                                fontSize: FontSize(14), // Adjust list item font size
                                // Use Margins for list item margins
                                listStyleType: ListStyleType.disc, // Add bullets to the list
                              ),
                            },
                          ),


                         /* Text(
                            cleanDescription(widget.serviceDetails.description),
                            style: TextStyle(
                                fontSize: querySize.width * 0.04,
                                fontFamily: 'Segoe',
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),*/
                          // TabBar(
                          //   labelColor: Colors.amber,
                          //   unselectedLabelColor: Colors.black,
                          //   indicatorColor: const Color(0xFF929292),
                          //   dividerColor: Colors.black,
                          //   controller:
                          //       _tabController, // Attach TabController here
                          //   tabs: const [
                          //     Tab(text: 'Details'),
                          //     Tab(text: 'Description'),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: querySize.height * 0.28,
                    //   child: TabBarView(
                    //     controller: _tabController,
                    //     children: [
                    //       Padding(
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: querySize.width * 0.06),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             // customSizedBox(querySize),
                    //             // productDetailProvidervalue.productDetails!
                    //             //             .data!.category!.name !=
                    //             //         'Diamond'
                    //             //     ?
                    //             Row(
                    //               children: [
                    //                 Row(
                    //                   children: [
                    //                     // Container(
                    //                     //   width: querySize.width * 0.27,
                    //                     //   height:
                    //                     //       querySize.height * 0.03,
                    //                     //   decoration:
                    //                     //       const BoxDecoration(
                    //                     //           color: Color(
                    //                     //               0x7AF3C200)),
                    //                     //   child: Center(
                    //                     //       child: Text(
                    //                     //     '${productDetailProvidervalue.productDetails!.data!.currentGoldRate![2].purity ?? ''}k   ${productDetailProvidervalue.productDetails!.data!.currentGoldRate![2].price} QR',
                    //                     //     style: TextStyle(
                    //                     //         fontSize:
                    //                     //             querySize.width *
                    //                     //                 0.03,
                    //                     //         fontFamily: 'Segoe',
                    //                     //         color: Colors.black,
                    //                     //         fontWeight:
                    //                     //             FontWeight.w600),
                    //                     //   )),
                    //                     // ),
                    //                     SizedBox(
                    //                       width: querySize.width * 0.03,
                    //                     ),
                    //                     Container(
                    //                       width: querySize.width * 0.27,
                    //                       height: querySize.height * 0.03,
                    //                       decoration: const BoxDecoration(
                    //                           color: Color(0x7AF3C200)),
                    //                       child: Center(
                    //                           child: Text(
                    //                         ' QR',
                    //                         style: TextStyle(
                    //                             fontSize:
                    //                                 querySize.width * 0.03,
                    //                             fontFamily: 'Segoe',
                    //                             color: Colors.black,
                    //                             fontWeight: FontWeight.w600),
                    //                       )),
                    //                     ),
                    //                     SizedBox(
                    //                       width: querySize.width * 0.03,
                    //                     ),
                    //                     Container(
                    //                       width: querySize.width * 0.27,
                    //                       height: querySize.height * 0.03,
                    //                       decoration: const BoxDecoration(
                    //                           color: Color(0x7AF3C200)),
                    //                       child: Center(
                    //                           child: Text(
                    //                         ' QR',
                    //                         style: TextStyle(
                    //                             fontSize:
                    //                                 querySize.width * 0.03,
                    //                             fontFamily: 'Segoe',
                    //                             color: Colors.black,
                    //                             fontWeight: FontWeight.w600),
                    //                       )),
                    //                     )
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //             //     : SizedBox(
                    //             //         height: 0,
                    //             //       ),
                    //             // productDetailProvidervalue.productDetails!
                    //             //             .data!.category!.name !=
                    //             //         'Diamond'
                    //             //     ? customSizedBox(querySize)
                    //             //     : SizedBox(),
                    //             Row(
                    //               children: [
                    //                 Text(
                    //                   "Category",
                    //                   style: TextStyle(
                    //                       fontSize: querySize.width * 0.0344,
                    //                       color: const Color(0xFF5E5E5E),
                    //                       fontFamily: 'Segoe'),
                    //                 ),
                    //                 SizedBox(
                    //                   width: querySize.width * 0.132,
                    //                 ),
                    //                 Text(
                    //                   "ABCD",
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: querySize.width * 0.0344,
                    //                       color: const Color(0xFF000000),
                    //                       fontFamily: 'Segoe'),
                    //                 )
                    //               ],
                    //             ),
                    //             Row(
                    //               children: [
                    //                 Text(
                    //                   "Product Code",
                    //                   style: TextStyle(
                    //                       fontSize: querySize.width * 0.0344,
                    //                       color: const Color(0xFF5E5E5E),
                    //                       fontFamily: 'Segoe'),
                    //                 ),
                    //                 SizedBox(
                    //                   width: querySize.width * 0.06,
                    //                 ),
                    //                 Text(
                    //                   'N/A',
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: querySize.width * 0.0344,
                    //                       color: const Color(0xFF000000),
                    //                       fontFamily: 'Segoe'),
                    //                 )
                    //               ],
                    //             ),
                    //             SizedBox(
                    //               height: querySize.height * 0.02,
                    //             ),
                    //             Text(
                    //               'Product Details',
                    //               style: TextStyle(
                    //                 decoration: TextDecoration.underline,
                    //                 fontSize: querySize.width * 0.0344,
                    //                 color: const Color(0xFF000000),
                    //                 fontWeight: FontWeight.w600,
                    //                 fontFamily: 'Segoe',
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               height: querySize.height * 0.02,
                    //             ),
                    //             Row(
                    //               children: [
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(
                    //                       "Gold Weight",
                    //                       style: TextStyle(
                    //                           fontSize:
                    //                               querySize.width * 0.0344,
                    //                           color: const Color(0xFF5E5E5E),
                    //                           fontFamily: 'Segoe'),
                    //                     ),
                    //                     Text(
                    //                       'Diamond',
                    //                       style: TextStyle(
                    //                           fontWeight: FontWeight.w600,
                    //                           fontSize:
                    //                               querySize.width * 0.0344,
                    //                           color: const Color(0xFF000000),
                    //                           fontFamily: 'Segoe'),
                    //                     )
                    //                   ],
                    //                 ),
                    //                 SizedBox(
                    //                   height: querySize.height * 0.049,
                    //                   child: VerticalDivider(
                    //                     color: Colors.grey,
                    //                     thickness: querySize.width * 0.002,
                    //                     width: querySize.width * 0.08,
                    //                   ),
                    //                 ),
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(
                    //                       "Color",
                    //                       style: TextStyle(
                    //                           fontSize:
                    //                               querySize.width * 0.0344,
                    //                           color: const Color(0xFF5E5E5E),
                    //                           fontFamily: 'Segoe'),
                    //                     ),
                    //                     Text(
                    //                       'Diamond',
                    //                       style: TextStyle(
                    //                           fontWeight: FontWeight.w600,
                    //                           fontSize:
                    //                               querySize.width * 0.0344,
                    //                           color: const Color(0xFF000000),
                    //                           fontFamily: 'Segoe'),
                    //                     )
                    //                   ],
                    //                 ),
                    //                 SizedBox(
                    //                   height: querySize.height * 0.049,
                    //                   child: VerticalDivider(
                    //                     color: Colors.grey,
                    //                     thickness: querySize.width * 0.002,
                    //                     width: querySize.width * 0.08,
                    //                   ),
                    //                 ),
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(
                    //                       "Gold Purity",
                    //                       style: TextStyle(
                    //                           fontSize:
                    //                               querySize.width * 0.0344,
                    //                           color: const Color(0xFF5E5E5E),
                    //                           fontFamily: 'Segoe'),
                    //                     ),
                    //                     Text(
                    //                       'Diamond',
                    //                       style: TextStyle(
                    //                           fontWeight: FontWeight.w600,
                    //                           fontSize:
                    //                               querySize.width * 0.0344,
                    //                           color: const Color(0xFF000000),
                    //                           fontFamily: 'Segoe'),
                    //                     )
                    //                   ],
                    //                 ),
                    //                 SizedBox(
                    //                   height: querySize.height * 0.049,
                    //                   child: VerticalDivider(
                    //                     color: Colors.grey,
                    //                     thickness: querySize.width * 0.002,
                    //                     width: querySize.width * 0.08,
                    //                   ),
                    //                 ),
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(
                    //                       "Making Charge",
                    //                       style: TextStyle(
                    //                           fontSize:
                    //                               querySize.width * 0.0344,
                    //                           color: const Color(0xFF5E5E5E),
                    //                           fontFamily: 'Segoe'),
                    //                     ),
                    //                     Text(
                    //                       " Qr",
                    //                       style: TextStyle(
                    //                           fontWeight: FontWeight.w600,
                    //                           fontSize:
                    //                               querySize.width * 0.0344,
                    //                           color: const Color(0xFF000000),
                    //                           fontFamily: 'Segoe'),
                    //                     )
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //             SizedBox(
                    //               height: querySize.height * 0.02,
                    //             ),
                    //             // Text(
                    //             //   'Price Breakup',
                    //             //   style: TextStyle(
                    //             //     decoration: TextDecoration.underline,
                    //             //     fontSize: querySize.width * 0.0344,
                    //             //     color: const Color(0xFF000000),
                    //             //     fontWeight: FontWeight.w600,
                    //             //     fontFamily: 'Segoe',
                    //             //   ),
                    //             // ),
                    //             SizedBox(
                    //               height: querySize.height * 0.02,
                    //             ),
                    //             Row(
                    //               //   mainAxisAlignment: MainAxisAlignment.start,
                    //               children: [
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(
                    //                       "Dimaond Weight",
                    //                       style: TextStyle(
                    //                           fontSize: querySize.width * 0.03,
                    //                           color: const Color(0xFF5E5E5E),
                    //                           fontFamily: 'Segoe'),
                    //                     ),
                    //                     Text(
                    //                       " gm",
                    //                       style: TextStyle(
                    //                           fontWeight: FontWeight.w600,
                    //                           fontSize:
                    //                               querySize.width * 0.0344,
                    //                           color: const Color(0xFF000000),
                    //                           fontFamily: 'Segoe'),
                    //                     )
                    //                   ],
                    //                 ),
                    //                 SizedBox(
                    //                   height: querySize.height * 0.049,
                    //                   child: VerticalDivider(
                    //                     color: Colors.grey,
                    //                     thickness: querySize.width * 0.002,
                    //                     width: querySize.width * 0.08,
                    //                   ),
                    //                 ),
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(
                    //                       "Diamond Colour",
                    //                       style: TextStyle(
                    //                           fontSize: querySize.width * 0.03,
                    //                           color: const Color(0xFF5E5E5E),
                    //                           fontFamily: 'Segoe'),
                    //                     ),
                    //                     Text(
                    //                       "abcd ",
                    //                       style: TextStyle(
                    //                           fontWeight: FontWeight.w600,
                    //                           fontSize:
                    //                               querySize.width * 0.0344,
                    //                           color: const Color(0xFF000000),
                    //                           fontFamily: 'Segoe'),
                    //                     )
                    //                   ],
                    //                 ),
                    //                 SizedBox(
                    //                   height: querySize.height * 0.049,
                    //                   child: VerticalDivider(
                    //                     color: Colors.grey,
                    //                     thickness: querySize.width * 0.002,
                    //                     width: querySize.width * 0.08,
                    //                   ),
                    //                 ),
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(
                    //                       "Diamond Clarity",
                    //                       style: TextStyle(
                    //                           fontSize: querySize.width * 0.03,
                    //                           color: const Color(0xFF5E5E5E),
                    //                           fontFamily: 'Segoe'),
                    //                     ),
                    //                     Text(
                    //                       "abcd",
                    //                       style: TextStyle(
                    //                           fontWeight: FontWeight.w600,
                    //                           fontSize:
                    //                               querySize.width * 0.0344,
                    //                           color: const Color(0xFF000000),
                    //                           fontFamily: 'Segoe'),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ],
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: querySize.width * 0.06),
                    //         child: Column(
                    //           children: [
                    //             SizedBox(
                    //               height: querySize.height * 0.02,
                    //             ),
                    //             // Html(
                    //             //   data: productDetailProvidervalue
                    //             //           .productDetails!
                    //             //           .data!
                    //             //           .longDescription ??
                    //             //       '',
                    //             //   style: {
                    //             //     "p": Style(
                    //             //       fontSize:
                    //             //           FontSize.small, // Set font size
                    //             //       color: Colors.black, // Set text color
                    //             //       textAlign:
                    //             //           TextAlign.justify, // Align text
                    //             //       fontFamily: 'Segoe',
                    //             //     ),
                    //             //     "h1": Style(
                    //             //       // fontSize: FontSize.xLarge, // Larger font for h1
                    //             //       fontWeight:
                    //             //           FontWeight.bold, // Bold font weight
                    //             //       color: Colors
                    //             //           .blueAccent, // Different color for h1
                    //             //     ),
                    //             //     "a": Style(
                    //             //       color: Colors.blue, // Link color
                    //             //       textDecoration: TextDecoration
                    //             //           .underline, // Underline links
                    //             //     ),
                    //             //     // fontSize: querySize.width * 0.03,
                    //             //     // fontFamily: 'Segoe',
                    //             //     // color: Colors.black,
                    //             //     // fontWeight: FontWeight.w500,
                    //             //   },
                    //             // ),
                    //             Text(
                    //               "Description about the service",
                    //               style: TextStyle(
                    //                   fontSize: querySize.width * 0.03,
                    //                   fontFamily: 'Segoe',
                    //                   color: Colors.black,
                    //                   fontWeight: FontWeight.w500),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: querySize.width * 0.06),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "Similar Product",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             color: const Color(0xFF008186),
                    //             fontFamily: 'ElMessiri',
                    //             fontSize: querySize.width * 0.05),
                    //       ),
                    //        SizedBox(
                    //                             height: querySize.height * 0.02,
                    //                           ),
                    //       SizedBox(
                    //         // color: Colors.blueGrey,
                    //         height: 230.7 / 812.0 * querySize.height,
                    //         child: ListView.builder(
                    //           physics: const ScrollPhysics(
                    //               parent: BouncingScrollPhysics()),
                    //           scrollDirection: Axis.horizontal,
                    //           itemCount:3,

                    //           itemBuilder: (context, index) {
                    //             return GestureDetector(
                    //                 onTap: () {},
                    //                 child: Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     GestureDetector(
                    //                       onTap: () {
                    //                         Navigator.push(
                    //                             context,
                    //                             MaterialPageRoute(
                    //                               builder: (context) =>
                    //                                   ProductDetailScreen(
                    //                                       productId: productDetailProvidervalue
                    //                                           .productDetails!
                    //                                           .relatedProducts![
                    //                                               index]
                    //                                           .id!),
                    //                             ));
                    //                       },
                    //                       child: Container(
                    //                         margin: EdgeInsets.only(
                    //                             right:
                    //                                 querySize.width * 0.025),
                    //                         width: 159.16 /
                    //                             375.0 *
                    //                             querySize.width,
                    //                         height: 178.7 /
                    //                             812.0 *
                    //                             querySize.height,
                    //                         decoration: BoxDecoration(
                    //                           color: const Color(0xFFE7E7E7),
                    //                           borderRadius:
                    //                               BorderRadius.circular(10),
                    //                           image: DecorationImage(
                    //                             image: NetworkImage(
                    //                                 productDetailProvidervalue
                    //                                     .productDetails!
                    //                                     .relatedProducts![
                    //                                         index]
                    //                                     .thumbImage!),
                    //                             fit: BoxFit.cover,
                    //                           ),
                    //                         ),
                    //                         child: Row(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment.end,
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.start,
                    //                           children: [
                    //                             Padding(
                    //                               padding: EdgeInsets.only(
                    //                                   top: querySize.height *
                    //                                       0.008,
                    //                                   right:
                    //                                       querySize.height *
                    //                                           0.012),
                    //                               child: CircleAvatar(
                    //                                 radius: querySize.width *
                    //                                     0.033,
                    //                                 backgroundColor:
                    //                                     Colors.white,
                    //                                 child: Image.asset(
                    //                                   'assets/images/home/favourite.png',
                    //                                   width: querySize.width *
                    //                                       0.075,
                    //                                   height:
                    //                                       querySize.height *
                    //                                           0.035,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                         height: querySize.height * 0.01),
                    //                     Row(
                    //                       children: [
                    //                         Text(
                    //                           "QAR ",
                    //                           style: TextStyle(
                    //                             color: Color(0xFF000000),
                    //                             fontSize: 10.0,
                    //                           ),
                    //                         ),
                    //                         Text(
                    //                           productDetailProvidervalue
                    //                               .productDetails!
                    //                               .relatedProducts![index]
                    //                               .price
                    //                               .toString(),
                    //                           style: TextStyle(
                    //                             color: Color(0xFF000000),
                    //                             fontSize: 13.0,
                    //                             fontWeight: FontWeight.bold,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     Text(
                    //                       productDetailProvidervalue
                    //                               .productDetails!
                    //                               .relatedProducts![index]
                    //                               .name ??
                    //                           '',
                    //                       style: TextStyle(
                    //                         fontFamily: 'Segoebold',
                    //                         fontWeight: FontWeight.w600,
                    //                         fontSize: querySize.width * 0.026,
                    //                         //color: const Color(0xFF525252),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ));
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: querySize.height * 0.3,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColor.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // WhatsApp Button
                      IconButton(
                          onPressed: () {
                            // Launch WhatsApp with a predefined message
                            // final whatsappUrl =
                            //     "whatsapp://send?phone=YOUR_PHONE_NUMBER&text=Hello";
                            // launchUrl(Uri.parse(whatsappUrl));


                            String whatsapp = widget.serviceDetails.vendorName.phone; // Get dynamically
                            activityController.openWhatsApp(whatsapp);
                          },
                          icon: Image.asset(
                            Assets.images.whatsapp.path,
                            width: AppSize.appSize28, color: Color(0xFFEFECE4),
                            // color: Colors.green,
                          )),

                      // Call Button
                      IconButton(
                        onPressed: () {
                          String agentPhoneNumber = widget.serviceDetails.vendorName.phone; // Get dynamically
                          activityController.launchDialer(agentPhoneNumber);
                        },
                        icon: const Icon(
                          Icons.phone, color: Color(0xFFEFECE4),
                          // color: Colors.blue,
                          size: 28,
                        ),
                      ),

                      // SMS Button
                      IconButton(
                        onPressed: () {
                          String agentEmail = widget.serviceDetails.vendorName.email; // Get dynamically
                          activityController.openGmail(agentEmail);
                        },
                        icon: const Icon(
                          Icons.sms,
                          color: Color(0xFFEFECE4),
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: Container(), //addToCartAndBuyNowButton(
            //   //   querySize,
            //   //   context,
            //   // ),
            // )
          ],
        )
        //   },
        // ),
        );
  }

  // Container addToCartAndBuyNowButton(
  //     Size querySize, BuildContext context, ProductDetailModel product) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.2),
  //           blurRadius: 4,
  //           offset: const Offset(0, -5),
  //         ),
  //       ],
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     padding: EdgeInsets.all(querySize.width * 0.04),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         ElevatedButton(
  //           onPressed: () {
  //             final cartItem = HiveCartModel(
  //               type: '1',
  //               productId: product.data!.id!,
  //               productName: product.data!.name ?? '',
  //               description: product.data!.sku ?? '',
  //               price: product.data!.price?.toDouble() ?? 0.0,
  //               size: 'Default Size',
  //               image: (product.data!.images != null &&
  //                       product.data!.images!.isNotEmpty)
  //                   ? product
  //                       .data!.images!.first // Use the first image if available
  //                   : 'assets/images/placeholder.png', // Default placeholder image
  //               stock: product.data!.stock ?? 0,
  //               quantity: 1,
  //             );

  //             Provider.of<CartProvider>(context, listen: false)
  //                 .addToCart(cartItem);
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                   content: Text("${product.data!.name ?? ''} added to cart")),
  //             );
  //             // final cartItem = CartModel(
  //             //   productId: product.data!.id!,
  //             //   image: (product.data!.images != null &&
  //             //           product.data!.images!.isNotEmpty)
  //             //       ? product
  //             //           .data!.images!.first // Use the first image if available
  //             //       : 'assets/images/placeholder.png', // Provide a default placeholder image
  //             //   stock: product.data!.stock ?? 0,
  //             //   productName: product.data!.name ?? '',
  //             //   description: product.data!.sku ?? '',
  //             //   price: product.data!.price!.toDouble(),
  //             //   size: 'Default Size',
  //             // );

  //             // Provider.of<CartProvider>(context, listen: false)
  //             //     .addToCart(cartItem);
  //             // customSnackBar(
  //             //     context, "${product.data!.name ?? ''} added to cart");
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xFF008186),
  //             minimumSize: Size(
  //               MediaQuery.of(context).size.width * (137 / 375),
  //               MediaQuery.of(context).size.height * (42 / 812),
  //             ),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //           ),
  //           child: const Text(
  //             'Add to cart',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => BuyNowCheckOutScreen(
  //                     productId: product.data!.id!,
  //                     quantity: 1,
  //                   ),
  //                 ));
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xFF008186),
  //             minimumSize: Size(
  //               MediaQuery.of(context).size.width * (137 / 375),
  //               MediaQuery.of(context).size.height * (42 / 812),
  //             ),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //           ),
  //           child: const Text(
  //             'Buy Now',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
