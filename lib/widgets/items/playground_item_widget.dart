import 'package:flutter/material.dart';
import 'package:hard_tyre/models/data/livetiming/lap_time.dart';
import 'package:hard_tyre/models/media/playground_item.dart';
import 'package:hard_tyre/widgets/items/media_item_widget.dart';
import 'package:hard_tyre/widgets/playground/detailed_lap_comparison_widget.dart';

class PlaygroundItemWidget extends MediaItemWidget {
  const PlaygroundItemWidget({Key? key, required this.item}) : super(key: key);
  final PlaygroundItem item;

  @override
  State<PlaygroundItemWidget> createState() => _PlaygroundItemWidgetState();
}

class _PlaygroundItemWidgetState extends State<PlaygroundItemWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _showDetails,
      padding: EdgeInsets.zero,
      color: Colors.white,
      child: Text(widget.item.title),
    );
  }

  void _showDetails() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DetailedPlaygroundItemWidget(item: widget.item)));
}

class DetailedPlaygroundItemWidget extends StatefulWidget {
  const DetailedPlaygroundItemWidget({Key? key, required this.item})
      : super(key: key);
  final PlaygroundItem item;

  @override
  State<DetailedPlaygroundItemWidget> createState() =>
      _DetailedPlaygroundItemWidgetState();
}

class _DetailedPlaygroundItemWidgetState
    extends State<DetailedPlaygroundItemWidget> {
  DetailedPlaygroundItem? detail;

  Future<DetailedPlaygroundItem> getDetail() async => await widget.item.getData();

  @override
  void initState() {
    super.initState();
    getDetail().then((value) => setState(() {
      detail = value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return _getSpecificWidget();
  }

  Widget _getSpecificWidget() {
    if (detail == null) {
      const SizedBox(
          width: 150,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: CircularProgressIndicator(),
          ));
    } else if (detail is LapPositionComparison) {
      return DetailedLapComparisonWidget(
          comparison: detail as LapPositionComparison);
    }
    return Container();
  }
}
