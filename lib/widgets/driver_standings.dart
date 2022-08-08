import 'package:flutter/material.dart';

import '../services/api/ergast_data_provider.dart';
import 'driver.dart';

class DriverStandingsWidget extends StatefulWidget {
  const DriverStandingsWidget({Key? key}) : super(key: key);

  @override
  State<DriverStandingsWidget> createState() => _DriverStandingsWidgetState();
}

class _DriverStandingsWidgetState extends State<DriverStandingsWidget> {
  List<DriverWidget> _standingWidgets = List.empty();

  void initialize() async {
    final standings = await ErgastDataProvider.getDriverStandings();
    setState(() {
      _standingWidgets = standings.map((e) => DriverWidget(standing: e)).toList();
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
          Row(
            children: [
              const Icon(
                Icons.face,
                size: 24.0,
              ),
              const SizedBox(width: 5.0),
              Text(
                'Driver standings',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _standingWidgets,
              )
            ),
        ],
      ),
    );
  }
}