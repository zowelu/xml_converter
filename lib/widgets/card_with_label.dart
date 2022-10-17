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
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        color: Colors.black12,
        border: Border.all(
          color: Colors.black12,
          width: 2.0,
        ),
        boxShadow: const [
          BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
              blurStyle: BlurStyle.outer),
        ],
      ),
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
