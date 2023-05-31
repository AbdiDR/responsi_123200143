import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:responsi_123200143/pages/detail.dart';

class MealCat extends StatefulWidget {
  final dynamic meals;
  const MealCat({Key? key, required this.meals}) : super(key: key);

  @override
  _MealCatState createState() => _MealCatState();
}

class _MealCatState extends State<MealCat> {
  List<dynamic> mealList = [];
  List<dynamic> filteredMealList = [];

  Future<void> fetchMealData() async {
    final response = await http.get(Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.meals['strCategory']}"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        mealList = data['meals'];
        filteredMealList = mealList;
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
        title: Center(child: Text("${widget.meals['strCategory']} Meals")),
      ),
      body: ListView.builder(
        itemCount: filteredMealList.length,
        itemBuilder: (context, index) {
          final meals = filteredMealList[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              tileColor: Colors.white,
              leading: Container(
                width: 100,
                height: 100,
                child: ClipRRect(
                  child: Image.network(
                    meals['strMealThumb'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                meals['strMeal'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
              onTap: () {
                // Handle news item tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detail(meals: meals),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
