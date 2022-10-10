import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class DropAreaWidget extends StatefulWidget {
  const DropAreaWidget({Key? key}) : super(key: key);

  @override
  State<DropAreaWidget> createState() => _DropAreaWidgetState();
}

class _DropAreaWidgetState extends State<DropAreaWidget> {
  final Logger _log = Logger('DropzoneWidget');

  bool dragging = false;

  Offset localPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DropTarget(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: dragging ? Colors.white12 : Colors.white38,
                  border: Border.all(width: 1, color: Colors.black26)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_copy_sharp,
                    size: 96,
                  ),
                  Text('Drag and drop here')
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future _acceptFile(dynamic event) async {
    _log.info('file added');
    final String? name = event.name;
    _log.info('file name: $name');
  }
}
