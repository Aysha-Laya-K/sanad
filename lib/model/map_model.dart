class MapDataResponse {
  bool status;
  String message;
  List<MapData> data;

  MapDataResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MapDataResponse.fromJson(Map<String, dynamic> json) {
    return MapDataResponse(
      status: json['status'],
      message: json['message'],
      data: List<MapData>.from(json['data'].map((item) => MapData.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class MapData {
  int id;
  String title;
  String price;
  String? lat;
  String? lon;
  int totalRating;
  String? ratingAvarage;
  String? agent;

  MapData({
    required this.id,
    required this.title,
    required this.price,
    this.lat,
    this.lon,
    required this.totalRating,
    this.ratingAvarage,
    this.agent,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      lat: json['lat'],
      lon: json['lon'],
      totalRating: json['totalRating'],
      ratingAvarage: json['ratingAvarage'],
      agent: json['agent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'lat': lat,
      'lon': lon,
      'totalRating': totalRating,
      'ratingAvarage': ratingAvarage,
      'agent': agent,
    };
  }
}
