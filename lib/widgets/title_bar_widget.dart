import 'package:flutter/material.dart';
import 'package:hard_tyre/helpers/constants.dart';

class TitleBarWidget extends StatefulWidget {
  const TitleBarWidget({Key? key}) : super(key: key);

  @override
  State<TitleBarWidget> createState() => _TitleBarWidgetState();
}

class _TitleBarWidgetState extends State<TitleBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.surround_sound),
          SizedBox(width: 10),
          Text(Constants.appTitle),
        ],
      ),
    ]);
  }
}
