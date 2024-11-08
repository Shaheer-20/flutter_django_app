import 'package:flutter/material.dart';
import 'package:flutter_django_app/models/item.dart';
import 'package:flutter_django_app/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Django App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ItemListPage(),
    );
  }
}

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  late ApiService apiService;
  late Future<List<Item>> futureItems;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futureItems = apiService.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: FutureBuilder<List<Item>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items available'));
          }

          var items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index].name),
                subtitle: Text(items[index].description),
                onTap: () {
                  // Implement edit or delete functionality if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
