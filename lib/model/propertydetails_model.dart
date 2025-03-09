class ApiResponse {
  final Property? property;
  final List<Slider>? sliders;
  final List<PropertyAminity>? aminities;
  final List<NearestLocation>? nearestLocations;
  final List<AdditionalInformation>? additionalInformations;
  final List<PropertyPlan>? propertyPlans;
  final Reviews? reviews;
  final PropertyAgent? propertyAgent;
  final RecaptchaSetting? recaptchaSetting;
  final List<RelatedProperty>? relatedProperties;

  ApiResponse({
    this.property,
    this.sliders,
    this.aminities,
    this.nearestLocations,
    this.additionalInformations,
    this.propertyPlans,
    this.reviews,
    this.propertyAgent,
    this.recaptchaSetting,
    this.relatedProperties,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    property: json["property"] == null
        ? null
        : Property.fromJson(json["property"]),
    sliders: json["sliders"] == null
        ? null
        : List<Slider>.from(
        json["sliders"].map((x) => Slider.fromJson(x))),
    aminities: json["aminities"] == null
        ? null
        : List<PropertyAminity>.from(
        json["aminities"].map((x) => PropertyAminity.fromJson(x))),
    nearestLocations: json["nearest_locations"] == null
        ? null
        : List<NearestLocation>.from(
        json["nearest_locations"].map((x) => NearestLocation.fromJson(x))),
    additionalInformations: json["additional_informations"] == null
        ? null
        : List<AdditionalInformation>.from(json["additional_informations"]
        .map((x) => AdditionalInformation.fromJson(x))),
    propertyPlans: json["property_plans"] == null
        ? null
        : List<PropertyPlan>.from(
        json["property_plans"].map((x) => PropertyPlan.fromJson(x))),
    reviews:
    json["reviews"] == null ? null : Reviews.fromJson(json["reviews"]),
    propertyAgent: json["property_agent"] == null
        ? null
        : PropertyAgent.fromJson(json["property_agent"]),
    recaptchaSetting: json["recaptcha_setting"] == null
        ? null
        : RecaptchaSetting.fromJson(json["recaptcha_setting"]),
    relatedProperties: (json["related_properties"] as List?)
        ?.map((e) => RelatedProperty.fromJson(e as Map<String, dynamic>))
        .toList(), // Deserialize related properties
  );

}

class Property {
  final int? id;
  final int? agentId;
  final int? propertyTypeId;
  final int? cityId;
  final String? title;
  final String? slug;
  final String? purpose;
  final String? rentPeriod;
  final String? price;
  final String? furnish;
  final String? thumbnailImage;
  final String? description;
  final String? videoDescription;
  final String? videoThumbnail;
  final String? videoId;
  final String? address;
  final String? addressDescription;
  final String? googleMap;
  final String? totalArea;
  final String? totalUnit;
  final String? totalBedroom;
  final String? totalBathroom;
  final String? totalGarage;
  final String? totalKitchen;
  final String? isFeatured;
  final String? isTop;
  final String? isUrgent;
  final String? status;
  final DateTime? expiredDate;
  final String? seoTitle;
  final String? seoMetaDescription;
  final int? serial;
  final String? showSlider;
  final String? approveByAdmin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? timeFrom;
  final String? timeTo;
  final int? countryId;
  final double? lat;
  final double? lon;
  final int? totalRating;
  final double? ratingAvarage;

  Property({
    this.id,
    this.agentId,
    this.propertyTypeId,
    this.cityId,
    this.title,
    this.slug,
    this.purpose,
    this.rentPeriod,
    this.price,
    this.furnish,
    this.thumbnailImage,
    this.description,
    this.videoDescription,
    this.videoThumbnail,
    this.videoId,
    this.address,
    this.addressDescription,
    this.googleMap,
    this.totalArea,
    this.totalUnit,
    this.totalBedroom,
    this.totalBathroom,
    this.totalGarage,
    this.totalKitchen,
    this.isFeatured,
    this.isTop,
    this.isUrgent,
    this.status,
    this.expiredDate,
    this.seoTitle,
    this.seoMetaDescription,
    this.serial,
    this.showSlider,
    this.approveByAdmin,
    this.createdAt,
    this.updatedAt,
    this.dateFrom,
    this.dateTo,
    this.timeFrom,
    this.timeTo,
    this.countryId,
    this.lat,
    this.lon,
    this.totalRating,
    this.ratingAvarage,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    id: json["id"] as int?,
    agentId: json["agent_id"] as int?,
    propertyTypeId: json["property_type_id"] as int?,
    cityId: json["city_id"] as int?,
    title: json["title"] as String?,
    slug: json["slug"] as String?,
    purpose: json["purpose"] as String?,
    rentPeriod: json["rent_period"] as String?,
    price: json["price"] as String?,
    furnish: json["furnish"] as String?,

    thumbnailImage: json["thumbnail_image"] as String?,
    description: json["description"] as String?,
    videoDescription: json["video_description"] as String?,
    videoThumbnail: json["video_thumbnail"] as String?,
    videoId: json["video_id"] as String?,
    address: json["address"] as String?,
    addressDescription: json["address_description"] as String?,
    googleMap: json["google_map"] as String?,
    totalArea: json["total_area"] as String?,
    totalUnit: json["total_unit"] as String?,
    totalBedroom: json["total_bedroom"] as String?,
    totalBathroom: json["total_bathroom"] as String?,
    totalGarage: json["total_garage"] as String?,
    totalKitchen: json["total_kitchen"] as String?,
    isFeatured: json["is_featured"] as String?,
    isTop: json["is_top"] as String?,
    isUrgent: json["is_urgent"] as String?,
    status: json["status"] as String?,
    expiredDate: json["expired_date"] == null
        ? null
        : DateTime.parse(json["expired_date"] as String),
    seoTitle: json["seo_title"] as String?,
    seoMetaDescription: json["seo_meta_description"] as String?,
    serial: json["serial"] as int?,
    showSlider: json["show_slider"] as String?,
    approveByAdmin: json["approve_by_admin"] as String?,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"] as String),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"] as String),
    dateFrom: json["date_from"] == null
        ? null
        : DateTime.parse(json["date_from"] as String),
    dateTo: json["date_to"] == null
        ? null
        : DateTime.parse(json["date_to"] as String),
    timeFrom: json["time_from"] as String?,
    timeTo: json["time_to"] as String?,
    countryId: json["country_id"] as int?,
    lat: json["lat"] != null ? double.tryParse(json["lat"].toString()) : null,
    lon: json["lon"] != null ? double.tryParse(json["lon"].toString()) : null,
    ratingAvarage: json["ratingAvarage"] != null
        ? double.tryParse(json["ratingAvarage"].toString())
        : null,
    totalRating: json["totalRating"] as int?,

  );
}

