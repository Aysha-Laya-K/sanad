class ReviewResponse {
  final List<Review>? reviews;

  ReviewResponse({
    this.reviews,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
    reviews: json["reviews"] == null
        ? null
        : List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
  );
}

class Review {
  final int? id;
  final int? propertyId;
  final int? userId;
  final int? agentId;
  final String? review;
  final int? rating;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  Review({
    this.id,
    this.propertyId,
    this.userId,
    this.agentId,
    this.review,
    this.rating,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"] as int?,
    propertyId: json["property_id"] as int?,
    userId: json["user_id"] as int?,
    agentId: json["agent_id"] as int?,
    review: json["review"] as String?,
    rating: json["rating"] as int?,
    status: json["status"] as int?,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"] as String),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"] as String),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? image;
  final String? phone;
  final String? designation;
  final int? status;
  final String? address;
  final DateTime? createdAt;

  User({
    this.id,
    this.name,
    this.email,
    this.image,
    this.phone,
    this.designation,
    this.status,
    this.address,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] as int?,
    name: json["name"] as String?,
    email: json["email"] as String?,
    image: json["image"] as String?,
    phone: json["phone"] as String?,
    designation: json["designation"] as String?,
    status: json["status"] as int?,
    address: json["address"] as String?,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"] as String),
  );
}