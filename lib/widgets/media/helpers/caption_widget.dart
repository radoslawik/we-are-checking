import 'package:flutter/material.dart';

class CaptionWidget extends StatelessWidget {
  const CaptionWidget({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        text,
        style: Theme.of(context).textTheme.caption,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
    );
  }
}