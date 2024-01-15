import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsmart/provider/course_provider.dart';

class ArticleCategoryPage extends StatelessWidget {
  const ArticleCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    // Utiliser la méthode pour obtenir les catégories distinctes et triées
    List<String> distinctCategories = courseProvider.getDistinctSortedCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles by Category'),
      ),
      body: ListView.builder(
        itemCount: distinctCategories.length,
        itemBuilder: (context, index) {
          final category = distinctCategories[index];

          // Filtrer les cours correspondant à la catégorie actuelle
          List<Course> filteredCourses = courseProvider.filterByCategory(category);

          return ListTile(
            title: Text(category),
            subtitle: Text('Total: ${filteredCourses.length} courses'),
            onTap: () {
              // Naviguer vers une page montrant les cours pour cette catégorie spécifique
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryDetailPage(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryDetailPage extends StatelessWidget {
  final String category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    // Filtrer les cours correspondant à la catégorie actuelle
    List<Course> filteredCourses = courseProvider.filterByCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: filteredCourses.length,
        itemBuilder: (context, index) {
          final course = filteredCourses[index];

          return ListTile(
            title: Text(course.articleName),
            subtitle: Text('Quantity: ${course.quantity}'),
            // Ajouter d'autres détails du cours si nécessaire
          );
        },
      ),
    );
  }
}
