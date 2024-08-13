import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/catogeory.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Category>> _futurecatogeries;

  @override
  void initState() {
    super.initState();
    _futurecatogeries = _fetchcategorie();
  }

  Future<List<Category>> _fetchcategorie() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));
    if (response.statusCode == 200) {
      List<Category> categories = (jsonDecode(response.body)['categories'] as List)
          .map((json) => Category.fromJson(json))
          .toList();
      return categories;
    } else {
      throw Exception("Failed to load categories");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Meal",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900,color: Colors.blue),

            ),
            Text(
              "Shop",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900,color: Colors.black),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Category>>(
        future: _futurecatogeries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No data available"),
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _navigateToDetailsPage(context, snapshot.data![index]),
                  child: _mealCategory(snapshot.data![index]),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _mealCategory(Category cat) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(9.0)),
              child: Image.network(cat.image, fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Text(
              cat.name,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 20),
            ),
          ),
          
        ],
      ),
    );
  }

  void _navigateToDetailsPage(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(category: category),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Category category;

  const DetailsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(category.image),
            SizedBox(height: 16.0),
            Text(
              category.description,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
