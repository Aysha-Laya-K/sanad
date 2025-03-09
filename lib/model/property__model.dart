import 'dart:ffi';

class PropertyResponse {
  final bool status;
  final String message;
  final List<Property> data;
  final Pagination pagination;

  PropertyResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory PropertyResponse.fromJson(Map<String, dynamic> json) {
    return PropertyResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => Property.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Property {
  final int id;
  final int agentId;
  final String title;
  final String slug;
  final String purpose;
  final String rentPeriod;
  final String price;
  final String thumbnailImage;
  final String address;
  final String totalBedroom;
  final String totalBathroom;
  final String totalArea;
  final String status;
  final String isFeatured;
  final int cityId;
  final int propertyTypeId;
  final int totalRating;
  final double? ratingAverage;
  final Agent agent;

  Property({
    required this.id,
    required this.agentId,
    required this.title,
    required this.slug,
    required this.purpose,
    required this.rentPeriod,
    required this.price,
    required this.thumbnailImage,
    required this.address,
    required this.totalBedroom,
    required this.totalBathroom,
    required this.totalArea,
    required this.status,
    required this.isFeatured,
    required this.cityId,
    required this.propertyTypeId,
    required this.totalRating,
    this.ratingAverage,
    required this.agent,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      agentId: json['agent_id'],
      title: json['title'],
      slug: json['slug'],
      purpose: json['purpose'],
      rentPeriod: json['rent_period'],
      price: json['price'],
      thumbnailImage: json['thumbnail_image'],
      address: json['address'],
      totalBedroom: json['total_bedroom'],
      totalBathroom: json['total_bathroom'],
      totalArea: json['total_area'],
      status: json['status'],
      isFeatured: json['is_featured'],
      cityId: json['city_id'],
      propertyTypeId: json['property_type_id'],
      totalRating: json['totalRating'],
      ratingAverage: json['ratingAvarage']?.toDouble(),
      agent: Agent.fromJson(json['agent']),
    );
  }
}

class Agent {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String designation;
  final String? image;
  final String userName;

  Agent({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.designation,
    this.image,
    required this.userName,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      designation: json['designation'],
      image: json['image'],
      userName: json['user_name'],
    );
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String firstPageUrl;
  final String lastPageUrl;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final String path;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.firstPageUrl,
    required this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
    required this.path,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
      firstPageUrl: json['first_page_url'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      path: json['path'],
    );
  }
}
