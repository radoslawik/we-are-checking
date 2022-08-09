import 'package:flutter/material.dart';

class IndicatorWidget extends StatefulWidget {
  const IndicatorWidget(
      {Key? key,
      required this.iconData,
      required this.number,
      required this.thresholds,
      required this.colors})
      : super(key: key);
  final IconData iconData;
  final int number;
  final List<int> thresholds;
  final List<Color> colors;
  @override
  State<IndicatorWidget> createState() => _IndicatorWidgetState();
}

class _IndicatorWidgetState extends State<IndicatorWidget> {
  String formatNumber() {
    final num = widget.number;
    return num > 1000 ? '${num ~/ 1000}k' : num.toString();
  }

  Color getIndicatorColor() {
    var num = widget.number;
    var th = widget.thresholds;
    var ind = num > th.elementAt(1)
        ? 1
        : num > th.elementAt(0)
            ? 0
            : -1;
    return ind != -1 ? widget.colors.elementAt(ind) : Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          widget.iconData,
          color: getIndicatorColor(),
          size: 16.0,
        ),
        Text(
          formatNumber(),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}
