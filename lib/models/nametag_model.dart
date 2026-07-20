class NametagModel {
  final int id;
  final String userName;
  final String barcode;
  final String? url;

  NametagModel({
    required this.id,
    required this.userName,
    required this.barcode,
    this.url,
  });

  factory NametagModel.fromJson(Map<String, dynamic> json) {
    return NametagModel(
      id: json['id'] as int,
      userName: json['name'] ?? json['user_name'] ?? 'Unknown',
      barcode: json['username'] ?? json['barcode'] ?? '',
      url: json['url'],
    );
  }
}
