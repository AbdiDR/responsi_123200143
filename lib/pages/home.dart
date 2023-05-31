import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsi_123200143/pages/mealcategory.dart';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> mealcatList = [];
  List<dynamic> filteredMealcatList = [];

  Future<void> fetchMealData() async {
    final response = await http.get(Uri.parse("http://www.themealdb.com/api/json/v1/1/categories.php"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        mealcatList = data['categories'];
        filteredMealcatList = mealcatList;
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
        title: Center(child: Text('Meal Category')),
      ),
      body: ListView.builder(
        itemCount: filteredMealcatList.length,
        itemBuilder: (context, index) {
          final meals = filteredMealcatList[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              tileColor: Colors.white,
              leading: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  child: Image.network(
                    meals['strCategoryThumb'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                meals['strCategory'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
              onTap: () {
                // Handle news item tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealCat(meals: meals),
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

