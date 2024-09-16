class Doctor {
  int? id;
  String? name;
  String? phoneNumber;
  String? specialization;
  int? experienceYears;
  String? locationName;
  double? latitude;
  double? longitude;
  String? bio;

  Doctor(
      {this.id,
      this.name,
      this.phoneNumber,
      this.specialization,
      this.experienceYears,
      this.locationName,
      this.latitude,
      this.longitude,
      this.bio});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phonenumber'];
    specialization = json['specialization'];
    experienceYears = json['experience_years'];
    locationName = json['location_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    bio = json['bio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'name': name,
      'phonenumber': phoneNumber,
      'specialization': specialization,
      'experience_years': experienceYears,
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'bio': bio
    };
    return data;
  }

  @override
  String toString() {
    return 'Doctor{id: $id, name: $name, phoneNumber: $phoneNumber, specialization: $specialization, experienceYears: $experienceYears, locationName: $locationName, latitude: $latitude, longitude: $longitude, bio: $bio}';
  }
}
