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

  @override
  void initState() {
    super.initState();
    homeController.mapDataResponse.value?.data;
    homeController.fetchMapData().then((_) {
      _createCustomMarkers();
      _printLatLon();
    });
  }

  Future<void> _printLatLon() async {
    final mapData = homeController.mapDataResponse.value?.data;

    if (mapData != null) {
      for (var data in mapData) {
        print('Latitude: ${data.lat}, Longitude: ${data.lon}');
      }
    } else {
      print('No data available or map data is null');
    }
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap(String price) async {
    final pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Define custom dimensions
    double textSize = 35;
    double padding = 20;
    double triangleHeight = 10;

    // Create text span
    TextSpan span = TextSpan(
      style: TextStyle(
        color: Colors.white,
        fontSize: textSize,
        fontWeight: FontWeight.bold,
      ),
      text: price,
    );

    // Prepare text painter
    TextPainter painter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    painter.layout();

    // Define marker dimensions
    final double width = painter.width + padding * 2;
    final double height = painter.height + padding * 2 + triangleHeight;

    // Adjust canvas
    canvas.translate(0, height);
    canvas.scale(1, -1); // Flip vertically to fix upside-down issue

    // Draw background shape (bubble)
    final paint = Paint()..color = Color(0xFF00ACB3);
    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height - triangleHeight),
      Radius.circular(20),
    ));

    // Add triangle at bottom (pointer)
    path.moveTo(width / 2 - 10, height - triangleHeight);
    path.lineTo(width / 2, height);
    path.lineTo(width / 2 + 10, height - triangleHeight);
    path.close();

    canvas.drawPath(path, paint);

    // Draw text
    painter.paint(canvas, Offset((width - painter.width) / 2, padding / 2));

    // Convert to image
    final img = await pictureRecorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<void> _createCustomMarkers() async {
    _markers = {}; // Reset the markers
    final mapData = homeController.mapDataResponse.value?.data;

    if (mapData != null) {
      for (var data in mapData) {
        if (data.lat != null && data.lon != null) {
          final customMarker = await _createCustomMarkerBitmap('QAR ${data.price}');

          _markers.add(
            Marker(
              markerId: MarkerId(data.id.toString()),
              position: LatLng(double.parse(data.lat!), double.parse(data.lon!)),
              icon: customMarker,
              onTap: () {

                final int propertyId = data.id;
                print('Tapped on property with ID: $propertyId');
                // await propertyController.fetchPropertyDetails(propertyId); // Fetch details
                //Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyController.propertyDetails.value);
                Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyId);
                // Navigate to property details if needed
              },
            ),
          );
          print('Added marker at Lat: ${data.lat}, Lon: ${data.lon}');
        }
      }
      print('Total markers: ${_markers.length}'); // Debugging markers count
    }

    if (mounted) {
      setState(() {}); // Refresh the UI
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
            Expanded(
              child: Obx(() {
                if (homeController.mapDataResponse.value == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return GoogleMap(
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
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}