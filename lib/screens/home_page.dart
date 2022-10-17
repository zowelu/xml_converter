import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../widgets/card_with_label.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final Dio _dio = Dio();

  final Logger _log = Logger('HomePage');

  String? _titlePicture;
  String? _titleAudio;

  String? _title;
  String? _description;

  bool isLoadingPicture = false;

  bool isLoadingAudio = false;

  bool isUploading = false;
  PlatformFile? _picture;
  Uint8List? _pictureBytes;
  PlatformFile? _audio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XML converter'),
      ),
      body: SizedBox(
        width: 300,
        child: ListView(
          shrinkWrap: true,
          children: [
            CardWithLabel(
              'Title',
              [
                TextField(
                  controller: _titleController,
                  onChanged: (newValue) {
                    _titlePicture = newValue;
                    _title = newValue;
                  },
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
                        ? Text('Selected picture: ${_titlePicture!}, ')
                        : const Text(
                            'Please select a picture by press the button bellow'),
                    Text(
                        '_picture: name: ${_picture?.name},  size: ${_picture?.size}, extension: ${_picture?.extension}, hashCode: ${_picture?.hashCode},readStream: ${_picture?.readStream}, runtimeType: ${_picture?.runtimeType} identifier: ${_picture?.identifier}'),
                    isLoadingPicture
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            height: 200,
                            width: 200,
                            child: _pictureBytes != null
                                ? Image.memory(_pictureBytes!)
                                : SizedBox()),
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
                        : const Text(
                            'Please select a picture by press the button bellow'),
                    Text(
                        'audio: name: ${_audio?.name},  size: ${_audio?.size}, extension: ${_audio?.extension}, hashCode: ${_audio?.hashCode},readStream: ${_audio?.readStream}, runtimeType: ${_audio?.runtimeType} identifier: ${_audio?.identifier}'),
                    isLoadingAudio
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                    ElevatedButton(
                      onPressed: () async => _pickFile(true),
                      child: const Text('Select a audio file'),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _uploadData();
              },
              child: const Text('Upload data'),
            ),
            ElevatedButton(
              onPressed: () {
                _getData();
              },
              child: const Text('Get data'),
            ),
          ],
        ),
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
        _picture = platformFile;
        _pictureBytes = _picture?.bytes;
        _titlePicture = _picture?.name;
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
        _audio = platformFile;
        _titleAudio = _audio?.name;
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

  Map _createMapFromData(PlatformFile picture, PlatformFile audio) {
    PickedFile _picture = PickedFile(
        picture.name, picture.size, picture.bytes, picture.extension);
    PickedFile _audio =
        PickedFile(audio.name, audio.size, audio.bytes, audio.extension);

    Map map = {
      "records": [
        {
          "fields": {
            {
              "Title": "ahoj",
            },
            {
              "Description": "zdar",
            },
            /*{
              "id": "fldEUfMrSTLKuN0Yb",
              "size": "${_picture._size}",
              "type": "${_picture.extension}",
              "filename": "${_picture._name}",
            },
            {
              "id": "fldnGTssIMT2tHya8",
              "size": "${_picture._size}",
              "type": "${_picture.extension}",
              "filename": "${_picture._name}",
            },*/
          },
        },
      ]
    };
    return map;
  }

  void _getData() async {
    String url =
        'https://api.airtable.com/v0/appqALUeXtEMpYafL/xml%20converter%20app%20data/rec7hY8ib30OiRsuB';

    var response = await _dio.get(
      url,
      options: Options(
        headers: {"Authorization": "Bearer key3tqIhPCOexe0T1"},
      ),
    );
    print('response: $response');
  }

  /// Upload data to Airtable.
  void _uploadData() async {
    String url =
        'https://api.airtable.com/v0/appqALUeXtEMpYafL/xml%20converter%20app%20data';

    var response = await _dio.post(
      url,
      data: _createMapFromData(_picture!, _audio!),
      options: Options(
        headers: {
          "Authorization": "Bearer key3tqIhPCOexe0T1",
          "Content-Type": "application/json"
        },
      ),
    );
    print('response: $response');
  }
}

class PickedFile {
  final String? _name;
  final int? _size;
  final String? _extension;
  final Uint8List? _bytes;

  PickedFile(this._name, this._size, this._bytes, this._extension);

  String? get name => _name;
  int? get size => _size;
  String? get extension => _extension;
  Uint8List? get bytes => _bytes;
}
