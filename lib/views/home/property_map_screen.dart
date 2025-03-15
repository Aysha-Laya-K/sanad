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
import 'package:luxury_real_estate_flutter_ui_kit/views/property_list/property_details_view.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:luxury_real_estate_flutter_ui_kit/model/property__model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/map_model.dart';
import 'package:luxury_real_estate_flutter_ui_kit/model/property__model.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/services.dart';

class PropertyMapScreen extends StatefulWidget {
  final PropertyResponse? propertyResponse;

  PropertyMapScreen({this.propertyResponse});

  @override
  _PropertyMapScreenState createState() => _PropertyMapScreenState();
}

class _PropertyMapScreenState extends State<PropertyMapScreen> {
  HomeController homeController = Get.put(HomeController());
  late GoogleMapController _mapController;
  final RxSet<Marker> _markers = <Marker>{}.obs;
  Map<String, List<MapData>> _propertiesByCoordinates = {};
  Map<String, List<Property>> _propertiesByCoordinates1 = {};
  late CameraPosition _initialCameraPosition;


  @override
  void initState() {
    super.initState();
    // Set a default initial camera position (Qatar center)
    _initialCameraPosition = CameraPosition(
      target: LatLng(25.2854, 51.5310),
      zoom: 11,
    );

    if (widget.propertyResponse != null) {
      // Use PropertyResponse data if provided
      _createCustomMarkersFromPropertyResponse(widget.propertyResponse!);
      _processPropertiesForOffsetting1();
      _createOffsetMarkers1();

      // Set initial camera position to the first property's location
      if (widget.propertyResponse!.data.isNotEmpty) {
        final firstProperty = widget.propertyResponse!.data.first;
        if (firstProperty.lat != null && firstProperty.lon != null) {
          _initialCameraPosition = CameraPosition(
            target: LatLng(firstProperty.lat!, firstProperty.lon!),
            zoom: 11,
          );
        }
      }
    } else {
      // Fetch map data from HomeController if no PropertyResponse is provided
      homeController.fetchMapData().then((_) {
        _createCustomMarkersFromMapDataResponse(homeController.mapDataResponse.value!);
        _processPropertiesForOffsetting();
        _createOffsetMarkers(); // Create offset markers after processing

        // Set initial camera position to the first map data's location
        if (homeController.mapDataResponse.value?.data.isNotEmpty ?? false) {
          final firstMapData = homeController.mapDataResponse.value!.data.first;
          if (firstMapData.lat != null && firstMapData.lon != null) {
            _initialCameraPosition = CameraPosition(
              target: LatLng(double.parse(firstMapData.lat!), double.parse(firstMapData.lon!)),
              zoom: 11,
            );
          }
        }
      });
    }
  }

  // Group properties by their coordinates to detect overlaps
  void _processPropertiesForOffsetting() {
    final mapData = homeController.mapDataResponse.value?.data;
    _propertiesByCoordinates.clear();

    if (mapData != null) {
      for (var property in mapData) {
        if (property.lat != null && property.lon != null) {
          // Round coordinates to 5 decimal places to detect "near overlaps"
          String key = "${double.parse(property.lat!).toStringAsFixed(5)},${double.parse(property.lon!).toStringAsFixed(5)}";

          if (_propertiesByCoordinates.containsKey(key)) {
            _propertiesByCoordinates[key]!.add(property);
          } else {
            _propertiesByCoordinates[key] = [property];
          }
        }
      }
    }

    print('Found ${_propertiesByCoordinates.length} unique coordinates');
    print('Found ${_propertiesByCoordinates.values.where((list) => list.length > 1).length} overlapping coordinates');
  }

  // Group properties by their coordinates to detect overlaps
  void _processPropertiesForOffsetting1() {
    final properties = widget.propertyResponse!.data; // Access the 'data' list
    _propertiesByCoordinates1.clear();

    if (properties != null) {
      for (var property in properties) {
        if (property.lat != null && property.lon != null) {
          // Round coordinates to 5 decimal places to detect "near overlaps"
          String key = "${property.lat!.toStringAsFixed(5)},${property.lon!.toStringAsFixed(5)}";

          if (_propertiesByCoordinates1.containsKey(key)) {
            _propertiesByCoordinates1[key]!.add(property);
          } else {
            _propertiesByCoordinates1[key] = [property];
          }
        }
      }
    }

    print('Found ${_propertiesByCoordinates1.length} unique coordinates');
    print('Found ${_propertiesByCoordinates1.values.where((list) => list.length > 1).length} overlapping coordinates');
  }
  Future<void> _createCustomMarkersFromPropertyResponse(PropertyResponse response) async {
    _markers.value = {}; // Reset the markers using .value
    print('Printing information about all items in response.data:');
    for (var property in response.data) {
      print(
          'ID: ${property.id}, '
              'Lat: ${property.lat}, '
              'Lon: ${property.lon}, '
              'Price: QAR ${property.price}'
      );
    }

    for (var property in response.data) {
      if (property.lat != null && property.lon != null) {
        final customMarker = await _createCustomMarkerBitmap('QAR ${property.price}');

        _markers.value.add(
          Marker(
            markerId: MarkerId(property.id.toString()),
            position: LatLng(property.lat!, property.lon!),
            icon: customMarker,
            onTap: () {
              final int propertyId = property.id;
              print('Tapped on property with ID: $propertyId');
              Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyId);
            },
          ),
        );
        print('Added marker at Lat: ${property.lat}, Lon: ${property.lon}');
      }
    }

