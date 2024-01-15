import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsmart/provider/course_provider.dart';

class ArticleNamePage extends StatefulWidget {
  const ArticleNamePage({Key? key}) : super(key: key);

  @override
  _ArticleNamePageState createState() => _ArticleNamePageState();
}

class _ArticleNamePageState extends State<ArticleNamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles by Name'),
      ),
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, _) {
          // Utiliser la méthode pour obtenir les noms d'articles distincts et triés
          List<String> distinctArticleNames =
              courseProvider.getDistinctSortedArticleNames();

          return ListView.builder(
            itemCount: distinctArticleNames.length,
            itemBuilder: (context, index) {
              final articleName = distinctArticleNames[index];

              // Filtrer les cours correspondant au nom d'article actuel
              List<Course> filteredCourses =
                  courseProvider.filterByName(articleName);

              // Regrouper les articles par lettre de commencement
              String currentLetter =
                  articleName.isNotEmpty ? articleName[0].toUpperCase() : '';
              String previousLetter = index > 0
                  ? distinctArticleNames[index - 1][0].toUpperCase()
                  : '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0 || currentLetter != previousLetter)
                    // Afficher la lettre comme en-tête de section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        currentLetter,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ListTile(
                    title: Row(
                      children: [
                        Checkbox(
                          value:
                              courseProvider.isLetterChecked(currentLetter),
                          onChanged: (value) {
                            courseProvider.toggleLetterCheck(
                                currentLetter, value ?? false);
                          },
                          checkColor: Colors.white,
                          activeColor: Colors.blue,
                        ),
                        Text(articleName),
                      ],
                    ),
                    subtitle: Text('Total: ${filteredCourses.length} courses'),
                    onTap: () {
                      // Naviguer vers une page montrant les cours pour cet article spécifique
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailPage(articleName: articleName),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final String articleName;

  const ArticleDetailPage({Key? key, required this.articleName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(articleName),
      ),
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, _) {
          // Filtrer les cours correspondant au nom d'article actuel
          List<Course> filteredCourses =
              courseProvider.filterByName(articleName);

          return ListView.builder(
            itemCount: filteredCourses.length,
            itemBuilder: (context, index) {
              final course = filteredCourses[index];

              return ListTile(
                title: Text(course.category),
                subtitle: Text('Quantity: ${course.quantity}'),
              );
            },
          );
        },
      ),
    );
  }
}
