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
}
