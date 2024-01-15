import 'package:flutter/material.dart';

class CourseDetailPage extends StatelessWidget {
  final String articleName;
  final String category;
  final int quantity;

  const CourseDetailPage({super.key, 
    required this.articleName,
    required this.category,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Article Name: $articleName"),
            Text("Category: $category"),
            Text("Quantity: $quantity"),
          ],
        ),
      ),
    );
  }
}
