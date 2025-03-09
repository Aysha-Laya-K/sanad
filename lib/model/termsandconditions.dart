class TermsConditionsResponse {
  final String termsConditions;

  TermsConditionsResponse({
    required this.termsConditions,
  });

  factory TermsConditionsResponse.fromJson(Map<String, dynamic> json) {
    return TermsConditionsResponse(
      termsConditions: json['terms_conditions'],
    );
  }
}
