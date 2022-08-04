import 'package:flutter/material.dart';

import '../services/ergast_data_provider.dart';
import 'constructor.dart';

class ConstructorStandingsWidget extends StatefulWidget {
  const ConstructorStandingsWidget({Key? key}) : super(key: key);

  @override
  State<ConstructorStandingsWidget> createState() => _ConstructorStandingsWidgetState();
}

class _ConstructorStandingsWidgetState extends State<ConstructorStandingsWidget> {
  List<ConstructorWidget> _standingWidgets = List.empty();

  void initialize() async {
    final standings = await ErgastDataProvider.getConstructorStandings();
    setState(() {
      _standingWidgets = standings.map((e) => ConstructorWidget(constructor: e.constructor)).toList();
    }); 
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _standingWidgets,
        ),
    );
  }
}