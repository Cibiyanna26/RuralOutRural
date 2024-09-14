class Doctor {
  String? name;
  String? specialization;
  int? experienceYears;
  String? locationName;
  double? latitude;
  double? longitude;

  Doctor(
      {this.name,
      this.specialization,
      this.experienceYears,
      this.locationName,
      this.latitude,
      this.longitude});

  Doctor.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    specialization = json['specialization'];
    experienceYears = json['experience_years'];
    locationName = json['location_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'specialization': specialization,
      'experience_years': experienceYears,
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude
    };
    return data;
  }
}
