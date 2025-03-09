class UserProfile {
  final int? id;
  final String? name;
  final String? email;
  final String? image;
  final String? phone;
  final String? address;
  final int? status;
  final String? aboutMe;
  final String? facebook;
  final String? twitter;
  final String? linkedin;
  final String? instagram;
  final String? designation;
  final int? kycStatus;

  UserProfile({
    this.id,
    this.name,
    this.email,
    this.image,
    this.phone,
    this.address,
    this.status,
    this.aboutMe,
    this.facebook,
    this.twitter,
    this.linkedin,
    this.instagram,
    this.designation,
    this.kycStatus,
  });

  // Factory method to create a UserProfile instance from JSON data
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      status: json['status'] as int?,
      aboutMe: json['about_me'] as String?,
      facebook: json['facebook'] as String?,
      twitter: json['twitter'] as String?,
      linkedin: json['linkedin'] as String?,
      instagram: json['instagram'] as String?,
      designation: json['designation'] as String?,
      kycStatus: json['kyc_status'] as int?,
    );
  }

  // Method to convert the UserProfile instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'phone': phone,
      'address': address,
      'status': status,
      'about_me': aboutMe,
      'facebook': facebook,
      'twitter': twitter,
      'linkedin': linkedin,
      'instagram': instagram,
      'designation': designation,
      'kyc_status': kycStatus,
    };
  }
}
