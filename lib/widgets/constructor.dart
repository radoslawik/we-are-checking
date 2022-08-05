import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/ergast/constructors.dart';
import '../services/color_provider.dart';
import '../services/image_source_provider.dart';

class ConstructorWidget extends StatefulWidget {
  const ConstructorWidget({Key? key, required this.constructor}) : super(key: key);
  final Constructor constructor;
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                  ClipPath(
                    clipper: WidgetClipper(),
                    child: Container(
                      height: 120,
                      width: 600,
                      color: ColorProvider.getColor(widget.constructor.constructorId),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Image.network(ImageSourceProvider.getCarImageSource(widget.constructor.constructorId), scale: 1.4, alignment: Alignment.topRight),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60, top: 50),
                    child: Image.network(ImageSourceProvider.getLogoImageSource(widget.constructor.constructorId), scale: 1.2),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 130, bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.constructor.name,
                              style: GoogleFonts.getFont(
                                'Poppins',
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  letterSpacing: 2
                                )
                              ),)
                          ],
                        )
                      ],
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
    final double xScaling = size.width / 396.5;
    final double yScaling = size.height / 87;
    path.lineTo(0 * xScaling,34 * yScaling);
    path.cubicTo(1 * xScaling,34 * yScaling,47.5 * xScaling,25.4225 * yScaling,71 * xScaling,28.5 * yScaling,);
    path.cubicTo(94.5 * xScaling,31.5775 * yScaling,136.5 * xScaling,46.3438 * yScaling,170 * xScaling,61 * yScaling,);
    path.cubicTo(203.5 * xScaling,75.6562 * yScaling,232.5 * xScaling,85.5 * yScaling,261 * xScaling,85.5 * yScaling,);
    path.cubicTo(289.5 * xScaling,85.5 * yScaling,317.5 * xScaling,82.5 * yScaling,338.5 * xScaling,82.5 * yScaling,);
    path.cubicTo(359.5 * xScaling,82.5 * yScaling,396.5 * xScaling,85.5 * yScaling,396.5 * xScaling,85.5 * yScaling,);
    path.cubicTo(396.5 * xScaling,85.5 * yScaling,396.5 * xScaling,0 * yScaling,396.5 * xScaling,0 * yScaling,);
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