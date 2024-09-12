class EditProfileObjects {
  final String name;
  final String email;
  final String phone;
  final String age;
  final String location;
  final Function(String, String, String, String, String) onSave;

  EditProfileObjects(
      {required this.name,
      required this.email,
      required this.phone,
      required this.age,
      required this.location,
      required this.onSave});
}
