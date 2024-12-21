
import 'dart:convert';
import 'package:flutter/material.dart';
import 'models.dart';

Future<Course> parseCourse(String jsonStr) async {
  final data = json.decode(jsonStr);

  Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      print('Error parsing color: $hex');
      return Colors.black;
    }
  }

  final themeData = data["theme"];
  final theme = CourseTheme(
    primaryColor: _colorFromHex(themeData["primaryColor"]),
    secondaryColor: _colorFromHex(themeData["secondaryColor"]),
    fontFamily: themeData["fontFamily"],
  );

  List<Module> modules = (data["modules"] as List).map((m) {
    List<Lesson> lessons = (m["lessons"] as List? ?? []).map((l) {
      List<LessonContent> contents = (l["content"] as List? ?? []).map((c) {
        return LessonContent(
          type: c["type"],
          data: c["data"],
          src: c["src"],
          alt: c["alt"],
        );
      }).toList();
      return Lesson(
        id: l["id"],
        title: l["title"],
        content: contents,
      );
    }).toList();

    Quiz? quiz;
    if (m["quiz"] != null) {
      List<Question> qs = (m["quiz"]["questions"] as List).map((q) {
        return Question(
          id: q["id"],
          prompt: q["prompt"],
          options: (q["options"] as List).map((o) => o as String).toList(),
          correctIndex: q["correctIndex"],
        );
      }).toList();
      quiz = Quiz(id: m["quiz"]["id"], questions: qs);
    }

    List<InteractiveActivity> activities = [];
    if (m["interactiveActivities"] != null) {
      activities = (m["interactiveActivities"] as List).map((a) {
        List<MatchingPair> pairs = (a["pairs"] as List).map((p) {
          return MatchingPair(value: p["value"], pair: p["pair"]);
        }).toList();
        return InteractiveActivity(
          id: a["id"],
          type: a["type"],
          instructions: a["instructions"],
          pairs: pairs,
        );
      }).toList();
    }

    return Module(
      id: m["id"],
      title: m["title"],
      description: m["description"],
      lessons: lessons,
      quiz: quiz,
      interactiveActivities: activities,
    );
  }).toList();

  return Course(
    id: data["id"],
    title: data["title"],
    description: data["description"],
    modules: modules,
    theme: theme,
  );
}
