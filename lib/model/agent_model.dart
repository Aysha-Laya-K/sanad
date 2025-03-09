

class AgentsResponse {
  final SeoSetting seoSetting;
  final Agents agents;

  AgentsResponse({required this.seoSetting, required this.agents});

  factory AgentsResponse.fromJson(Map<String, dynamic> json) {
    return AgentsResponse(
      seoSetting: SeoSetting.fromJson(json['seo_setting']),
      agents: Agents.fromJson(json['agents']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seo_setting': seoSetting.toJson(),
      'agents': agents.toJson(),
    };
  }
}

class SeoSetting {
  final int id;
  final String pageName;
  final String seoTitle;
  final String seoDescription;
  final String? createdAt;
  final String? updatedAt;

  SeoSetting({
    required this.id,
    required this.pageName,
    required this.seoTitle,
    required this.seoDescription,
    this.createdAt,
    this.updatedAt,
  });

  factory SeoSetting.fromJson(Map<String, dynamic> json) {
    return SeoSetting(
      id: json['id'],
      pageName: json['page_name'],
      seoTitle: json['seo_title'],
      seoDescription: json['seo_description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'page_name': pageName,
      'seo_title': seoTitle,
      'seo_description': seoDescription,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Agents {
  final int currentPage;
  final List<AgentData> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  Agents({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Agents.fromJson(Map<String, dynamic> json) {
    return Agents(
      currentPage: json['current_page'],
      data: List<AgentData>.from(json['data'].map((x) => AgentData.fromJson(x))),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: List<Link>.from(json['links'].map((x) => Link.fromJson(x))),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': List<dynamic>.from(links.map((x) => x.toJson())),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class AgentData {
  final int id;
  final String name;
  final String userName;
  final String email;
  final String phone;
  final int status;
  final String? image;
  final String designation;
  final String? facebook;
  final String? twitter;
  final String? linkedin;
  final String? instagram;
  final int kycStatus;
  final String aboutMe;

  AgentData({
    required this.id,
    required this.name,
    required this.userName,
    required this.email,
    required this.phone,
    required this.status,
    this.image,
    required this.designation,
    this.facebook,
    this.twitter,
    this.linkedin,
    this.instagram,
    required this.kycStatus,
    required this.aboutMe,
  });

  factory AgentData.fromJson(Map<String, dynamic> json) {
    return AgentData(
      id: json['id'],
      name: json['name'],
      userName: json['user_name'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
      image: json['image'],
      designation: json['designation'],
      facebook: json['facebook'],
      twitter: json['twitter'],
      linkedin: json['linkedin'],
      instagram: json['instagram'],
      kycStatus: json['kyc_status'],
      aboutMe: json['about_me'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_name': userName,
      'email': email,
      'phone': phone,
      'status': status,
      'image': image,
      'designation': designation,
      'facebook': facebook,
      'twitter': twitter,
      'linkedin': linkedin,
      'instagram': instagram,
      'kyc_status': kycStatus,
      'about_me': aboutMe,
    };
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
