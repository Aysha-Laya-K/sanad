class CustomerneedsModel {
  final bool status;
  final String message;
  final List<CustomerNeed> data;
  final Pagination pagination;

  CustomerneedsModel({
    required this.status,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory CustomerneedsModel.fromJson(Map<String, dynamic> json) {
    return CustomerneedsModel(
      status: json['status'],
      message: json['message'],
      data: List<CustomerNeed>.from(json['data'].map((x) => CustomerNeed.fromJson(x))),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class CustomerNeed {
  final int id;
  final int userId;
  final int role;
  final String title;
  final String slug;
  final String description;
  final int location;
  final String? thumbImage;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerNeed({
    required this.id,
    required this.userId,
    required this.role,
    required this.title,
    required this.slug,
    required this.description,
    required this.location,
    this.thumbImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerNeed.fromJson(Map<String, dynamic> json) {
    return CustomerNeed(
      id: json['id'],
      userId: json['user_id'],
      role: json['role'],
      title: json['title'],
      slug: json['slug'],
      description: _decodeHtml(json['description']), // Decode HTML entities
      location: json['location'],
      thumbImage: json['thumb_image'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Helper function to decode HTML entities
  static String _decodeHtml(String htmlString) {
    return htmlString
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');
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