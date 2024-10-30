import 'package:flutter/material.dart';
import 'package:flutter_application_1/Homeview.dart';
void main() {
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library App',
      home: const HomeView(),
    );
  }
}
