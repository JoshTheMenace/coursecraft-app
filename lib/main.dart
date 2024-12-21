
import 'package:coursecraft/Home_Page.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'data_parser.dart';
import 'pages/course_home_page.dart';
import 'package:flutter/services.dart' show rootBundle; // For loading assets


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String courseJson = await rootBundle.loadString('assets/data/GEN_JSON.json');

  final course = await parseCourse(courseJson);
  runApp(MyApp(course: course));
}

class MyApp extends StatelessWidget {
  final Course course;
  const MyApp({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: course.title,
      theme: ThemeData(
        primaryColor: course.theme.primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: course.theme.primaryColor),
        fontFamily: course.theme.fontFamily,
      ),
      // home: CourseHomePage(course: course),
      home: HomePage(course: course,),
    );
  }
}
