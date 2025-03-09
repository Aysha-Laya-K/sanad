class ServiceDetails {
  final int id;
  final int userId;
  final int serviceId;
  final String title;
  final String slug;
  final String description;
  final String? location; // Nullable field
  final String startingPrice;
  final String thumbImage;
  final List<String> sliderImages;
  final int status;
  final String createdAt;
  final String updatedAt;
  final ServiceName serviceName;
  final VendorName vendorName;

  ServiceDetails({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.title,
    required this.slug,
    required this.description,
    this.location, // Nullable field
    required this.startingPrice,
    required this.thumbImage,
    required this.sliderImages,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceName,
    required this.vendorName,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      id: json['service_details']['id'],
      userId: json['service_details']['user_id'],
      serviceId: json['service_details']['service_id'],
      title: json['service_details']['title'],
      slug: json['service_details']['slug'],
      description: json['service_details']['description'],
      location: json['service_details']['location'], // Can be null
      startingPrice: json['service_details']['starting_price'],
      thumbImage: json['service_details']['thumb_image'],
      sliderImages: List<String>.from(json['service_details']['slider_images']),
      status: json['service_details']['status'],
      createdAt: json['service_details']['created_at'],
      updatedAt: json['service_details']['updated_at'],
      serviceName: ServiceName.fromJson(json['service_details']['servicename']),
      vendorName: VendorName.fromJson(json['service_details']['vendorname']),
    );
  }
}

class ServiceName {
  final int id;
  final String name;
  final String image;
  final String slug;
  final int status;
  final String createdAt;
  final String updatedAt;

  ServiceName({
    required this.id,
    required this.name,
    required this.image,
    required this.slug,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceName.fromJson(Map<String, dynamic> json) {
    return ServiceName(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      slug: json['slug'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class VendorName {
  final int id;
  final String name;
  final String userName;
  final String email;
  final String phone;
  final String address;
  final String location;
  final String aboutMe;
  final String? facebook; // Nullable field
  final String? twitter; // Nullable field
  final String? linkedin; // Nullable field
  final String? instagram; // Nullable field
  final String createdAt;
  final String updatedAt;
  final int role;
  final int serviceId;

  VendorName({
    required this.id,
    required this.name,
    required this.userName,
    required this.email,
    required this.phone,
    required this.address,
    required this.location,
    required this.aboutMe,
    this.facebook, // Nullable field
    this.twitter, // Nullable field
    this.linkedin, // Nullable field
    this.instagram, // Nullable field
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.serviceId,
  });

  factory VendorName.fromJson(Map<String, dynamic> json) {
    return VendorName(
      id: json['id'],
      name: json['name'],
      userName: json['user_name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      location: json['location'],
      aboutMe: json['about_me'],
      facebook: json['facebook'], // Can be null
      twitter: json['twitter'], // Can be null
      linkedin: json['linkedin'], // Can be null
      instagram: json['instagram'], // Can be null
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      role: json['role'],
      serviceId: json['service_id'],
    );
  }
}

