import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:xml_converter/widgets/drop_area_widget.dart';

import '../widgets/card_with_label.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Logger _log = Logger('HomePage');

  String? _title;
  String? _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XML converter'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CardWithLabel(
            'Title',
            [
              TextField(
                controller: _titleController,
                onChanged: (newValue) => _title = newValue,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(hintText: 'Input title...'),
              ),
            ],
          ),
          CardWithLabel(
            'Description',
            [
              TextField(
                controller: _descriptionController,
                onChanged: (newValue) => _description = newValue,
                minLines: 1,
                maxLines: 20,
                decoration:
                    const InputDecoration(hintText: 'Input description...'),
              ),
            ],
          ),
          Stack(
            children: [
              DropAreaWidget(),
            ],
          )
        ],
      ),
    );
  }
}
