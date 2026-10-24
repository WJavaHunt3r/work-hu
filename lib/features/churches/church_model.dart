/// A church of the community, to filter the user list by and to assign to a user.
class ChurchModel {
  const ChurchModel({required this.id, required this.churchName, this.country = ""});

  final num id;
  final String churchName;
  final String country;

  factory ChurchModel.fromJson(Map<String, dynamic> json) => ChurchModel(
    id: json["id"] as num,
    churchName: json["churchName"] as String? ?? "",
    country: json["country"] as String? ?? "",
  );

  @override
  bool operator ==(Object other) => other is ChurchModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