    print('Total markers: ${_markers.value.length}'); // Print total markers

    if (mounted) {
      setState(() {}); // Refresh the UI
    }
  }

  Future<void> _createCustomMarkersFromMapDataResponse(MapDataResponse response) async {
    _markers.value = {}; // Reset the markers using .value

    for (var data in response.data) {
      if (data.lat != null && data.lon != null) {
        final customMarker = await _createCustomMarkerBitmap('QAR ${data.price}');

        _markers.value.add(
          Marker(
            markerId: MarkerId(data.id.toString()),
            position: LatLng(double.parse(data.lat!), double.parse(data.lon!)),
            icon: customMarker,
            onTap: () {
              final int propertyId = data.id;
              print('Tapped on property with ID: $propertyId');
              Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyId);
            },
          ),
        );
        print('Added marker at Lat: ${data.lat}, Lon: ${data.lon}');
      }
    }

    print('Total markers: ${_markers.value.length}'); // Print total markers

    if (mounted) {
      setState(() {}); // Refresh the UI
    }
  }

  Future<void> _createOffsetMarkers() async {
    _markers.value = {}; // Reset the markers using .value

    // Process each coordinate group
    for (var entry in _propertiesByCoordinates.entries) {
      final properties = entry.value;
      final coordinates = entry.key.split(',');
      final baseLat = double.parse(coordinates[0]);
      final baseLon = double.parse(coordinates[1]);

      // Calculate an appropriate offset radius based on properties count
      double offsetRadius = 0.0;
      if (properties.length > 1) {
        offsetRadius = 0.0002 * math.min(properties.length, 8);
      }

      // Create a marker for each property, with offset if there are multiples
      for (int i = 0; i < properties.length; i++) {
        final property = properties[i];
        final customMarker = await _createCustomMarkerBitmap('QAR ${property.price}');

        double lat = baseLat;
        double lon = baseLon;

        if (properties.length > 1) {
          if (properties.length == 2) {
            lon = baseLon + (i == 0 ? -offsetRadius : offsetRadius);
          } else if (properties.length == 3) {
            final angle = (i * 2 * math.pi) / properties.length + (math.pi / 6);
            lat = baseLat + (offsetRadius * math.sin(angle));
            lon = baseLon + (offsetRadius * math.cos(angle));
          } else {
            final angle = (i * 2 * math.pi) / properties.length;
            lat = baseLat + (offsetRadius * math.sin(angle));
            lon = baseLon + (offsetRadius * math.cos(angle));
          }
        }

        _markers.value.add(
          Marker(
            markerId: MarkerId(property.id.toString()),
            position: LatLng(lat, lon),
            icon: customMarker,
            onTap: () {
              final int propertyId = property.id;
              print('Tapped on property with ID: $propertyId');
              Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyId);
            },
          ),
        );
      }
    }

    // Print total markers

    if (mounted) {
      setState(() {}); // Refresh the UI
    }
  }
  Future<void> _createOffsetMarkers1() async {
    _markers.value = {}; // Reset the markers using .value

    // Process each coordinate group
    for (var entry in _propertiesByCoordinates1.entries) {
      final properties = entry.value;
      final coordinates = entry.key.split(',');
      final baseLat = double.parse(coordinates[0]);
      final baseLon = double.parse(coordinates[1]);

      // Calculate an appropriate offset radius based on properties count
      double offsetRadius = 0.0;
      if (properties.length > 1) {
        offsetRadius = 0.0002 * math.min(properties.length, 8);
      }

      // Create a marker for each property, with offset if there are multiples
      for (int i = 0; i < properties.length; i++) {
        final property = properties[i];
        final customMarker = await _createCustomMarkerBitmap('QAR ${property.price}');

        double lat = baseLat;
        double lon = baseLon;

        if (properties.length > 1) {
          if (properties.length == 2) {
            lon = baseLon + (i == 0 ? -offsetRadius : offsetRadius);
          } else if (properties.length == 3) {
            final angle = (i * 2 * math.pi) / properties.length + (math.pi / 6);
            lat = baseLat + (offsetRadius * math.sin(angle));
            lon = baseLon + (offsetRadius * math.cos(angle));
          } else {
            final angle = (i * 2 * math.pi) / properties.length;
            lat = baseLat + (offsetRadius * math.sin(angle));
            lon = baseLon + (offsetRadius * math.cos(angle));
          }
        }

        _markers.value.add(
          Marker(
            markerId: MarkerId(property.id.toString()),
            position: LatLng(lat, lon),
            icon: customMarker,
            onTap: () {
              final int propertyId = property.id;
              print('Tapped on property with ID: $propertyId');
              Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyId);
            },
          ),
        );
      }
    }

    // Print total markers

    if (mounted) {
      setState(() {}); // Refresh the UI
    }
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap(String price) async {
    final pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Define custom dimensions
    double textSize = 35;
    double padding = 20;
    double triangleHeight = 10;

    // Create a MarkerPainter instance
    final markerPainter = _MarkerPainter(price, textSize, padding, triangleHeight);

    // Get the marker dimensions from the painter
    final width = markerPainter.width;
    final height = markerPainter.height;

    // Draw the marker using the MarkerPainter
    markerPainter.paint(canvas, Size(width, height));

    // Convert to image
    final img = await pictureRecorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );

    // Convert the image to byte data
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) {
      throw Exception("Failed to convert marker image to byte data.");
    }

    // Create the BitmapDescriptor
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the home page when the back button is pressed
        Get.offAllNamed(AppRoutes.homeView); // Replace '/home' with your home route
        return false; // Prevent default back button behavior
      },
      child:
    Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Property Map'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              controller: homeController.searchController,
              cursorColor: AppColor.primaryColor,
              style: AppStyle.heading4Regular(color: AppColor.textColor),
              readOnly: true,
              onTap: () {
                Get.toNamed(AppRoutes.searchView, arguments: {
                  'source': 'map', // Indicates navigation from map screen
                });
              },
              decoration: InputDecoration(
                hintText: AppString.searchCity,
                hintStyle: AppStyle.heading4Regular(color: AppColor.descriptionColor),
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
            Expanded(
              child: Obx(() {
                return GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: _markers.value, // Use .value to access the observable set
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                );
              }),
            ),
          ],
        ),
      ),
    )
    );
  }
}
class _MarkerPainter extends CustomPainter {
  final String price;
  final double textSize;
  final double padding;
  final double triangleHeight;

