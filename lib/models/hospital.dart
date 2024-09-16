class Hospital {
  final String name;
  final String speciality;
  final double lat;
  final double lon;
  final double distance;

  Hospital(
      {required this.name,
      required this.speciality,
      required this.lat,
      required this.lon,
      required this.distance});

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['name'],
      speciality: json['speciality'],
      lat: json['lat'],
      lon: json['lon'],
      distance: json['distance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'speciality': speciality,
      'lat': lat,
      'lon': lon,
      'distance': distance,
    };
  }

  @override
  String toString() {
    return 'Hospital{name: $name, speciality: $speciality, lat: $lat, lon: $lon, distance: $distance}';
  }
}
