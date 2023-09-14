import 'dart:convert';
import 'package:fms/model/category_colors.dart';
import 'package:http/http.dart' as http;

abstract class ColorService {
  Future<List<CategoryColors>> fetchCategoryColors();
}

class ColorServiceImplementation implements ColorService {
  @override
  Future<List<CategoryColors>> fetchCategoryColors() async {
    final response = await http.get(Uri.parse('http://192.168.0.2:8080/colors'));
    final List<CategoryColors> result = jsonDecode(response.body)
        .map<CategoryColors>((json) => CategoryColors.fromJson(json)).toList();
    return result;
  }
}