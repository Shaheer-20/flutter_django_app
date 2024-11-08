import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_django_app/models/item.dart';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000/api/"; // Django backend URL

  // Fetch items from the Django API
  Future<List<Item>> fetchItems() async {
    final response = await http.get(Uri.parse('${baseUrl}items/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Item.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  // Create a new item
  Future<Item> createItem(Item item) async {
    final response = await http.post(
      Uri.parse('${baseUrl}items/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );

    if (response.statusCode == 201) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create item');
    }
  }

  // Update an item
  Future<Item> updateItem(int id, Item item) async {
    final response = await http.put(
      Uri.parse('${baseUrl}items/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );

    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update item');
    }
  }

  // Delete an item
  Future<void> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('${baseUrl}items/$id/'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete item');
    }
  }
}
