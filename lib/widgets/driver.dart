import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/ergast/standings.dart';
import '../services/color_provider.dart';
import '../services/image_source_provider.dart';

class DriverWidget extends StatefulWidget {
  const DriverWidget({Key? key, required this.standing}) : super(key: key);
  final DriverStanding standing;
  @override
  State<DriverWidget> createState() => _DriverWidgetState();
}

class _DriverWidgetState extends State<DriverWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),    
            child: Container(
                width: 340,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white,
                        Colors.black,
                        ColorProvider.getColor(widget.standing.constructors.first.constructorId),
                      ],
                      stops: const [
                      0.4,
                      0.4,
                      0.8,
                    ])),
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: DriverBgClipper(),
                      child: Container(
                        width: 235,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                        bottom: 0.0,
                        right: -15.0,
                        child: Image.network(
                          ImageSourceProvider.getDriverImageSource(
                              widget.standing.driver.driverId),
                          scale: 1.5,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.standing.position,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 30,
                                width: 8,
                                color: ColorProvider.getColor(widget
                                    .standing.constructors.last.constructorId),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.standing.driver.givenName
                                        .toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  Text(
                                    widget.standing.driver.familyName
                                        .toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'WINS',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                widget.standing.wins,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Image.network(
                                ImageSourceProvider.getLogoImageSource(widget
                                    .standing.constructors.first.constructorId),
                                scale: 2.2,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                widget.standing.driver.permanentNumber,
                                style: GoogleFonts.poppins(
                                  color: ColorProvider.getColor(widget.standing
                                      .constructors.first.constructorId),
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'POINTS',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                widget.standing.points,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ))),
      ),
    );
  }
}

class DriverBgClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 278;
    final double yScaling = size.height / 150;
    path.lineTo(278 * xScaling, 0 * yScaling);
    path.cubicTo(
      278 * xScaling,
      0 * yScaling,
      271.5 * xScaling,
      34.5 * yScaling,
      271.5 * xScaling,
      57 * yScaling,
    );
    path.cubicTo(
      271.5 * xScaling,
      79.5 * yScaling,
      271.5 * xScaling,
      92 * yScaling,
      255 * xScaling,
      112 * yScaling,
    );
    path.cubicTo(
      238.5 * xScaling,
      132 * yScaling,
      240.5 * xScaling,
      155 * yScaling,
      240.5 * xScaling,
      156 * yScaling,
    );
    path.cubicTo(
      240.5 * xScaling,
      155 * yScaling,
      0 * xScaling,
      155 * yScaling,
      0 * xScaling,
      156 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
