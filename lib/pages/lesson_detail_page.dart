import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models.dart';

class LessonDetailPage extends StatelessWidget {
  final Lesson lesson;
  const LessonDetailPage({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      // AppBar with only a back button and no title
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
          // Hero background section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Stack(
              children: [
                // Gradient background
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Decorative clipped shape overlay
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: _AbstractClipper(),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),

                // Subtle pattern (optional): a semi-transparent overlay
                // You can replace this with a pattern image or remove entirely.
                Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content area
          Positioned.fill(
            top: 0,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 220, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...lesson.content.map((c) {
                      switch (c.type) {
                        case "text":
                          return _buildTextContentCard(context, c.data ?? "");
                        case "image":
                          return _buildImageContentCard(context, c.src ?? "");
                        default:
                          return const SizedBox.shrink();
                      }
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContentCard(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent line
          Container(
            width: 5,
            decoration: BoxDecoration(
              color: theme.primaryColorDark.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  height: 1.7,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContentCard(BuildContext context, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: AspectRatio(
        aspectRatio: 16/9,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  value: (loadingProgress.expectedTotalBytes != null)
                      ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stack) => Container(
            color: Colors.white,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: const Text(
              "Image failed to load",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ),
      ),
    );
  }
}

/// A custom clipper to create a unique abstract shape at the bottom of the hero area.
class _AbstractClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Create a smooth curvy shape
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
  bool shouldReclip(_AbstractClipper oldClipper) => false;
}
