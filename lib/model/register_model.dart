class RegisterApiResponse {
  final String responseCode;
  final bool status;
  final String? token;
  final String message;
  final UserDetails? userDetails;

  RegisterApiResponse({
    required this.responseCode,
    required this.status,
    this.token,
    required this.message,
    this.userDetails,
  });

  factory RegisterApiResponse.fromJson(Map<String, dynamic> json) {
    return RegisterApiResponse(
      responseCode: json['response_code'],
      status: json['status'],
      token: json['token'],
      message: json['message'],
      userDetails: json['user_details'] != null
          ? UserDetails.fromJson(json['user_details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response_code': responseCode,
      'status': status,
      'token': token,
      'message': message,
      'user_details': userDetails?.toJson(),
    };
  }
}

class UserDetails {
  final int id;
  final String name;
  final String email;
  final String? image;
  final String phone;

  UserDetails({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    required this.phone,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'phone': phone,
    };
  }
}