import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Page by Mahesh Kattel')),
      body: SafeArea(
        child: Center(
          child: Text('Test Page by Mahesh Kattel'),
        ),
      ),
    );
  }
}
