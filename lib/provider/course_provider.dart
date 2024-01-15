import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Ajoutez cette déclaration d'énumération au début du fichier
enum DisplayState {
  all,
  active,
  completed,
}

class Course {
  final int id;
  String articleName;
  String category;
  int quantity;
  bool completed;

  Course({
    required this.id,
    required this.articleName,
    required this.category,
    required this.quantity,
    this.completed = false,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      articleName: json['articleName'],
      category: json['category'],
      quantity: json['quantity'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'articleName': articleName,
      'category': category,
      'quantity': quantity,
      'completed': completed,
    };
  }

  static Course? fromCourse(Course course) {
    // Implémentation de la méthode fromCourse
    return Course(
      id: course.id,
      articleName: course.articleName,
      category: course.category,
      quantity: course.quantity,
      completed: course.completed,
    );
  }
}

class CourseProvider extends ChangeNotifier {
  final List<Course> _courses = [];
  DisplayState _displayState = DisplayState.all;

  CourseProvider() {
    _loadCourses(); // Charger les courses au démarrage de l'application
  }

  DisplayState get displayState => _displayState;

  List<Course> get courses {
    List<Course> filteredCourses = _applyDisplayFilter(_courses);

    return switch (_displayState) {
      DisplayState.completed => filteredCourses.where((t) => t.completed).toList(),
      DisplayState.active => filteredCourses.where((t) => !t.completed).toList(),
      _ => filteredCourses,
    };
  }

  int get allCount => _courses.length;
  int get activeCount => _courses.where((t) => !t.completed).length;
  int get completedCount => _courses.where((t) => t.completed).length;

  bool? get allCompleted {
    bool hasCompletedCourses = _courses.any((course) => course.completed);
    bool hasUncompletedCourses = _courses.any((course) => !course.completed);

    if (hasCompletedCourses && hasUncompletedCourses) {
      return null;
    } else if (hasCompletedCourses) {
      return true;
    } else {
      return false;
    }
  }

  List<Course> _applyDisplayFilter(List<Course> courses) {
    switch (_displayState) {
      case DisplayState.completed:
        return courses.where((t) => t.completed).toList();
      case DisplayState.active:
        return courses.where((t) => !t.completed).toList();
      default:
        return courses;
    }
  }

  List<String> getDistinctSortedArticleNames() {
    // Récupérer tous les noms d'articles distincts
    List<String> distinctArticleNames = _courses.map((course) => course.articleName).toSet().toList();

    // Ordonner les noms d'articles par ordre alphabétique
    distinctArticleNames.sort();

    return distinctArticleNames;
  }

  List<String> getDistinctSortedCategories() {
  // Récupérer toutes les catégories distinctes
  List<String> distinctCategories = _courses.map((course) => course.category).toSet().toList();

  // Ordonner les catégories par ordre alphabétique
  distinctCategories.sort();

  return distinctCategories;
}

// Ajoutez ces deux méthodes
  final Set<String> _checkedLetters = {};

  bool isLetterChecked(String letter) {
    return _checkedLetters.contains(letter);
  }

  void toggleLetterCheck(String letter, bool bool) {
    if (_checkedLetters.contains(letter)) {
      _checkedLetters.remove(letter);
    } else {
      _checkedLetters.add(letter);
    }
    notifyListeners();
  }


  List<Course> filterByCategory(String category) {
    return _courses.where((course) => course.category == category).toList();
  }

  List<Course> filterByName(String name) {
    return _courses.where((course) => course.articleName.toLowerCase().contains(name.toLowerCase())).toList();
  }

  Future<void> _loadCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedCourses = prefs.getString('courses');

    if (storedCourses != null) {
      Iterable decoded = jsonDecode(storedCourses);
      _courses.addAll(decoded.map((course) => Course.fromJson(course)));
      notifyListeners();
    }
  }

  Future<void> _saveCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encoded = jsonEncode(_courses);
    prefs.setString('courses', encoded);
  }

  void addCourse(String articleName, String category, int quantity) {
    var course = Course(
      id: DateTime.now().microsecond,
      articleName: articleName,
      category: category,
      quantity: quantity,
    );
    _courses.add(course);
    _saveCourses(); // Sauvegarder les courses après chaque ajout
    notifyListeners();
  }

  void updateCourse(int courseId, String articleName, String category, int quantity) {
    var foundCourse = _courses.where((t) => t.id == courseId).first;
    foundCourse.articleName = articleName;
    foundCourse.category = category;
    foundCourse.quantity = quantity;
    _saveCourses(); // Sauvegarder les courses après chaque mise à jour
    notifyListeners();
  }

  void toggleComplete(Course course) {
    course.completed = !course.completed;
    _saveCourses(); // Sauvegarder les courses après chaque modification
    notifyListeners();
  }

  void deleteCourse(Course course) {
    _courses.remove(course);
    _saveCourses(); // Sauvegarder les courses après chaque suppression
    notifyListeners();
  }

  void toggleAllCompleted(bool completed) {
    for (var t in _courses) {
      t.completed = completed;
    }
    _saveCourses(); // Sauvegarder les courses après la modification globale
    notifyListeners();
  }

  void updateDisplayState(DisplayState newState) {
    _displayState = newState;
    notifyListeners();
  }

  isCourseChecked(int id) {}

  void toggleCourseCheck(int id, bool bool) {}
}