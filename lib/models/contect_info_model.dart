class Address {
  final String addressLine1;
  final String city;
  final String state;
  final String pincode;
  final String country;

  Address({
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressLine1: json['addressLine1'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

class ContactInfo {
  final String businessName;
  final String supportEmail;
  final String contactNumber;
  final String whatsappNumber;
  final String website;
  final Address address;

  ContactInfo({
    required this.businessName,
    required this.supportEmail,
    required this.contactNumber,
    required this.whatsappNumber,
    required this.website,
    required this.address,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      businessName: json['businessName'] ?? '',
      supportEmail: json['supportEmail'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      whatsappNumber: json['whatsappNumber'] ?? '',
      website: json['website'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
    );
  }
}
