import 'dart:convert';

class NotificationResponse {
  List<NotificationItem> notifications;
  int total;
  int limit;
  int offset;

  NotificationResponse({
    required this.notifications,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory NotificationResponse.fromJson(String str) =>
      NotificationResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationResponse.fromMap(Map<String, dynamic> json) =>
      NotificationResponse(
        notifications: List<NotificationItem>.from(
            json["notifications"].map((x) => NotificationItem.fromMap(x))),
        total: json["total"],
        limit: json["limit"],
        offset: json["offset"],
      );

  Map<String, dynamic> toMap() => {
    "notifications": List<dynamic>.from(notifications.map((x) => x.toMap())),
    "total": total,
    "limit": limit,
    "offset": offset,
  };
}

class NotificationItem {
  int id;
  String title;
  String titleAr;
  String description;
  String descriptionAr;
  String image;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromMap(Map<String, dynamic> json) => NotificationItem(
    id: json["id"],
    title: json["title"],
    titleAr: json["titlear"],
    description: json["description"],
    descriptionAr: json["descriptionar"],
    image: json["image"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "titlear": titleAr,
    "description": description,
    "descriptionar": descriptionAr,
    "image": image,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
