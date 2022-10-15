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

  String? _titlePicture;
  String? _titleAudio;

  String? _description;

  bool isLoadingPicture = false;

  bool isLoadingAudio = false;

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
                onChanged: (newValue) => _titlePicture = newValue,
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
          CardWithLabel(
            'Picture',
            [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _titlePicture != null
                      ? Text('Selected picture: ${_titlePicture!}')
                      : Text(
                          'Please select a picture by press the button bellow'),
                  isLoadingPicture ? CircularProgressIndicator() : SizedBox(),
                  ElevatedButton(
                    onPressed: () async => _pickFile(false),
                    child: const Text('Select a image'),
                  ),
                ],
              ),
            ],
          ),
          CardWithLabel(
            'Audio',
            [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _titleAudio != null
                      ? Text('Selected audio: ${_titleAudio!}')
                      : Text(
                          'Please select a picture by press the button bellow'),
                  isLoadingAudio ? CircularProgressIndicator() : SizedBox(),
                  ElevatedButton(
                    onPressed: () async => _pickFile(true),
                    child: const Text('Select a audio file'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// File picke for image.
  Future<void> _pickFile(bool isAudio) async {
    if (!isAudio) {
      FilePickerResult? result = await FilePickerWeb.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
          onFileLoading: (status) {
            setState(() {
              isLoadingPicture = true;
            });
            return status == FilePickerStatus.picking
                ? isLoadingPicture
                : !isLoadingPicture;
          });
      _log.info('result: $result');
      if (result != null) {
        PlatformFile platformFile = result.files.first;
        _titlePicture = platformFile.name;
        _log.info('_title: $_titlePicture');
        setState(() {
          isLoadingPicture = false;
        });
      } else {
        setState(() {
          isLoadingPicture = false;
        });
        _log.info('User canceled the picker');
      }
    } else {
      FilePickerResult? result = await FilePickerWeb.platform.pickFiles(
          type: FileType.audio,
          allowMultiple: false,
          onFileLoading: (status) {
            setState(() {
              isLoadingAudio = true;
            });
            return status == FilePickerStatus.picking
                ? isLoadingAudio
                : !isLoadingAudio;
          });
      _log.info('result: $result');
      if (result != null) {
        PlatformFile platformFile = result.files.first;
        _titleAudio = platformFile.name;
        _log.info('_title: $_titleAudio');
        setState(() {
          isLoadingAudio = false;
        });
      } else {
        setState(() {
          isLoadingAudio = false;
        });
        _log.info('User canceled the picker');
      }
    }
  }

  void httpRequest() {
    Uri uri = Uri.https(
        'https://api.airtable.com/v0/appqALUeXtEMpYafL/xml%20converter%20app%20data',
        '',
        {'api_key': 'key3tqIhPCOexe0T1'});
  }
}
