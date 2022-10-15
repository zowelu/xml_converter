import 'package:flutter/material.dart';

class CardWithLabel extends StatelessWidget {
  const CardWithLabel(
    this._label,
    this._children, {
    Key? key,
  }) : super(key: key);

  final String _label;
  final List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            Column(
              children: _children,
            ),
          ],
        ),
      ),
    );
  }
}
