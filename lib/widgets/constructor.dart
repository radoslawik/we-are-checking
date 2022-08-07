import 'package:flutter/material.dart';

import '../models/ergast/standings.dart';
import '../services/color_provider.dart';
import '../services/image_source_provider.dart';

class ConstructorWidget extends StatefulWidget {
  const ConstructorWidget({Key? key, required this.standing}) : super(key: key);
  final ConstructorStanding standing;
  @override
  State<ConstructorWidget> createState() => _ConstructorWidgetState();
}

class _ConstructorWidgetState extends State<ConstructorWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 420,
            color: Colors.white,
            child: Stack(
              children: [
                ClipPath(
                  clipper: WidgetClipper(),
                  child: Container(
                      height: 90,
                      width: 420,
                      color: ColorProvider.getColor(
                          widget.standing.constructor.constructorId),
                    ),
                ),
                ClipPath(
                  clipper: WidgetClipper(),
                  child: Container(
                      height: 90,
                      width: 420,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.centerRight,
                              colors: [
                            Colors.black38,
                            Colors.transparent,
                          ],
                              stops: [
                            0.0,
                            0.7,
                          ])),
                      //color: ColorProvider.getColor(widget.constructor.constructorId),
                      child: Image.network(
                          ImageSourceProvider.getCarImageSource(
                              widget.standing.constructor.constructorId),
                          scale: 1.9,
                          alignment: Alignment.topRight)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Image.network(
                      ImageSourceProvider.getLogoImageSource(
                          widget.standing.constructor.constructorId),
                      scale: 1.5),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 10, top: 80, bottom: 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              color: ColorProvider.getColor(
                                  widget.standing.constructor.constructorId),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.standing.constructor.name.toUpperCase(),
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('POINTS',
                                style: Theme.of(context).textTheme.headline6),
                            const SizedBox(width: 5),
                            Text(
                              widget.standing.points,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 397;
    final double yScaling = size.height / 87;
    path.lineTo(0 * xScaling, 23 * yScaling);
    path.cubicTo(
      0 * xScaling,
      23 * yScaling,
      30 * xScaling,
      10.4225 * yScaling,
      55 * xScaling,
      13.5 * yScaling,
    );
    path.cubicTo(
      94.5 * xScaling,
      16.5775 * yScaling,
      136.5 * xScaling,
      46.3438 * yScaling,
      170 * xScaling,
      61 * yScaling,
    );
    path.cubicTo(
      203.5 * xScaling,
      75.6562 * yScaling,
      232.5 * xScaling,
      85.5 * yScaling,
      261 * xScaling,
      85.5 * yScaling,
    );
    path.cubicTo(
      289.5 * xScaling,
      85.5 * yScaling,
      317.5 * xScaling,
      82.5 * yScaling,
      338.5 * xScaling,
      82.5 * yScaling,
    );
    path.cubicTo(
      359.5 * xScaling,
      82.5 * yScaling,
      397 * xScaling,
      85.5 * yScaling,
      396.5 * xScaling,
      85.5 * yScaling,
    );
    path.cubicTo(
      396.5 * xScaling,
      85.5 * yScaling,
      397 * xScaling,
      0 * yScaling,
      396.5 * xScaling,
      0 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

/*
return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: Container(
        color: ColorProvider.getColor(widget.constructor.constructorId),
        width: 350,
        height: 350,
        child: ListView(
          children: [
            Image.network(ImageSourceProvider.getLogoImageSource(widget.constructor.constructorId), height: 50),
            Image.network(ImageSourceProvider.getCarImageSource(widget.constructor.constructorId), height: 80),
            Text(widget.constructor.constructorId),
          ],
        ),
      ),
    );
*/