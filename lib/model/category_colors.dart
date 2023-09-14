class CategoryColors {
  int? colorId;
  String? colorName;
  String? hexCode;

  CategoryColors({this.colorId, this.colorName, this.hexCode});

  factory CategoryColors.fromJson(Map<String, dynamic> json) {
    return CategoryColors(
      colorId: json['colorId'],
      colorName: json['colorName'],
      hexCode: json['hexCode']
    );
  }
}