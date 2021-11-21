import 'dart:convert';

import 'package:kriya/api/api.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

class GetProductRequestFailure implements Exception {}

class ProductApiClient {
  Future<List<Product>> fetchProduct() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed.map<Product>((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load product');
    }
  }
}
