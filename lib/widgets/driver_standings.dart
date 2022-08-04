import 'package:flutter/material.dart';

import '../services/data_provider.dart';
import 'driver.dart';

class DriverStandingsWidget extends StatefulWidget {
  const DriverStandingsWidget({Key? key}) : super(key: key);

  @override
  State<DriverStandingsWidget> createState() => _DriverStandingsWidgetState();
}

class _DriverStandingsWidgetState extends State<DriverStandingsWidget> {
  List<DriverWidget> _standingWidgets = List.empty();

  void initialize() async {
    final standings = await DataProvider.getDriverStandings();
    setState(() {
      _standingWidgets = standings.map((e) => DriverWidget(driver: e.driver)).toList();
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
        )
      );
  }
}