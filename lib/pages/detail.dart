import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Detail extends StatefulWidget {
  final dynamic meals;
  const Detail({Key? key, required this.meals}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  dynamic meal;

  Future<void> fetchMealData() async {
    final response = await http.get(Uri.parse(
        "http://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.meals['idMeal']}"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        meal = data['meals'][0];
      });
    }
  }

  @override
  void initState() {
    fetchMealData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Meal Detail")),
      ),
      body: Center(
        child: meal != null
            ? SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${meal['strMeal']}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  meal['strMealThumb'],
                  fit: BoxFit.cover,
                  height: 200,
                  width: 350,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Category: ${meal['strCategory']}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Area: ${meal['strArea']}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Instructions:',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${meal['strInstructions']}',
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8.0),
              ElevatedButton.icon(
                onPressed: () {
                  String url = "${meal['strYoutube']}";
                  _launchUrl(url);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  primary: Colors.green,
                ),
                icon: Icon(Icons.ondemand_video),
                label: Text("Lihat Youtube"),
              ),
            ],
          ),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
