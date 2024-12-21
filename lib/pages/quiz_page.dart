import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models.dart';

class QuizPage extends StatefulWidget {
  final Quiz quiz;
  const QuizPage({Key? key, required this.quiz}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool showResult = false;
  bool answeredCorrectly = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = widget.quiz.questions[currentQuestionIndex];
    final totalQuestions = widget.quiz.questions.length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // Minimal AppBar: Just a back arrow, no title here
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Gradient background at the top
          Container(
            height: 240,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF70E1F5), Color(0xFFFFD194)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section: "Quiz" Title + Progress
                  _buildQuizHeader(context, currentQuestionIndex, totalQuestions),

                  const SizedBox(height: 40),

                  // If showing result
                  if (showResult)
                    _buildResultSection(context)
                  else
                    _buildQuestionSection(context, question),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizHeader(BuildContext context, int current, int total) {
    // Progress percentage
    double progress = (current + 1) / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Quiz",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Question ${current + 1} of $total",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black87.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.black12,
            color: Colors.black87,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection(BuildContext context) {
    final icon = answeredCorrectly
        ? Icons.check_circle_outline
        : Icons.highlight_off_outlined;
    final iconColor = answeredCorrectly ? Colors.green : Colors.redAccent;
    final text = answeredCorrectly ? "Correct!" : "Incorrect";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 100),
          const SizedBox(height: 24),
          Text(
            text,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: iconColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Done", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionSection(BuildContext context, Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            question.prompt,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Options
        ...List.generate(question.options.length, (i) {
          final isSelected = selectedOptionIndex == i;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedOptionIndex = i;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black87 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.black87 : Colors.black12,
                  width: 1,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Text(
                question.options[i],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 32),

        // Submit button
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: selectedOptionIndex == null
                ? null
                : () {
              final question = widget.quiz.questions[currentQuestionIndex];
              setState(() {
                answeredCorrectly = (selectedOptionIndex == question.correctIndex);
                showResult = true;
              });
            },
            child: const Text("Submit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}