class Slider {
  final int? id;
  final int? propertyId;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Slider({
    this.id,
    this.propertyId,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
    id: json["id"] as int?,
    propertyId: json["property_id"] as int?,
    image: json["image"] as String?,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"] as String),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"] as String),
  );
}

class PropertyAminity {
  final int? id;
  final int? aminityId;
  final int? propertyId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Aminity? aminity;

  PropertyAminity({
    this.id,
    this.aminityId,
    this.propertyId,
    this.createdAt,
    this.updatedAt,
    this.aminity,
  });

  factory PropertyAminity.fromJson(Map<String, dynamic> json) => PropertyAminity(
    id: json["id"] as int?,
    aminityId: json["aminity_id"] as int?,
    propertyId: json["property_id"] as int?,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"] as String),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"] as String),
    aminity: json["aminity"] == null
        ? null
        : Aminity.fromJson(json["aminity"]),
  );
}

class Aminity {
  final int? id;
  final String? aminity;

  Aminity({
    this.id,
    this.aminity,
  });

  factory Aminity.fromJson(Map<String, dynamic> json) => Aminity(
    id: json["id"] as int?,
    aminity: json["aminity"] as String?,
  );
}

class NearestLocation {
  final int? id;
  final int? propertyId;
  final int? nearestLocationId;
  final String? distance;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Location? location;

  NearestLocation({
    this.id,
    this.propertyId,
    this.nearestLocationId,
    this.distance,
    this.createdAt,
    this.updatedAt,
    this.location,
  });

  factory NearestLocation.fromJson(Map<String, dynamic> json) => NearestLocation(
    id: json["id"] as int?,
    propertyId: json["property_id"] as int?,
    nearestLocationId: json["nearest_location_id"] as int?,
    distance: json["distance"] as String?,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"] as String),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"] as String),
    location: json["location"] == null
        ? null
        : Location.fromJson(json["location"]),
  );
}

