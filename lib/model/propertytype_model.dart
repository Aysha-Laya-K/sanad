class PropertyTypeResponse {
  final List<PropertyType> propertyTypes;
  final int total;
  final String limit;
  final String offset;

  PropertyTypeResponse({
    required this.propertyTypes,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory PropertyTypeResponse.fromJson(Map<String, dynamic> json) {
    return PropertyTypeResponse(
      propertyTypes: (json['property_types'] as List)
          .map((item) => PropertyType.fromJson(item))
          .toList(),
      total: json['total'],
      limit: json['limit'],
      offset: json['offset'],
    );
  }
}

class PropertyType {
  final int id;
  final String name;
  final String slug;
  final String icon;
  final String? image; // Nullable since `image` can be null
  final int status;
  final String createdAt;
  final String updatedAt;
  final int totalProperty;

  PropertyType({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.totalProperty,
  });

  factory PropertyType.fromJson(Map<String, dynamic> json) {
    return PropertyType(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      icon: json['icon'],
      image: json['image'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      totalProperty: json['totalProperty'],
    );
  }
}
