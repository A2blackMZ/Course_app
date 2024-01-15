import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsmart/provider/course_provider.dart';
import 'package:shopsmart/course_dialog.dart';
import 'package:shopsmart/course_detail.dart';  
import 'package:shopsmart/article_name.dart'; 
import 'package:shopsmart/article_category.dart'; 

void _showCourseDialog(BuildContext context, [Course? course]) {
  Course? courseToEdit;
  // Vérification avant édition
  if (course != null) {
    courseToEdit = Course.fromCourse(course);
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CourseDialog(course: courseToEdit),
      );
    },
  );
}

class CourseList extends StatefulWidget {
  const CourseList({Key? key}) : super(key: key);

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        title: const Text("Shopping List"),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              _showCourseDialog(context);
            },
            backgroundColor: const Color.fromARGB(255, 25, 112, 250),
            foregroundColor: const Color.fromARGB(255, 250, 206, 216),
            child: const Icon(Icons.add),
          ),
        ),
      ),
      body: Consumer<CourseProvider>(
        builder: (context, value, child) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        value: value.allCompleted,
                        tristate: true,
                        onChanged: (completed) {
                          value.toggleAllCompleted(completed ?? false);
                        },
                      ),
                      ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          var newState = switch (index) {
                            0 => DisplayState.all,
                            1 => DisplayState.active,
                            _ => DisplayState.completed
                          };
                          final provider =
                              Provider.of<CourseProvider>(context, listen: false);
                          provider.updateDisplayState(newState);
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        selectedColor: Colors.white,
                        fillColor: Colors.black,
                        textStyle: const TextStyle(fontSize: 12),
                        constraints: const BoxConstraints(
                          minHeight: 40.0,
                          minWidth: 90,
                        ),
                        isSelected: [
                          value.displayState == DisplayState.all,
                          value.displayState == DisplayState.active,
                          value.displayState == DisplayState.completed,
                        ],
                        children: [
                          Text("All (${value.allCount})"),
                          Text("In progress (${value.activeCount})"),
                          Text("Finished (${value.completedCount})"),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Rediriger vers la page article_name.dart
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ArticleNamePage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green, 
                            ),
                            child: const Text('Filter by Name'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Rediriger vers la page article_category.dart
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ArticleCategoryPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.blue, 
                            ),
                            child: const Text('Filter by Category'),
                          ),
                        ],

                      ),
                    ],
                  ),
                ),
              ),
              SliverList.separated(
                itemCount: value.courses.length,
                itemBuilder: (context, index) {
                  final course = value.courses[index];

                  return InkWell(
                    onTap: () {
                      // Naviguer vers la page de détails avec les paramètres nécessaires
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(
                            articleName: course.articleName,
                            category: course.category,
                            quantity: course.quantity,
                          ),
                        ),
                      );
                    },
                    child: Dismissible(
                      key: ValueKey(course.id),
                      onDismissed: (direction) {
                        value.deleteCourse(course);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.center,
                        child: const Text(
                          "Supprimer",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      child: CourseItem(course: course),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    color: Colors.grey[100],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final Course course;

  const CourseItem({Key? key, required this.course}) : super(key: key);

  Widget _renderCheckBox() {
    if (!course.completed) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[600]!,
            width: 2,
          ),
        ),
        width: 20,
        height: 20,
        margin: const EdgeInsets.only(top: 6),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      width: 20,
      height: 20,
      margin: const EdgeInsets.only(top: 6),
      alignment: Alignment.center,
      child: const Icon(
        Icons.check,
        size: 14,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              final provider =
                  Provider.of<CourseProvider>(context, listen: false);
              provider.toggleComplete(course);
            },
            child: _renderCheckBox(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.articleName,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    decoration:
                        course.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  course.category,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    decoration:
                        course.completed ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _showCourseDialog(context, course);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
