import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:blurhash/blurhash.dart';

class BlurHashImage extends StatefulWidget {
  BlurHashImage(
      {Key key,
      @required this.blurHash,
      @required this.image,
      this.width,
      this.height,
      this.fit = BoxFit.cover})
      : super(key: key);

  final String blurHash;
  final String image;
  final double width;
  final double height;
  final BoxFit fit;

  _BlurHashImageState createState() => _BlurHashImageState();
}

class _BlurHashImageState extends State<BlurHashImage> {
  Uint8List _imageDataBytes;

  @override
  void initState() {
    super.initState();
    blurHashDecode();
  }

  Future blurHashDecode() async {
    Uint8List imageDataBytes;

    try {
      imageDataBytes = await Blurhash.decode(widget.blurHash, 32, 32);
    } on PlatformException catch (e) {
      print(e.message);
    }

    setState(() {
      _imageDataBytes = imageDataBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _imageDataBytes == null
        ? Container(width: widget.width, height: widget.height)
        : FadeInImage.memoryNetwork(
            placeholder: _imageDataBytes,
            image: widget.image,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          );
  }
}