  _MarkerPainter(this.price, this.textSize, this.padding, this.triangleHeight);

  // Calculate marker dimensions
  double get width => _textPainter.width + padding * 2;
  double get height => _textPainter.height + padding * 2 + triangleHeight;

  // Text painter for the price
  TextPainter get _textPainter {
    final textSpan = TextSpan(
      style: TextStyle(
        color: Colors.white,
        fontSize: textSize,
        fontWeight: FontWeight.bold,
      ),
      text: price,
    );
    print("price:$price");

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Color(0xFF00ACB3);
    final path = Path();

    // Draw the rounded rectangle (bubble)
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height - triangleHeight),
      Radius.circular(20),
    ));

    // Draw the triangle (pointer) at the bottom center
    path.moveTo(width / 2 - 10, height - triangleHeight);
    path.lineTo(width / 2, height);
    path.lineTo(width / 2 + 10, height - triangleHeight);
    path.close();

    // Draw the path on the canvas
    canvas.drawPath(path, paint);

    // Draw the text
    _textPainter.paint(
      canvas,
      Offset(
        (width - _textPainter.width) / 2, // Center the text horizontally
        (height - triangleHeight - _textPainter.height) / 2, // Center the text vertically
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/*class PropertyMapScreen extends StatefulWidget {
  final PropertyResponse? propertyResponse;

  PropertyMapScreen({this.propertyResponse});
  @override
  _PropertyMapScreenState createState() => _PropertyMapScreenState();
}

class _PropertyMapScreenState extends State<PropertyMapScreen> {
  HomeController homeController = Get.put(HomeController());
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  // Map to store properties by coordinates for detecting overlaps
  Map<String, List<MapData>> _propertiesByCoordinates = {};
  @override
  void initState() {
    super.initState();
    if (widget.propertyResponse != null) {
      _createCustomMarkersFromPropertyResponse(widget.propertyResponse!);
    } else {
      homeController.fetchMapData().then((_) {
        _processPropertiesForOffsetting();
        _createOffsetMarkers();
      });
    }
  }

 /* @override
  void initState() {
    super.initState();
    homeController.fetchMapData().then((_) {
      _processPropertiesForOffsetting();
      _createOffsetMarkers();
    });
  }
*/
  // Group properties by their coordinates to detect overlaps
  void _processPropertiesForOffsetting() {
    final mapData = homeController.mapDataResponse.value?.data;
    _propertiesByCoordinates.clear();

    if (mapData != null) {
      for (var property in mapData) {
        if (property.lat != null && property.lon != null) {
          // Round coordinates to 5 decimal places to detect "near overlaps"
          String key = "${double.parse(property.lat!).toStringAsFixed(5)},${double.parse(property.lon!).toStringAsFixed(5)}";

          if (_propertiesByCoordinates.containsKey(key)) {
            _propertiesByCoordinates[key]!.add(property);
          } else {
            _propertiesByCoordinates[key] = [property];
          }
        }
      }
    }

    print('Found ${_propertiesByCoordinates.length} unique coordinates');
    print('Found ${_propertiesByCoordinates.values.where((list) => list.length > 1).length} overlapping coordinates');
  }

  Future<void> _createCustomMarkersFromPropertyResponse(PropertyResponse response) async {
    _markers = {}; // Reset the markers

    for (var property in response.data) {
      if (property.lat != null && property.lon != null) {
        final customMarker = await _createCustomMarkerBitmap('QAR ${property.price}');

        _markers.add(
          Marker(
            markerId: MarkerId(property.id.toString()),
            position: LatLng(property.lat!, property.lon!),
            icon: customMarker,
            onTap: () {
              final int propertyId = property.id;
              print('Tapped on property with ID: $propertyId');
              Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyId);
            },
          ),
        );
        print('Added marker at Lat: ${property.lat}, Lon: ${property.lon}');
      }
    }

    if (mounted) {
      setState(() {}); // Refresh the UI
    }
  }
  Future<BitmapDescriptor> _createCustomMarkerBitmap(String price) async {
    // Define custom dimensions
    double textSize = 35;
    double padding = 20;
    double triangleHeight = 10;

    // Create a CustomPainter to draw the marker
    final markerPainter = _MarkerPainter(price, textSize, padding, triangleHeight);

    // Create a picture recorder and canvas
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // Define marker dimensions
    final double width = markerPainter.width;
    final double height = markerPainter.height;

    // Apply a transformation to ensure the text is not flipped or mirrored
    canvas.save(); // Save the current canvas state
    canvas.translate(0, height); // Move the canvas origin to the bottom-left corner
    canvas.scale(1, -1); // Flip the canvas vertically

    // Draw the marker using the CustomPainter
    markerPainter.paint(canvas, Size(width, height));

    canvas.restore(); // Restore the canvas state

    // Convert to image
    final img = await pictureRecorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<void> _createOffsetMarkers() async {
    _markers = {}; // Reset the markers

    // Process each coordinate group
    for (var entry in _propertiesByCoordinates.entries) {
      final properties = entry.value;
      final coordinates = entry.key.split(',');
      final baseLat = double.parse(coordinates[0]);
      final baseLon = double.parse(coordinates[1]);

      // Calculate an appropriate offset radius based on properties count
      // Adjust this multiplier as needed for your specific map zoom level
      double offsetRadius = 0.0;
      if (properties.length > 1) {
        offsetRadius = 0.0002 * math.min(properties.length, 8);
      }

      // Create a marker for each property, with offset if there are multiples
      for (int i = 0; i < properties.length; i++) {
        final property = properties[i];
        final customMarker = await _createCustomMarkerBitmap('QAR ${property.price}');

        // If there are multiple properties, arrange them in a circle
        double lat = baseLat;
        double lon = baseLon;

        if (properties.length > 1) {
          // For single property at this location, use the exact coordinates
          if (properties.length == 1) {
            // No offset needed
          }
          // For two properties, place them horizontally side by side
          else if (properties.length == 2) {
            lon = baseLon + (i == 0 ? -offsetRadius : offsetRadius);
          }
          // For three properties, create a triangle arrangement
          else if (properties.length == 3) {
            final angle = (i * 2 * math.pi) / properties.length + (math.pi / 6); // Slight rotation for better appearance
            lat = baseLat + (offsetRadius * math.sin(angle));
            lon = baseLon + (offsetRadius * math.cos(angle));
          }
          // For more than three, create a circular arrangement
          else {
            final angle = (i * 2 * math.pi) / properties.length;
            lat = baseLat + (offsetRadius * math.sin(angle));
            lon = baseLon + (offsetRadius * math.cos(angle));
          }
        }

        _markers.add(
          Marker(
            markerId: MarkerId(property.id.toString()),
            position: LatLng(lat, lon),
            icon: customMarker,
            onTap: () {
              final int propertyId = property.id;
              print('Tapped on property with ID: $propertyId');
              Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyId);
            },
          ),
        );
      }
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
                  Get.toNamed(AppRoutes.searchView, arguments: {
                    'source': 'map', // Indicates navigation from map screen
                  });
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

class _MarkerPainter extends CustomPainter {
  final String price;
  final double textSize;
  final double padding;
  final double triangleHeight;

  _MarkerPainter(this.price, this.textSize, this.padding, this.triangleHeight);

  // Calculate marker dimensions
  double get width => _textPainter.width + padding * 2;
  double get height => _textPainter.height + padding * 2 + triangleHeight;

  // Text painter for the price
  TextPainter get _textPainter {
    final textSpan = TextSpan(
      style: TextStyle(
        color: Colors.white,
        fontSize: textSize,
        fontWeight: FontWeight.bold,
      ),
      text: price,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Color(0xFF00ACB3);
    final path = Path();

    // Draw the rounded rectangle (bubble)
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height - triangleHeight),
      Radius.circular(20),
    ));

    // Draw the triangle (pointer) at the bottom center
    path.moveTo(width / 2 - 10, height - triangleHeight);
    path.lineTo(width / 2, height);
    path.lineTo(width / 2 + 10, height - triangleHeight);
    path.close();

    // Draw the path on the canvas
    canvas.drawPath(path, paint);

    // Draw the text
    _textPainter.paint(
      canvas,
      Offset((width - _textPainter.width) / 2, (height - triangleHeight - _textPainter.height) / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}*/










/*class PropertyMapScreen extends StatefulWidget {
  //final PropertyResponse? propertyResponse;

 // PropertyMapScreen({this.propertyResponse});
  @override
  _PropertyMapScreenState createState() => _PropertyMapScreenState();
}

class _PropertyMapScreenState extends State<PropertyMapScreen> {
  HomeController homeController = Get.put(HomeController());
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  /*@override
  void initState() {
    super.initState();
    if (widget.propertyResponse != null) {
      _createCustomMarkersFromPropertyResponse(widget.propertyResponse!);
    } else {
      homeController.fetchMapData().then((_) {
        _createCustomMarkers();
        _printLatLon();
      });
    }
  }*/

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
    canvas.translate(0, 0); // Reset translation
    canvas.scale(1, 1); // Reset scaling

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

  /*Future<BitmapDescriptor> _createCustomMarkerBitmap(String price) async {
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
  }*/

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
  /*Future<void> _createCustomMarkersFromPropertyResponse(PropertyResponse response) async {
    _markers = {}; // Reset the markers

    for (var property in response.data) {
      if (property. != null && property.lon != null) {
        final customMarker = await _createCustomMarkerBitmap('QAR ${property.price}');

        _markers.add(
          Marker(
            markerId: MarkerId(property.id.toString()),
            position: LatLng(double.parse(property.lat!), double.parse(property.lon!)),
            icon: customMarker,
            onTap: () {
              final int propertyId = property.id;
              print('Tapped on property with ID: $propertyId');
              Get.toNamed(AppRoutes.propertyDetailsView, arguments: propertyId);
            },
          ),
        );
        print('Added marker at Lat: ${property.lat}, Lon: ${property.lon}');
      }
    }

    if (mounted) {
      setState(() {}); // Refresh the UI
    }
  }*/


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
                  Get.toNamed(AppRoutes.searchView, arguments: {
                    'source': 'map', // Indicates navigation from map screen
                  });

                  //Get.toNamed(AppRoutes.searchView);
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
            /*Expanded(
              child: Obx(() {
                if (homeController.mapDataResponse.value == null && widget.propertyResponse == null) {
                  // Show loading indicator if no data is available
                  return Center(child: CircularProgressIndicator());
                } else {
                  // Use the appropriate data source for markers
                  final markers = widget.propertyResponse != null
                      ? _markersFromPropertyResponse(widget.propertyResponse!)
                      : _markersFromMapDataResponse(homeController.mapDataResponse.value!);

                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(25.2854, 51.5310), // Qatar center
                      zoom: 11,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    markers: markers, // Use the dynamically generated markers
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  );
                }
              }),
            ),*/

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
}*/