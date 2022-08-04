import 'package:flutter/material.dart';
import 'package:hard_tyre/models/constructors.dart';
import 'package:hard_tyre/services/image_source_provider.dart';

import '../services/color_provider.dart';

class ConstructorWidget extends StatefulWidget {
  const ConstructorWidget({Key? key, required this.constructor}) : super(key: key);
  final Constructor constructor;
  @override
  State<ConstructorWidget> createState() => _ConstructorWidgetState();
}

class _ConstructorWidgetState extends State<ConstructorWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: Container(
        color: ColorProvider.getColor(widget.constructor.constructorId),
        width: 250,
        height: 350,
        child: ListView(
          children: [
            Image.network(ImageSourceProvider.getLogoImageSource(widget.constructor.constructorId), height: 50),
            Image.network(ImageSourceProvider.getCarImageSource(widget.constructor.constructorId)),
            Text(widget.constructor.constructorId),
          ],
        ),
      ),
    );
  }
}