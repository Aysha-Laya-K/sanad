class Location {
  final int id;
  final String name;
  final String slug;
  final String image;
  final int showHomepage;
  final int serial;
  final String createdAt;
  final String updatedAt;
  final int countryId;
  final int totalProperty;

  Location({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.showHomepage,
    required this.serial,
    required this.createdAt,
    required this.updatedAt,
    required this.countryId,
    required this.totalProperty,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
      showHomepage: json['show_homepage'],
      serial: json['serial'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      countryId: json['country_id'],
      totalProperty: json['totalProperty'],
    );
  }
}
