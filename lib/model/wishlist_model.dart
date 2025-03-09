class WishlistResponse {
  final Properties properties;

  WishlistResponse({
    required this.properties,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      properties: Properties.fromJson(json['properties']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'properties': properties.toJson(),
    };
  }
}

class Properties {
  final int currentPage;
  final List<Property> data;
  final String firstPageUrl;
  final int? from;
  final int lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  Properties({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List<dynamic>;
    var linksList = json['links'] as List<dynamic>;

    return Properties(
      currentPage: json['current_page'] as int,
      data: dataList.map((item) => Property.fromJson(item)).toList(),
      firstPageUrl: json['first_page_url'] as String,
      from: json['from'] != null ? json['from'] as int : null,
      lastPage: json['last_page'] as int,
      lastPageUrl: json['last_page_url'] as String,
      links: linksList.map((item) => Link.fromJson(item)).toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String,
      perPage: json['per_page'] is int
          ? json['per_page'] as int
          : int.tryParse(json['per_page'].toString()) ?? 0,
      prevPageUrl: json['prev_page_url'] as String?,
      to: json['to'] != null ? json['to'] as int : null,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((item) => item.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((item) => item.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
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
  final double? ratingAvarage;

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
    this.ratingAvarage,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as int,
      agentId: json['agent_id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String,
      purpose: json['purpose'] as String,
      rentPeriod: json['rent_period'] as String,
      price: json['price'] as String,
      thumbnailImage: json['thumbnail_image'] as String,
      address: json['address'] as String,
      totalBedroom: json['total_bedroom'] as String,
      totalBathroom: json['total_bathroom'] as String,
      totalArea: json['total_area'] as String,
      status: json['status'] as String,
      isFeatured: json['is_featured'] as String,
      cityId: json['city_id'] as int,
      propertyTypeId: json['property_type_id'] as int,
      totalRating: json['totalRating'] as int,
      ratingAvarage: json['ratingAvarage'] != null
          ? (json['ratingAvarage'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agent_id': agentId,
      'title': title,
      'slug': slug,
      'purpose': purpose,
      'rent_period': rentPeriod,
      'price': price,
      'thumbnail_image': thumbnailImage,
      'address': address,
      'total_bedroom': totalBedroom,
      'total_bathroom': totalBathroom,
      'total_area': totalArea,
      'status': status,
      'is_featured': isFeatured,
      'city_id': cityId,
      'property_type_id': propertyTypeId,
      'totalRating': totalRating,
      'ratingAvarage': ratingAvarage,
    };
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'] as String?,
      label: json['label'] as String,
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
