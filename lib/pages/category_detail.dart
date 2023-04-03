import 'package:flutter/material.dart';

class CategoryDetail extends StatelessWidget {
  const CategoryDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Detail'),
      ),
      body: const Center(
        child: Text('Category Detail'),
      ),
    );
  }
}
