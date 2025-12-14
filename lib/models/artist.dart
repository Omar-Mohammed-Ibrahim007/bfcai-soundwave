class Artist {
  final String id;
  final String name;
  final String image;
  final String website;
  final String joinDate;
  bool isFavorite;

  Artist({
    required this.id,
    required this.name,
    required this.image,
    this.website = '',
    this.joinDate = '',
    this.isFavorite = false,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      website: json['website'] ?? '',
      joinDate: json['joindate'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'website': website,
      'joindate': joinDate,
      'isFavorite': isFavorite,
    };
  }

  Artist copyWith({
    String? id,
    String? name,
    String? image,
    String? website,
    String? joinDate,
    bool? isFavorite,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      website: website ?? this.website,
      joinDate: joinDate ?? this.joinDate,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
