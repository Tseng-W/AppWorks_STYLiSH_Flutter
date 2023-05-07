import 'package:flutter/material.dart';

class GetUserMediaPage extends StatelessWidget {
  const GetUserMediaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetUserMediaPage'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: const Center(child: Text('GetUserMediaPage')),
    );
  }
}
