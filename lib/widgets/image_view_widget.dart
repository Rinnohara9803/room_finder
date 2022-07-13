import 'dart:io';

import 'package:flutter/material.dart';
import 'package:room_finder/config.dart';

class ImageViewWidget extends StatefulWidget {
  final bool isNetworkImage;
  final String filePath;
  const ImageViewWidget({
    required this.isNetworkImage,
    required this.filePath,
    Key? key,
  }) : super(key: key);

  @override
  State<ImageViewWidget> createState() => _ImageViewWidgetState();
}

class _ImageViewWidgetState extends State<ImageViewWidget>
    with SingleTickerProviderStateMixin {
  final _transformationController = TransformationController();
  TapDownDetails _doubleTapDetails = TapDownDetails();

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }

  AnimationController? _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
        _transformationController.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: double.infinity,
        child: GestureDetector(
          onDoubleTapDown: _handleDoubleTapDown,
          onDoubleTap: _handleDoubleTap,
          child: InteractiveViewer(
            transformationController: _transformationController,
            child: !widget.isNetworkImage
                ? Image(
                    fit: BoxFit.fill,
                    image: FileImage(
                      File(widget.filePath),
                    ),
                  )
                : FadeInImage(
                    placeholder: const AssetImage('images/mainIcon.png'),
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      'http://${Config.authority}/Images/${widget.filePath}',
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
