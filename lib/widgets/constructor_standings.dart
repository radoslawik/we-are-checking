import 'package:flutter/material.dart';

import '../services/api/ergast_data_provider.dart';
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
      _standingWidgets = standings.map((e) => ConstructorWidget(standing: e)).toList();
    }); 
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Constructor standings',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _standingWidgets,
              ),
          ),
        ],
      ),
    );
  }
}