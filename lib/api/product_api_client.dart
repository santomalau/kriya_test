import 'dart:convert';

import 'package:kriya/api/api.dart';
import 'package:kriya/api/queries/queries.dart' as queries;
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

class GetProductRequestFailure implements Exception {}

class ProductApiClient {
  // Future<List<Product>> getProduct() async {
  //   final result = await _graphQLClient.query(
  //     QueryOptions(
  //         document: gql(queries.getProduct),
  //         fetchPolicy: FetchPolicy.cacheAndNetwork),
  //   );
  //   if (result.hasException) throw GetProductRequestFailure();
  //   final data = result.data?['persons'] as List;
  //   print("Panjang GET: " + data.length.toString());
  //   return data.map((e) => Product.fromJson(e)).toList();
  // }
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