class Location {
  final int? id;
  final String? location;
  final int? status;

  Location({
    this.id,
    this.location,
    this.status,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"] as int?,
    location: json["location"] as String?,
    status: json["status"] as int?,
  );
}

class AdditionalInformation {
  final int? id;
  final int? propertyId;
  final String? addKey;
  final String? addValue;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdditionalInformation({
    this.id,
    this.propertyId,
    this.addKey,
    this.addValue,
    this.createdAt,
    this.updatedAt,
  });

  factory AdditionalInformation.fromJson(Map<String, dynamic> json) =>
      AdditionalInformation(
        id: json["id"] as int?,
        propertyId: json["property_id"] as int?,
        addKey: json["add_key"] as String?,
        addValue: json["add_value"] as String?,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"] as String),
      );
}

class PropertyPlan {
  final int? id;
  final int? propertyId;
  final String? title;
  final String? description;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PropertyPlan({
    this.id,
    this.propertyId,
    this.title,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory PropertyPlan.fromJson(Map<String, dynamic> json) => PropertyPlan(
    id: json["id"] as int?,
    propertyId: json["property_id"] as int?,
    title: json["title"] as String?,
    description: json["description"] as String?,
    image: json["image"] as String?,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"] as String),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"] as String),
  );
}

class Reviews {
  final int? currentPage;
  final List<ReviewData>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  Reviews({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    currentPage: json["current_page"] as int?,
    data: json["data"] == null
        ? null
        : List<ReviewData>.from(json["data"].map((x) => ReviewData.fromJson(x))),
    firstPageUrl: json["first_page_url"] as String?,
    from: json["from"] as int?,
    lastPage: json["last_page"] as int?,
    lastPageUrl: json["last_page_url"] as String?,
    links: json["links"] == null
        ? null
        : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"] as String?,
    path: json["path"] as String?,
    perPage: json["per_page"] as int?,
    prevPageUrl: json["prev_page_url"] as String?,
    to: json["to"] as int?,
    total: json["total"] as int?,
  );
}

class ReviewData {
  final int? id;
  final int? propertyId;
  final int? userId;
  final int? agentId;
  final String? review;
  final int? rating;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final User? user;

  ReviewData({
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

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
    id: json["id"] as int?,
    propertyId: json["property_id"] as int?,
    userId: json["user_id"] as int?,
    agentId: json["agent_id"] as int?,
    review: json["review"] as String?,
    rating: json["rating"] as int?,
    status: json["status"] as int?,
    createdAt: json["created_at"] as String?,
    updatedAt: json["updated_at"] as String?,
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
  final String? createdAt;

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
    createdAt: json["created_at"] as String?,
  );
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] as String?,
    label: json["label"] as String?,
    active: json["active"] as bool?,
  );
}


class PropertyAgent {
  final String? agentType;
  final int? id;
  final String? name;
  final String? userName;
  final String? designation;
  final String? phone;
  final String? email;
  final dynamic image;
  final int? kycStatus;

  PropertyAgent({
    this.agentType,
    this.id,
    this.name,
    this.userName,
    this.designation,
    this.phone,
    this.email,
    this.image,
    this.kycStatus,
  });

