import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_color.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_size.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_string.dart';
import 'package:luxury_real_estate_flutter_ui_kit/configs/app_style.dart';
import 'package:luxury_real_estate_flutter_ui_kit/controller/home_controller.dart';
import 'package:luxury_real_estate_flutter_ui_kit/gen/assets.gen.dart';
import 'package:luxury_real_estate_flutter_ui_kit/routes/app_routes.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/home/widget/dummy_prop.dart';
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/property_details_view.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:get/get.dart';

class PropertyMapScreen extends StatefulWidget {
  @override
  _PropertyMapScreenState createState() => _PropertyMapScreenState();
}

class _PropertyMapScreenState extends State<PropertyMapScreen> {
  HomeController homeController = Get.put(HomeController());
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  late List<Property> properties;

  @override
  void initState() {
    super.initState();
    properties = generateRandomProperties();
    _createCustomMarkers();
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap(String price) async {
    TextSpan span = TextSpan(
      style: TextStyle(
        color: Colors.white,
        fontSize: 35,
        fontWeight: FontWeight.bold,
        backgroundColor: Colors.blue,
      ),
      text: price,
    );

    TextPainter painter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    painter.layout();

    final double width = painter.width + 30;
    final double height = painter.height + 20;

    final pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Draw background bubble
    final paint = Paint()
      ..color = Color(0xFF00ACB3) // Your app's primary color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height),
      Radius.circular(height / 2),
    ));

    // Add triangle at bottom for pointer
    path.moveTo(width / 2 - 10, height);
    path.lineTo(width / 2, height + 10);
    path.lineTo(width / 2 + 10, height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw text
    painter.paint(
      canvas,
      Offset((width - painter.width) / 2, (height - painter.height) / 2),
    );

    final img = await pictureRecorder.endRecording().toImage(
          width.toInt(),
          (height + 10).toInt(),
        );
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<void> _createCustomMarkers() async {
    _markers = {};
    for (var property in properties) {
      final customMarker = await _createCustomMarkerBitmap(
          'QAR ${(property.price / 1000).round()}K');

      _markers.add(
        Marker(
          markerId: MarkerId(property.id),
          position: property.location,
          icon: customMarker,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertyDetailsView(),
              ),
            );
          },
        ),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Property Map'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.appSize12),
                color: AppColor.whiteColor,
                boxShadow: [
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
                  Get.toNamed(AppRoutes.searchView);
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
              top: AppSize.appSize20,
              left: AppSize.appSize16,
              right: AppSize.appSize16,
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
                        // _scrollToBottom();
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
                                color:
                                    homeController.selectCountry.value == index
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
                                color:
                                    homeController.selectCountry.value == index
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
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(25.2854, 51.5310), // Qatar center
                  zoom: 11,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class _PropertyMapScreenState extends State<PropertyMapScreen> {---------------------------------------------
//   late GoogleMapController _mapController;
//   Set<Marker> _markers = {};
//   late List<Property> properties;

//   @override
//   void initState() {
//     super.initState();
//     properties = generateRandomProperties();
//     _createMarkers();
//   }

//   void _createMarkers() {
//     _markers = properties.map((property) {
//       return Marker(
//         markerId: MarkerId(property.id),
//         position: property.location,
//         infoWindow: InfoWindow(
//           title: 'QAR ${property.price.toStringAsFixed(0)}',
//         ),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PropertyDetailsView(),
//             ),
//           );
//         },
//       );
//     }).toSet();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Property Map'),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: LatLng(25.2854, 51.5310), // Qatar center
//           zoom: 11,
//         ),
//         onMapCreated: (controller) {
//           _mapController = controller;
//         },
//         markers: _markers,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//       ),
//     );
//   }
// }
