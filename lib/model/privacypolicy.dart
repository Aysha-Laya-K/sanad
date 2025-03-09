class PrivacyPolicyResponse {
  final String privacyPolicy;

  PrivacyPolicyResponse({
    required this.privacyPolicy,
  });

  factory PrivacyPolicyResponse.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyResponse(
      privacyPolicy: json['privacyPolicy'],
    );
  }
}
