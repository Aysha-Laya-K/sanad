import 'dart:convert';

class ServiceListModel {
  final List<Service> services;
  final int total;
  final int limit;
  final int offset;

  ServiceListModel({
    required this.services,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory ServiceListModel.fromJson(String str) =>
      ServiceListModel.fromMap(json.decode(str));

  factory ServiceListModel.fromMap(Map<String, dynamic> json) => ServiceListModel(
    services: List<Service>.from(json["services"].map((x) => Service.fromMap(x))),
    total: json["total"],
    limit: json["limit"],
    offset: json["offset"],
  );
}

class Service {
  final int id;
  final int userId;
  final int serviceId;
  final String title;
  final String slug;
  final String description;
  final String? location;
  final String startingPrice;
  final String thumbImage;
  final List<String> sliderImages;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ServiceName servicename;
  final VendorName vendorname;

  Service({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.title,
    required this.slug,
    required this.description,
    this.location,
    required this.startingPrice,
    required this.thumbImage,
    required this.sliderImages,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.servicename,
    required this.vendorname,
  });

  factory Service.fromMap(Map<String, dynamic> json) => Service(
    id: json["id"],
    userId: json["user_id"],
    serviceId: json["service_id"],
    title: json["title"],
    slug: json["slug"],
    description: json["description"],
    location: json["location"],
    startingPrice: json["starting_price"],
    thumbImage: json["thumb_image"],
    sliderImages: List<String>.from(jsonDecode(json["slider_images"])),
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    servicename: ServiceName.fromMap(json["servicename"]),
    vendorname: VendorName.fromMap(json["vendorname"]),
  );
}

class ServiceName {
  final int id;
  final String name;
  final String image;
  final String slug;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceName({
    required this.id,
    required this.name,
    required this.image,
    required this.slug,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceName.fromMap(Map<String, dynamic> json) => ServiceName(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    slug: json["slug"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );
}

class VendorName {
  final int id;
  final String name;
  final String userName;
  final String email;
  final String phone;
  final String address;
  final String location;
  final String designation;
  final String aboutMe;
  final int status;

  VendorName({
    required this.id,
    required this.name,
    required this.userName,
    required this.email,
    required this.phone,
    required this.address,
    required this.location,
    required this.designation,
    required this.aboutMe,
    required this.status,
  });

  factory VendorName.fromMap(Map<String, dynamic> json) => VendorName(
    id: json["id"],
    name: json["name"],
    userName: json["user_name"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    location: json["location"],
    designation: json["designation"],
    aboutMe: json["about_me"],
    status: json["status"],
  );
}
