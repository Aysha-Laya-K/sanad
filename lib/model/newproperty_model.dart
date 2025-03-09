class NewPropertyResponse {
  final bool status;
  final String message;
  final List<NewProperty> data;
  final Pagination pagination;

  NewPropertyResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory NewPropertyResponse.fromJson(Map<String, dynamic> json) {
    return NewPropertyResponse(
      status: json['status'] ?? false, // Default to false if not present
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => NewProperty.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class NewProperty {
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
  final int? totalRating;
  final double? ratingAvarage;
  final Agent agent;

  NewProperty({
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
    this.totalRating,
    this.ratingAvarage,
    required this.agent,
  });

  factory NewProperty.fromJson(Map<String, dynamic> json) {
    return NewProperty(
      id: json['id'] ?? 0,
      agentId: json['agent_id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      purpose: json['purpose'] ?? '',
      rentPeriod: json['rent_period'] ?? '',
      price: json['price'] ?? '',
      thumbnailImage: json['thumbnail_image'] ?? '',
      address: json['address'] ?? '',
      totalBedroom: json['total_bedroom'] ?? '',
      totalBathroom: json['total_bathroom'] ?? '',
      totalArea: json['total_area'] ?? '',
      status: json['status'] ?? '',
      isFeatured: json['is_featured'] ?? '',
      totalRating: json['totalRating'] != null ? json['totalRating'] : null,
      ratingAvarage: json['ratingAvarage'] != null
          ? (json['ratingAvarage'] is int
          ? (json['ratingAvarage'] as int).toDouble()
          : json['ratingAvarage'].toDouble())
          : null,
      agent: Agent.fromJson(json['agent'] ?? {}),
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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      designation: json['designation'] ?? '',
      image: json['image'],
      userName: json['user_name'] ?? '',
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      totalItems: json['total_items'] ?? 0,
      itemsPerPage: json['items_per_page'] ?? 0,
    );
  }
}

