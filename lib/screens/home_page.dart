import 'package:flutter/material.dart';

import '../widgets/card_with_label.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('XML converter')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          CardWithLabel('Title', [TextField()]),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
