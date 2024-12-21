import 'dart:ui';
import 'package:coursecraft/pages/course_home_page.dart';
import 'package:flutter/material.dart';

import 'models.dart';

class HomePage extends StatefulWidget {

  final Course course;
  const HomePage({Key? key, required this.course}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedFilter = 'Popular'; // default filter
  TextEditingController searchController = TextEditingController();

  // Dummy data
  List<Map<String, String>> recentlyViewed = [
    {"title": "Flutter Basics", "imageUrl": "https://via.placeholder.com/150", "description": "Learn the basics of Flutter."},
    {"title": "Advanced Dart", "imageUrl": "https://via.placeholder.com/150", "description": "Become a Dart master."},
  ];

  List<Map<String, String>> courses = [
    {"title": "Intro to UI Design", "imageUrl": "https://via.placeholder.com/300x200", "description": "A beginner’s guide to UI/UX."},
    {"title": "Fullstack Web Dev", "imageUrl": "https://via.placeholder.com/300x200", "description": "From frontend to backend."},
    {"title": "Machine Learning 101", "imageUrl": "https://via.placeholder.com/300x200", "description": "An intro to ML concepts."},
    {"title": "Free Course: Basics of Coding", "imageUrl": "https://via.placeholder.com/300x200", "description": "Learn coding for free."},
    {"title": "Brand New Course on AI", "imageUrl": "https://via.placeholder.com/300x200", "description": "A new course on AI."},
  ];

  List<String> filters = ["Free", "Popular", "New"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter courses based on selectedFilter.
    List<Map<String, String>> filteredCourses = _getFilteredCourses();

    return Scaffold(
      drawer: _buildDrawer(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Menu button leading to the drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Gradient Hero Background
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Wavy White Shape
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
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Greeting & Search
                  Text(
                    "Find your next course",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  _buildSearchBar(context),

                  const SizedBox(height: 24),

                  // Filter Chips
                  _buildFilterChips(context),

                  const SizedBox(height: 32),

                  // Recently Viewed Section
                  Text(
                    "Recently Viewed",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecentlyViewed(context),

                  const SizedBox(height: 32),

                  // Filtered Courses List
                  Text(
                    "$selectedFilter Courses",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: filteredCourses.map((course) => _buildCourseCard(context, course)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // User info area (assuming not logged in for now)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black12,
                    child: const Icon(Icons.person, size: 30, color: Colors.black54),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Guest User",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black12),

            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text("Sign In"),
                    onTap: () {
                      // TODO: handle sign in navigation
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: const Text("Sign Up"),
                    onTap: () {
                      // TODO: handle sign up navigation
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text("Account Details"),
                    onTap: () {
                      // TODO: handle account details navigation
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text("Settings"),
                    onTap: () {
                      // TODO: handle settings
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text("Help & Support"),
                    onTap: () {
                      // TODO: handle help
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.black54),
          hintText: "Search courses...",
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        onChanged: (value) {
          // TODO: Implement search filter logic
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Row(
      children: filters.map((filter) {
        final isSelected = filter == selectedFilter;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                selectedFilter = filter;
              });
            },
            selectedColor: Colors.black87,
            backgroundColor: Colors.black12,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentlyViewed(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recentlyViewed.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final course = recentlyViewed[index];
          return Container(
            width: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(course["imageUrl"]!, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      course["title"]!,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Map<String, String> course) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          MaterialPageRoute route = MaterialPageRoute(builder: (context) => CourseHomePage(course: widget.course));
          Navigator.push(context, route);
        },
        child: Row(
          children: [
            // Course Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: Image.network(
                course["imageUrl"]!,
                fit: BoxFit.cover,
                width: 120,
                height: 100,
              ),
            ),
            const SizedBox(width: 16),
            // Course Title & Description
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course["title"]!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course["description"]!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getFilteredCourses() {
    if (selectedFilter == 'Free') {
      return courses.where((c) => c['title']!.toLowerCase().contains('free')).toList();
    } else if (selectedFilter == 'Popular') {
      // For demonstration, return all (or filter by some criteria)
      return courses;
    } else if (selectedFilter == 'New') {
      return courses.where((c) => c['title']!.toLowerCase().contains('new')).toList();
    }
    return courses;
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Wavy shape at bottom of hero section
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
