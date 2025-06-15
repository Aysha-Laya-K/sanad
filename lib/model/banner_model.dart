class HomeBannerResponse {
  final BannerData banner;

  HomeBannerResponse({required this.banner});

  factory HomeBannerResponse.fromJson(Map<String, dynamic> json) {
    return HomeBannerResponse(
      banner: BannerData.fromJson(json['banner']),
    );
  }
}

class BannerData {
  final String bgImage;
  final String title;

  BannerData({required this.bgImage, required this.title});

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      bgImage: json['bg_image'],
      title: json['title'],
    );
  }
}