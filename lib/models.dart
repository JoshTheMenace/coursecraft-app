
import 'package:flutter/material.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final List<Module> modules;
  final CourseTheme theme;
  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.modules,
    required this.theme,
  });
}

class CourseTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final String fontFamily;
  CourseTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.fontFamily,
  });
}

class Module {
  final String id;
  final String title;
  final String description;
  final List<Lesson> lessons;
  final Quiz? quiz;
  final List<InteractiveActivity> interactiveActivities;

  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    required this.quiz,
    required this.interactiveActivities,
  });
}

class Lesson {
  final String id;
  final String title;
  final List<LessonContent> content;

  Lesson({required this.id, required this.title, required this.content});
}

class LessonContent {
  final String type;
  final String? data;
  final String? src;
  final String? alt;

  LessonContent({required this.type, this.data, this.src, this.alt});
}

class Quiz {
  final String id;
  final List<Question> questions;

  Quiz({required this.id, required this.questions});
}

class Question {
  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });
}

class InteractiveActivity {
  final String id;
  final String type; // e.g. "matching"
  final String instructions;
  final List<MatchingPair> pairs;

  InteractiveActivity({
    required this.id,
    required this.type,
    required this.instructions,
    required this.pairs,
  });
}

class MatchingPair {
  final String value;
  final String pair;

  MatchingPair({required this.value, required this.pair});
}
