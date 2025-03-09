class AmenitiesResponse {
  final List<Amenity> amenities;
  final int total;
  final String limit;
  final String offset;

  AmenitiesResponse({
    required this.amenities,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory AmenitiesResponse.fromJson(Map<String, dynamic> json) {
    return AmenitiesResponse(
      amenities: (json['amenities'] as List)
          .map((item) => Amenity.fromJson(item))
          .toList(),
      total: json['total'],
      limit: json['limit'],
      offset: json['offset'],
    );
  }
}

class Amenity {
  final int id;
  final String aminity;
  final int status;
  final String createdAt;
  final String updatedAt;

  Amenity({
    required this.id,
    required this.aminity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['id'],
      aminity: json['aminity'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
