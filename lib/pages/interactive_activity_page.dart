import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models.dart';

class InteractiveActivityPage extends StatefulWidget {
  final InteractiveActivity activity;
  const InteractiveActivityPage({Key? key, required this.activity}) : super(key: key);

  @override
  State<InteractiveActivityPage> createState() => _InteractiveActivityPageState();
}

class _InteractiveActivityPageState extends State<InteractiveActivityPage> {
  late List<MatchingPair> pairs;
  Map<String, String?> userMatches = {};

  @override
  void initState() {
    super.initState();
    pairs = widget.activity.pairs;
    for (var p in pairs) {
      userMatches[p.value] = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leftItems = pairs.map((p) => p.value).toList();
    final rightItems = pairs.map((p) => p.pair).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
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
          // Gradient header background
          Container(
            height: 240,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFA1FFCE), Color(0xFFFBC2EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Wavy white shape at the bottom of header
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: ClipPath(
              clipper: _WaveClipper(),
              child: Container(color: Colors.white),
            ),
          ),

          SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instructions card (floating glass style)
                  Transform.translate(
                    offset: const Offset(0, -60),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            widget.activity.instructions,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Main content area: draggable left column, droppable right column
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left column with draggable items
                      Expanded(
                        child: _buildDraggableList(context, leftItems),
                      ),
                      const SizedBox(width: 40),
                      // Right column with drop targets
                      Expanded(
                        child: _buildDropTargetList(context, rightItems),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Check Answers Button floating at the bottom
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              onPressed: _checkAnswers,
              child: const Text("Check Answers", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableList(BuildContext context, List<String> items) {
    // Each draggable is styled as a pill-shaped card
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Draggable<String>(
            data: item,
            feedback: Material(
              color: Colors.black87.withOpacity(0.8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  item,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropTargetList(BuildContext context, List<String> pairsTexts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: pairsTexts.map((pairText) {
        String? matchedKey;
        userMatches.forEach((key, val) {
          if (val == pairText) matchedKey = key;
        });

        return DragTarget<String>(
          builder: (context, candidateData, rejectedData) {
            bool isHighlighted = candidateData.isNotEmpty;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isHighlighted ? Colors.green : Colors.black12),
                boxShadow: [
                  if (isHighlighted)
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Text(
                matchedKey ?? pairText,
                style: TextStyle(
                  fontWeight: matchedKey != null ? FontWeight.bold : FontWeight.normal,
                  color: matchedKey != null ? Colors.black87 : Colors.black54,
                ),
              ),
            );
          },
          onWillAccept: (data) {
            // Only accept if not already matched
            return !userMatches.values.contains(pairText);
          },
          onAccept: (data) {
            setState(() {
              userMatches[data] = pairText;
            });
          },
        );
      }).toList(),
    );
  }

  void _checkAnswers() {
    bool allCorrect = true;
    for (var p in pairs) {
      if (userMatches[p.value] != p.pair) {
        allCorrect = false;
        break;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Results"),
          content: Text(
            allCorrect
                ? "All matches are correct! Great job."
                : "Some matches are incorrect. Try again.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }
}

/// Custom clipper for a wavy shape at the bottom of the header
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 30)
      ..quadraticBezierTo(
        size.width * 0.25, size.height,
        size.width * 0.5, size.height - 20,
      )
      ..quadraticBezierTo(
        size.width * 0.75, size.height - 40,
        size.width, size.height - 10,
      )
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) => false;
}
