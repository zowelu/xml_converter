import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../widgets/card_with_label.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final Logger _log = Logger('HomePage');

  String? _title;

  String? _description;

  bool isLoadingPicture = false;

  bool isLoadingFile = false;

  bool isUploading = false;

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
          Container(
            height: 200,
            width: 300,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.blue)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _title != null
                    ? Text(_title!)
                    : Text(
                        'Please select a picture by press the button bellow'),
                ElevatedButton(
                  onPressed: pickPicture,
                  child: isLoadingPicture
                      ? const CircularProgressIndicator()
                      : const Text('Select a image'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickPicture() async {
    FilePickerResult? result = await FilePickerWeb.platform.pickFiles(
        allowMultiple: false,
        onFileLoading: (status) => status == FilePickerStatus.picking
            ? isLoadingPicture
            : !isLoadingPicture);
    _log.info('result: $result');
    if (result != null) {
      /*String? path = result.files.single.path;
      _log.info('path: $path');
      if (path != null) {
        File file = File(path);
        _log.info('file: $file');
      }*/
      PlatformFile platformFile = result.files.first;
      _title = platformFile.name;
      _log.info('_title: $_title');
    } else {
      _log.info('User canceled the picker');
    }
  }
}
