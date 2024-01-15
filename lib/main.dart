import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsmart/provider/course_provider.dart';
import 'package:shopsmart/course_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      builder: (context, child) {
        return MaterialApp(
          title: 'ShopSmart',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            useMaterial3: true,
          ),
          home: const CourseList(),
        );
      },
    );
  }
}
