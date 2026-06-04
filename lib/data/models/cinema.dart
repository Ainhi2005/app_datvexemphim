class Cinema {
  final int id;
  final String name;
  final String address;

  Cinema({required this.id, required this.name, required this.address});

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }
}