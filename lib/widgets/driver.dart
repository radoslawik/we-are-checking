import 'package:flutter/material.dart';

import '../services/image_source_provider.dart';
import '../models/ergast/drivers.dart';

class DriverWidget extends StatefulWidget {
  const DriverWidget({Key? key, required this.driver}) : super(key: key);
  final Driver driver;
  @override
  State<DriverWidget> createState() => _DriverWidgetState();
}

class _DriverWidgetState extends State<DriverWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: SizedBox(
        width: 250,
        height: 250,
        child: ListView(
          children: [
            Image.network(ImageSourceProvider.getDriverImageSource(widget.driver.driverId)),
            Text(widget.driver.driverId),
          ],
        ),
      )
    );
  }
}