  factory PropertyAgent.fromJson(Map<String, dynamic> json) => PropertyAgent(
    agentType: json["agent_type"] as String?,
    id: json["id"] as int?,
    name: json["name"] as String?,
    userName: json["user_name"] as String?,
    designation: json["designation"] as String?,
    phone: json["phone"] as String?,
    email: json["email"] as String?,
    image: json["image"],
    kycStatus: json["kyc_status"] as int?,
  );
}

class RecaptchaSetting {
  final int? id;
  final String? siteKey;
  final String? secretKey;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RecaptchaSetting({
    this.id,
    this.siteKey,
    this.secretKey,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory RecaptchaSetting.fromJson(Map<String, dynamic> json) =>
      RecaptchaSetting(
        id: json["id"] as int?,
        siteKey: json["site_key"] as String?,
        secretKey: json["secret_key"] as String?,
        status: json["status"] as int?,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"] as String),
      );
}



class RelatedProperty {
  final int? id;
  final int? agentId;
  final int? propertyTypeId;
  final int? cityId;
  final String? furnish;
  final String? title;
  final String? slug;
  final String? purpose;
  final String? rentPeriod;
  final String? price;
  final String? thumbnailImage;
  final String? description;
  final String? videoDescription;
  final String? videoThumbnail;
  final String? videoId;
  final String? address;
  final String? addressDescription;
  final String? googleMap;
  final String? totalArea;
  final String? totalUnit;
  final String? totalBedroom;
  final String? totalBathroom;
  final String? totalGarage;
  final String? totalKitchen;
  final String? isFeatured;
  final String? isTop;
  final String? isUrgent;
  final String? status;
  final String? expiredDate;
  final String? seoTitle;
  final String? seoMetaDescription;
  final int? serial;
  final String? showSlider;
  final String? approveByAdmin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? dateFrom;
  final String? dateTo;
  final String? timeFrom;
  final String? timeTo;
  final int? countryId;
  final String? lat;
  final String? lon;
  final int? totalRating;
  final double? ratingAvarage;

  RelatedProperty({
    this.id,
    this.agentId,
    this.propertyTypeId,
    this.cityId,
    this.furnish,
    this.title,
    this.slug,
    this.purpose,
    this.rentPeriod,
    this.price,
    this.thumbnailImage,
    this.description,
    this.videoDescription,
    this.videoThumbnail,
    this.videoId,
    this.address,
    this.addressDescription,
    this.googleMap,
    this.totalArea,
    this.totalUnit,
    this.totalBedroom,
    this.totalBathroom,
    this.totalGarage,
    this.totalKitchen,
    this.isFeatured,
    this.isTop,
    this.isUrgent,
    this.status,
    this.expiredDate,
    this.seoTitle,
    this.seoMetaDescription,
    this.serial,
    this.showSlider,
    this.approveByAdmin,
    this.createdAt,
    this.updatedAt,
    this.dateFrom,
    this.dateTo,
    this.timeFrom,
    this.timeTo,
    this.countryId,
    this.lat,
    this.lon,
    this.totalRating,
    this.ratingAvarage,
  });

  factory RelatedProperty.fromJson(Map<String, dynamic> json) => RelatedProperty(
    id: json["id"] as int?,
    agentId: json["agent_id"] as int?,
    propertyTypeId: json["property_type_id"] as int?,
    cityId: json["city_id"] as int?,
    furnish: json["furnish"] as String?,
    title: json["title"] as String?,
    slug: json["slug"] as String?,
    purpose: json["purpose"] as String?,
    rentPeriod: json["rent_period"] as String?,
    price: json["price"] as String?,
    thumbnailImage: json["thumbnail_image"] as String?,
    description: json["description"] as String?,
    videoDescription: json["video_description"] as String?,
    videoThumbnail: json["video_thumbnail"] as String?,
    videoId: json["video_id"] as String?,
    address: json["address"] as String?,
    addressDescription: json["address_description"] as String?,
    googleMap: json["google_map"] as String?,
    totalArea: json["total_area"] as String?,
    totalUnit: json["total_unit"] as String?,
    totalBedroom: json["total_bedroom"] as String?,
    totalBathroom: json["total_bathroom"] as String?,
    totalGarage: json["total_garage"] as String?,
    totalKitchen: json["total_kitchen"] as String?,
    isFeatured: json["is_featured"] as String?,
    isTop: json["is_top"] as String?,
    isUrgent: json["is_urgent"] as String?,
    status: json["status"] as String?,
    expiredDate: json["expired_date"] as String?,
    seoTitle: json["seo_title"] as String?,
    seoMetaDescription: json["seo_meta_description"] as String?,
    serial: json["serial"] as int?,
    showSlider: json["show_slider"] as String?,
    approveByAdmin: json["approve_by_admin"] as String?,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"] as String),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"] as String),
    dateFrom: json["date_from"] as String?,
    dateTo: json["date_to"] as String?,
    timeFrom: json["time_from"] as String?,
    timeTo: json["time_to"] as String?,
    countryId: json["country_id"] as int?,
    lat: json["lat"] as String?,
    lon: json["lon"] as String?,
    totalRating: json["totalRating"] as int?,
    ratingAvarage: json["ratingAvarage"] as double?,
  );
}
