class ServiceTypeResponse {
  final List<ServiceType> services;
  final int total;
  final String limit;
  final String offset;

  ServiceTypeResponse({
    required this.services,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory ServiceTypeResponse.fromJson(Map<String, dynamic> json) {
    return ServiceTypeResponse(
      services: (json['services'] as List)
          .map((item) => ServiceType.fromJson(item))
          .toList(),
      total: json['total'],
      limit: json['limit'],
      offset: json['offset'],
    );
  }
}

class ServiceType {
  final int id;
  final String name;
  final String image;
  final String slug;
  final int status;
  final String createdAt;
  final String updatedAt;

  ServiceType({
    required this.id,
    required this.name,
    required this.image,
    required this.slug,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
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
